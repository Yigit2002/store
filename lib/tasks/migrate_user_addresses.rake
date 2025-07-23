# lib/tasks/migrate_user_addresses.rake
namespace :data do
  desc "Migrate address, city, and country from users to addresses table"
  task migrate_user_addresses: :environment do
    puts "Starting migration of user addresses to addresses table..."

    User.find_each do |user|
      # Kullanıcının adres bilgileri varsa
      if user.address.present? || user.city.present? || user.country.present?
        # Yeni bir adres kaydı oluştur
        address = user.addresses.create!(
          title: "Varsayılan Adres", # Varsayılan bir başlık
          body: user.address || "Belirtilmemiş",
          city: user.city || "Belirtilmemiş",
          country: user.country || "Belirtilmemiş"
        )
        puts "Created address for user #{user.id}: #{address.title} - #{address.body}, #{address.city}, #{address.country}"
      else
        puts "No address data found for user #{user.id}, skipping..."
      end
    end

    puts "Migration completed!"
  end
end