-- ==========================================
-- ORDERMYXEROX SUPABASE SCHEMA (IDEMPOTENT / RE-RUNNABLE)
-- ==========================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. ENUMS (Safe creation - will not fail if already exists)
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('customer', 'seller', 'employee', 'admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE order_status AS ENUM ('placed', 'printing', 'ready', 'out_for_delivery', 'completed', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. PROFILES TABLE (Linked to Supabase Auth)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  phone_number TEXT UNIQUE,
  role user_role DEFAULT 'customer'::user_role NOT NULL,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. XEROX SHOPS TABLE
CREATE TABLE IF NOT EXISTS shops (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  shop_name TEXT NOT NULL,
  address TEXT NOT NULL,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  is_verified BOOLEAN DEFAULT FALSE,
  is_open BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  customer_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  shop_id UUID REFERENCES shops(id) ON DELETE CASCADE,
  rider_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Assigned delivery person
  status order_status DEFAULT 'placed'::order_status NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  is_delivery BOOLEAN DEFAULT FALSE,
  delivery_address TEXT,
  pickup_pin VARCHAR(4), -- Secure PIN for pickup/delivery validation
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. ORDER DOCUMENTS (The PDFs/Images to be printed)
CREATE TABLE IF NOT EXISTS order_documents (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  file_url TEXT NOT NULL,
  pages INTEGER DEFAULT 1,
  color_type TEXT DEFAULT 'Black & White',
  copies INTEGER DEFAULT 1
);

-- 6. BANNERS TABLE (For Home Screen Marketing)
CREATE TABLE IF NOT EXISTS banners (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  image_url TEXT NOT NULL,
  target_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. PRODUCTS & SERVICES TABLE
CREATE TABLE IF NOT EXISTS products (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  category TEXT DEFAULT 'general',
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- ── Profiles Policies ────────────────────
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- ── Shops Policies ───────────────────────
DROP POLICY IF EXISTS "Anyone can view open shops" ON shops;
CREATE POLICY "Anyone can view open shops" ON shops FOR SELECT USING (is_verified = true OR auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can insert own shop" ON shops;
CREATE POLICY "Users can insert own shop" ON shops FOR INSERT WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Owners can update own shop" ON shops;
CREATE POLICY "Owners can update own shop" ON shops FOR UPDATE USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Admins have full access to shops" ON shops;
CREATE POLICY "Admins have full access to shops" ON shops FOR ALL USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
);

-- ── Orders Policies ──────────────────────
DROP POLICY IF EXISTS "Customers view own orders" ON orders;
CREATE POLICY "Customers view own orders" ON orders FOR SELECT USING (auth.uid() = customer_id);

DROP POLICY IF EXISTS "Customers can insert own orders" ON orders;
CREATE POLICY "Customers can insert own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = customer_id);

DROP POLICY IF EXISTS "Shops view own orders" ON orders;
CREATE POLICY "Shops view own orders" ON orders FOR SELECT USING (
  auth.uid() IN (SELECT owner_id FROM shops WHERE id = shop_id)
);

DROP POLICY IF EXISTS "Riders view assigned orders" ON orders;
CREATE POLICY "Riders view assigned orders" ON orders FOR SELECT USING (auth.uid() = rider_id);

DROP POLICY IF EXISTS "Admins have full access to orders" ON orders;
CREATE POLICY "Admins have full access to orders" ON orders FOR ALL USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
);

-- ── Order Documents Policies ─────────────
DROP POLICY IF EXISTS "Users view own order documents" ON order_documents;
CREATE POLICY "Users view own order documents" ON order_documents FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_documents.order_id AND (orders.customer_id = auth.uid() OR orders.rider_id = auth.uid()))
);

DROP POLICY IF EXISTS "Customers can insert order documents" ON order_documents;
CREATE POLICY "Customers can insert order documents" ON order_documents FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_documents.order_id AND orders.customer_id = auth.uid())
);

DROP POLICY IF EXISTS "Admins have full access to order docs" ON order_documents;
CREATE POLICY "Admins have full access to order docs" ON order_documents FOR ALL USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
);

-- ── Banners Policies ─────────────────────
DROP POLICY IF EXISTS "Anyone can view active banners" ON banners;
CREATE POLICY "Anyone can view active banners" ON banners FOR SELECT USING (is_active = true);

DROP POLICY IF EXISTS "Admins have full access to banners" ON banners;
CREATE POLICY "Admins have full access to banners" ON banners FOR ALL USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
);

-- ── Products Policies ────────────────────
DROP POLICY IF EXISTS "Anyone can view available products" ON products;
CREATE POLICY "Anyone can view available products" ON products FOR SELECT USING (is_available = true);

DROP POLICY IF EXISTS "Admins have full access to products" ON products;
CREATE POLICY "Admins have full access to products" ON products FOR ALL USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
);

-- ==========================================
-- AUTOMATIC PROFILE TRIGGER (Runs on Auth Sign Up)
-- ==========================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, phone_number, role)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'full_name', 'Customer'),
    new.raw_user_meta_data->>'phone_number',
    'customer'
  )
  ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    phone_number = COALESCE(EXCLUDED.phone_number, profiles.phone_number);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ==========================================
-- ADMIN MANUAL ROLE MANAGEMENT QUERIES
-- ==========================================
-- Run these individually in your Supabase SQL Editor when you want to change roles:

-- 1. Make a user an ADMIN:
-- UPDATE profiles SET role = 'admin' WHERE phone_number = '+919876543210';

-- 2. Make a user a DELIVERY BOY (Employee):
-- UPDATE profiles SET role = 'employee' WHERE phone_number = '+919876543210';

-- 3. Make a user a XEROX SHOP (Seller) and verify their shop:
-- UPDATE profiles SET role = 'seller' WHERE phone_number = '+919876543210';
-- UPDATE shops SET is_verified = TRUE WHERE owner_id = (SELECT id FROM profiles WHERE phone_number = '+919876543210');

-- 4. Demote a user back to normal CUSTOMER:
-- UPDATE profiles SET role = 'customer' WHERE phone_number = '+919876543210';