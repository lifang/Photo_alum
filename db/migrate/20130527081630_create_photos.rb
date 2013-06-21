class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :big_photo_name
      t.string :small_photo_name
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
