class User < ActiveRecord::Base
  validates:name,:presence => true,:uniqueness => true
  validates:email,:presence => true,:uniqueness => true
  has_many :photos,:dependent => :destroy
  has_many :messages,:dependent => :destroy
  belongs_to :city
    PER_PAGE_USER = 10
    PER_PAGE_PHOTO = 8
    URL_USER = 'localhost:3000/users/'
end
