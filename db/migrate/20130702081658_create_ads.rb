class CreateAds < ActiveRecord::Migration
  def change
  create_table :ads do |t|
    t.text :content 
  end
  end
end
