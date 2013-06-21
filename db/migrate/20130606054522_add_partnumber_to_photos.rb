class AddPartnumberToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :describe, :string
  end
end