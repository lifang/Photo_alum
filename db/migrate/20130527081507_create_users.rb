class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :email
      t.string :url
      t.integer :status
      t.string :describle
      t.integer :city_id
      t.datetime :login_time
      t.string :token
      t.string :photo_password

      t.timestamps
    end
  end
end
