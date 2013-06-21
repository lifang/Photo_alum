class Photo < ActiveRecord::Base
  belongs_to :user
  PHOTO_SIZE = [100]
end
