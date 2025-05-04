# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


super_admin = User.find_or_create_by!(username: 'superadmin') do |user|
  user.password = 'Buituantu2003@'
  user.role = 'SuperAdmin'
  user.admin_level = 'SuperAdmin'
  user.school_id = nil
  user.created_at = Time.now
  user.updated_at = Time.now
end

puts "Created Super Admin: #{super_admin.username}"