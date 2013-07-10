class Photo < ActiveRecord::Base
  belongs_to :user
  PHOTO_SIZE = [200]
end
