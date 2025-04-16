# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Kategorileri oluştur
# db/seeds.rb

# Önce mevcut verileri temizleyelim (opsiyonel, dikkatli kullanın)
Favorite.delete_all
Product.delete_all
Category.delete_all
User.delete_all

# 1. Kategoriler Oluşturma
puts "Kategoriler oluşturuluyor..."
categories = [
  { name: "T-Shirt" },
  { name: "Pantolon" },
  { name: "Gözlük" },
  { name: "Ceket" },
  { name: "Bardak" }
]

categories.each do |category|
  Category.create!(category)
end

# 2. Ürünler Oluşturma
puts "Ürünler oluşturuluyor..."
products = [
  { name: "Yakalı T-Shirt", inventory_count: 15, category: Category.find_by(name: "T-Shirt") },
  { name: "Uzun Kollu T-Shirt", inventory_count: 50, category: Category.find_by(name: "T-Shirt") },
  { name: "Beyaz Nike T-Shirt", inventory_count: 100, category: Category.find_by(name: "T-Shirt") },
  { name: "Kot Pantolon", inventory_count: 150, category: Category.find_by(name: "Pantolon") },
  { name: "Keten Pantolon", inventory_count: 75, category: Category.find_by(name: "Pantolon") },
  { name: "Güneş Gözlüğü", inventory_count: 20, category: Category.find_by(name: "Gözlük") },
  { name: "Metal Gözlük", inventory_count: 485, category: Category.find_by(name: "Gözlük") },
  { name: "Normal Gözlük", inventory_count: 350, category: Category.find_by(name: "Gözlük") },
  { name: "Deri Ceket", inventory_count: 100, category: Category.find_by(name: "Ceket") },
  { name: "Bomber Ceket", inventory_count: 45, category: Category.find_by(name: "Ceket") },
  { name: "Çay Bardağı", inventory_count: 15, category: Category.find_by(name: "Bardak") },
  { name: "Renkli Bardak", inventory_count: 200, category: Category.find_by(name: "Bardak") },
  { name: "Su Bardağı", inventory_count: 320, category: Category.find_by(name: "Bardak") }
]

products.each do |product|
  Product.create!(product)
end

# 3. Kullanıcılar Oluşturma
puts "Kullanıcılar oluşturuluyor..."
users = [
  { email: "ykahraman@hotmail.com", password: "123456", password_confirmation: "123456" },
  { email: "ilkertoklu.dev@gmail.com", password: "123456", password_confirmation: "123456" }
]

users.each do |user|
  User.create!(user)
end

# 4. Favoriler Oluşturma
puts "Favoriler oluşturuluyor..."
user1 = User.find_by(email: "ykahraman@hotmail.com")
user2 = User.find_by(email: "ilkertoklu.dev@gmail.com")

# user1'in favorileri
Favorite.create!(user: user1, product: Product.find_by(name: "Uzun Kollu T-Shirt"))
Favorite.create!(user: user1, product: Product.find_by(name: "Güneş Gözlüğü"))

# user2'nin favorileri
Favorite.create!(user: user2, product: Product.find_by(name: "Kısa Kollu T-Shirt"))
Favorite.create!(user: user2, product: Product.find_by(name: "Deri Ceket"))

puts "Seed işlemi tamamlandı!"
puts "Kategoriler: #{Category.count}"
puts "Ürünler: #{Product.count}"
puts "Kullanıcılar: #{User.count}"
puts "Favoriler: #{Favorite.count}"