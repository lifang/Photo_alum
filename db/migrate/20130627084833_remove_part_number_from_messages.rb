class RemovePartNumberFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :token
  end
end
