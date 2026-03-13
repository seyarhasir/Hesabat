-- Shop Type System & Product Catalog Templates

-- ============================================
-- PRODUCT TEMPLATES TABLE (Global catalog)
-- ============================================
CREATE TABLE product_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_type TEXT NOT NULL CHECK (shop_type IN ('grocery','pharmacy','hardware','electronics','clothing','bakery','restaurant','general')),
  name_dari TEXT NOT NULL,
  name_pashto TEXT,
  name_en TEXT,
  barcode TEXT,
  default_unit TEXT DEFAULT 'piece',
  category_slug TEXT,
  tags TEXT[],
  is_active BOOLEAN DEFAULT true
);

-- Index for fast lookup
CREATE INDEX idx_templates_shop_type ON product_templates(shop_type);
CREATE INDEX idx_templates_search ON product_templates USING GIN(to_tsvector('simple', name_dari));

-- ============================================
-- CATEGORY TEMPLATES TABLE
-- ============================================
CREATE TABLE category_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shop_type TEXT NOT NULL CHECK (shop_type IN ('grocery','pharmacy','hardware','electronics','clothing','bakery','restaurant','general')),
  name_dari TEXT NOT NULL,
  name_pashto TEXT,
  name_en TEXT,
  icon TEXT,
  color TEXT,
  sort_order INTEGER DEFAULT 0
);

CREATE INDEX idx_category_templates_shop_type ON category_templates(shop_type);

-- ============================================
-- SEED GROCERY CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('grocery', 'غلات و آرد', 'Grains & Flour', '🌾', '#F59E0B', 1),
  ('grocery', 'روغن و چربی', 'Oils & Fats', '🛢️', '#EF4444', 2),
  ('grocery', 'چای و قهوه', 'Tea & Coffee', '☕', '#92400E', 3),
  ('grocery', 'لبنیات', 'Dairy Products', '🥛', '#3B82F6', 4),
  ('grocery', 'مواد تمیزکاری', 'Cleaning Products', '🧼', '#10B981', 5),
  ('grocery', 'نوشیدنی', 'Beverages', '🥤', '#8B5CF6', 6),
  ('grocery', 'تنباکو', 'Tobacco', '🚬', '#6B7280', 7),
  ('grocery', 'مواد خشک', 'Dry Goods', '🫘', '#D97706', 8),
  ('grocery', 'تازه‌جات', 'Fresh Produce', '🥬', '#22C55E', 9),
  ('grocery', 'سایر', 'Other', '📦', '#9CA3AF', 10);

-- ============================================
-- SEED PHARMACY CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('pharmacy', 'آنتی‌بیوتیک', 'Antibiotics', '💊', '#EF4444', 1),
  ('pharmacy', 'مسکن‌ها', 'Pain Relief', '💉', '#F59E0B', 2),
  ('pharmacy', 'ویتامین‌ها', 'Vitamins', '🍊', '#F97316', 3),
  ('pharmacy', 'داروهای قلبی', 'Cardiac Medications', '❤️', '#DC2626', 4),
  ('pharmacy', 'داروهای دیابت', 'Diabetes Medications', '🩸', '#3B82F6', 5),
  ('pharmacy', 'پانسمان و زخم', 'Wound Care', '🩹', '#10B981', 6),
  ('pharmacy', 'وسایل پزشکی', 'Medical Devices', '🏥', '#6366F1', 7),
  ('pharmacy', 'داروهای کودکان', 'Pediatric', '👶', '#EC4899', 8),
  ('pharmacy', 'شامپو و پوست', 'Dermatology', '🧴', '#8B5CF6', 9),
  ('pharmacy', 'سایر داروها', 'Other Medications', '💊', '#6B7280', 10);

-- ============================================
-- SEED HARDWARE CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('hardware', 'میله و آهن', 'Steel & Iron', '🔩', '#6B7280', 1),
  ('hardware', 'سیمان و گچ', 'Cement & Plaster', '🏗️', '#9CA3AF', 2),
  ('hardware', 'رنگ و پوشش', 'Paint & Coating', '🎨', '#F59E0B', 3),
  ('hardware', 'لوله و اتصالات', 'Pipes & Fittings', '🔧', '#3B82F6', 4),
  ('hardware', 'ابزار', 'Tools', '🛠️', '#EF4444', 5),
  ('hardware', 'برق و کابل', 'Electrical & Cable', '⚡', '#FCD34D', 6),
  ('hardware', 'پیچ و مهره', 'Bolts & Nuts', '🔩', '#6B7280', 7),
  ('hardware', 'درب و پنجره', 'Doors & Windows', '🚪', '#8B5CF6', 8),
  ('hardware', 'سایر', 'Other', '📦', '#9CA3AF', 9);

