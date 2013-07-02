class ChangeColumtype < ActiveRecord::Migration

  def change
    rename_column :users, :type, :phone_type
  end

end
