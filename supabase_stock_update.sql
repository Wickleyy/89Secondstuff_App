-- =====================================================
-- STOCK MANAGEMENT UPDATE
-- Jalankan di Supabase SQL Editor
-- =====================================================

-- 1. Pastikan kolom stock ada (sudah ada dari schema sebelumnya)
ALTER TABLE products ADD COLUMN IF NOT EXISTS stock INTEGER DEFAULT 1;

-- 2. Set default stock untuk produk yang belum punya
UPDATE products SET stock = 10 WHERE stock IS NULL OR stock = 0;

-- 3. Buat function untuk cek stok menipis
CREATE OR REPLACE FUNCTION check_low_stock()
RETURNS TABLE (
  id BIGINT,
  title VARCHAR,
  stock INTEGER,
  status TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.title,
    p.stock,
    CASE 
      WHEN p.stock = 0 THEN 'Habis'
      WHEN p.stock <= 5 THEN 'Menipis'
      ELSE 'Tersedia'
    END as status
  FROM products p
  WHERE p.stock <= 5
  ORDER BY p.stock ASC;
END;
$$ LANGUAGE plpgsql;

-- 4. View untuk produk dengan stok menipis/habis
CREATE OR REPLACE VIEW v_low_stock_products AS
SELECT 
  p.id,
  p.title,
  p.price,
  p.stock,
  p.image_url,
  c.name as category_name,
  CASE 
    WHEN p.stock = 0 THEN 'Habis'
    WHEN p.stock <= 5 THEN 'Menipis'
    ELSE 'Tersedia'
  END as stock_status
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
WHERE p.stock <= 5
ORDER BY p.stock ASC;

-- 5. Function untuk kurangi stok saat order
CREATE OR REPLACE FUNCTION decrease_product_stock(
  p_product_id BIGINT,
  p_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  current_stock INTEGER;
BEGIN
  -- Get current stock
  SELECT stock INTO current_stock FROM products WHERE id = p_product_id;
  
  IF current_stock IS NULL THEN
    RAISE EXCEPTION 'Product not found';
  END IF;
  
  IF current_stock < p_quantity THEN
    RAISE EXCEPTION 'Insufficient stock';
  END IF;
  
  -- Decrease stock
  UPDATE products 
  SET stock = stock - p_quantity,
      updated_at = NOW()
  WHERE id = p_product_id;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 6. Function untuk restock produk
CREATE OR REPLACE FUNCTION restock_product(
  p_product_id BIGINT,
  p_quantity INTEGER
)
RETURNS INTEGER AS $$
DECLARE
  new_stock INTEGER;
BEGIN
  UPDATE products 
  SET stock = stock + p_quantity,
      updated_at = NOW()
  WHERE id = p_product_id
  RETURNING stock INTO new_stock;
  
  RETURN new_stock;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT SELECT ON v_low_stock_products TO authenticated;
GRANT EXECUTE ON FUNCTION check_low_stock TO authenticated;
GRANT EXECUTE ON FUNCTION decrease_product_stock TO authenticated;
GRANT EXECUTE ON FUNCTION restock_product TO authenticated;

-- Test: Lihat produk dengan stok menipis
-- SELECT * FROM v_low_stock_products;
