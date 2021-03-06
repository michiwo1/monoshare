# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Category.all.blank?
  Category.transaction do
    %w(家電 書籍 日用品 衣類 ゲーム 文房具 乗り物 ヘルスケア ビューティー).each do |name|
      Category.create!(name: name)
    end
  end
end

# rails db:seed