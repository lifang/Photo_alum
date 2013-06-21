class City < ActiveRecord::Base
  has_many :users, :foreign_key => "user_id"
end
