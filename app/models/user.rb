#encoding: utf-8
require 'will_paginate/array'

class User < ActiveRecord::Base
  validates:name,:presence => true,:uniqueness => true
  validates:email,:presence => true,:uniqueness => true
  has_many :photos,:dependent => :destroy
  has_many :messages,:dependent => :destroy
  belongs_to :city
  PER_PAGE_USER = 10
  PER_PAGE_PHOTO = 8
  URL_USER = 'localhost:3000/users/'
  COMMEN_USER = 2
  def self.user_all(page)
    nocity_users = User.find_by_sql("select users.id, users.describle describle,c.name name,p.small_photo_name small_photo
                      from users left join cities c on users.city_id = c.id
                      left join photos p on users.id = p.user_id
                      where  p.status = 1 group by users.id")
    nocoty_user = User.find_by_sql("select users.id, users.describle describle,c.name name,p.small_photo_name small_photo
                      from users left join cities c on users.city_id = c.id
                      left join photos p on users.id = p.user_id
                      where p.status = 1 group by users.id").paginate(:page =>page , :per_page =>User::COMMEN_USER)
    count_users = nocity_users.count
    page_counts = count_users/User::COMMEN_USER
    p_counts = count_users%User::COMMEN_USER
    if p_counts!=0
      page_counts += 1
    end
    return {:user => nocoty_user,:page => page_counts, :current_city => 'error'}
  end
end