-- ============================================
-- SEED ELECTRONICS CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('electronics', 'موبایل', 'Mobile Phones', '📱', '#3B82F6', 1),
  ('electronics', 'لپ‌تاپ', 'Laptops', '💻', '#6366F1', 2),
  ('electronics', 'لوازم جانبی', 'Accessories', '🎧', '#8B5CF6', 3),
  ('electronics', 'تلویزیون', 'TVs & Displays', '📺', '#EF4444', 4),
  ('electronics', 'باتری و شارژر', 'Batteries', '🔋', '#22C55E', 5),
  ('electronics', 'سیم‌کارت و نت', 'SIM & Data', '📶', '#F59E0B', 6),
  ('electronics', 'سایر', 'Other', '📦', '#9CA3AF', 7);

-- ============================================
-- SEED CLOTHING CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('clothing', 'لباس مردانه', 'Men''s Clothing', '👔', '#3B82F6', 1),
  ('clothing', 'لباس زنانه', 'Women''s Clothing', '👗', '#EC4899', 2),
  ('clothing', 'لباس کودکان', 'Children''s Clothing', '👶', '#F59E0B', 3),
  ('clothing', 'پارچه', 'Fabric', '🧵', '#8B5CF6', 4),
  ('clothing', 'کفش', 'Shoes', '👟', '#6B7280', 5),
  ('clothing', 'اکسسوری', 'Accessories', '👜', '#F97316', 6),
  ('clothing', 'سایر', 'Other', '📦', '#9CA3AF', 7);

-- ============================================
-- SEED BAKERY CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('bakery', 'نان', 'Bread', '🍞', '#F59E0B', 1),
  ('bakery', 'شیرینی', 'Pastries', '🥐', '#F97316', 2),
  ('bakery', 'کیک', 'Cakes', '🎂', '#EC4899', 3),
  ('bakery', 'مواد اولیه', 'Raw Ingredients', '🥚', '#FEF3C7', 4),
  ('bakery', 'بسته‌بندی', 'Packaging', '📦', '#9CA3AF', 5);

-- ============================================
-- SEED RESTAURANT CATEGORIES
-- ============================================
INSERT INTO category_templates (shop_type, name_dari, name_en, icon, color, sort_order) VALUES
  ('restaurant', 'غذای اصلی', 'Main Dishes', '🍽️', '#EF4444', 1),
  ('restaurant', 'نوشیدنی', 'Beverages', '🥤', '#3B82F6', 2),
  ('restaurant', 'دسر', 'Desserts', '🍰', '#EC4899', 3),
  ('restaurant', 'صبحانه', 'Breakfast', '🍳', '#F59E0B', 4),
  ('restaurant', 'سفارش خاص', 'Special Orders', '⭐', '#8B5CF6', 5);

-- ============================================
-- SEED SAMPLE PRODUCT TEMPLATES (GROCERY)
-- ============================================
INSERT INTO product_templates (shop_type, name_dari, name_en, default_unit, category_slug) VALUES
  ('grocery', 'برنج', 'Rice', 'kg', 'غلات و آرد'),
  ('grocery', 'آرد', 'Flour', 'kg', 'غلات و آرد'),
  ('grocery', 'روغن', 'Cooking Oil', 'litre', 'روغن و چربی'),
  ('grocery', 'چای سبز', 'Green Tea', 'pack', 'چای و قهوه'),
  ('grocery', 'شیر', 'Milk', 'litre', 'لبنیات'),
  ('grocery', 'ماست', 'Yogurt', 'kg', 'لبنیات'),
  ('grocery', 'صابون', 'Soap', 'piece', 'مواد تمیزکاری'),
  ('grocery', 'نوشابه', 'Soda', 'bottle', 'نوشیدنی'),
  ('grocery', 'سیگار', 'Cigarettes', 'pack', 'تنباکو'),
  ('grocery', 'لوبیا', 'Beans', 'kg', 'مواد خشک');

-- ============================================
-- SEED SAMPLE PRODUCT TEMPLATES (PHARMACY)
-- ============================================
INSERT INTO product_templates (shop_type, name_dari, name_en, default_unit, category_slug) VALUES
  ('pharmacy', 'آموکسیسیلین', 'Amoxicillin', 'strip', 'آنتی‌بیوتیک'),
  ('pharmacy', 'ایبوپروفن', 'Ibuprofen', 'strip', 'مسکن‌ها'),
  ('pharmacy', 'ویتامین C', 'Vitamin C', 'bottle', 'ویتامین‌ها'),
  ('pharmacy', 'پانسمان', 'Bandage', 'piece', 'پانسمان و زخم'),
  ('pharmacy', 'تب سنج', 'Thermometer', 'piece', 'وسایل پزشکی');

-- RLS for templates (readable by all authenticated users)
ALTER TABLE product_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE category_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY templates_read_all ON product_templates
  FOR SELECT TO authenticated USING (true);

CREATE POLICY category_templates_read_all ON category_templates
  FOR SELECT TO authenticated USING (true);
