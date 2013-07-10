#encoding: utf-8
require 'will_paginate/array'
class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  layout "application", :except => "show"
  before_filter :correct_user, :only =>[:index]
  def correct_user
    if session[:currentuser].nil?
      redirect_to denglu_path, :notice =>"请先登录"
    end
  end
#  获取同城用户
  def users_citys
    city_name = params[:name]
    city = City.find_by_name(city_name)
    if city
      city_id = city.id
      user = User.find_by_sql("select users.id, users.describle describle,c.name name,p.small_photo_name small_photo
                      from users left join cities c on users.city_id = c.id
                      left join photos p on users.id = p.user_id
                      where c.id =#{city_id} and p.status = 1 group by users.id")
      if user
        render :json => user
      else
        render :json => "nouser"
      end
    else
      City.create(:name => city_name)
      render :json => "nouser"
    end
  end

  #  用户列表页面
  def index
    name_sql = params[:name].nil? || params[:name].strip == "" ? "1 = 1" : ["name like ?", "%#{params[:name].strip}%"]
    url_sql = params[:url].nil? || params[:url].strip.blank? ? "1=1" : ["url = ?", params[:url].strip]
    city_sql = params[:city_city_id].to_i == 0 ? " 1= 1" : ["city_id = ?", params[:city_city_id].to_i]
    @cities = City.all
    @users = User.where(name_sql).where(url_sql).where(city_sql).paginate(:page => params[:page] ||= 1, :per_page => 2)
    @admin = Admin.find_by_id(1)
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
  #  登录api
  def user_signin
    name = params[:name]
    password = params[:password]
    token = params[:token]
    type = params[:type].to_i
    user = User.find_by_name_and_password(name,password)
    login_time = Time.now.to_s
    if  user
      if token
        if user.update_attributes({:token => token,:login_time => login_time,:phone_type => type})
          users = User.find_by_name_and_password(name,password)
          render :json => users
        end
      else
        if user.update_attributes(:login_time => login_time,:phone_type => type)
          users = User.find_by_name_and_password(name,password)
        end
        render :json => users
      end
    else
      render :json => 'error'
    end
  end
  #  修改token  api
  def edittoken
    token = params[:token]
    id = params[:id]
    user = User.find_by_id(id)
    if token
      user.update_attributes(:token => token)
      render :json => 'success'
    else
      render :json => 'error'
    end
  end
  #  注册api
  def register
    admin = Admin.find_by_id(1)
    if admin && admin.status == 1
      name = params[:name]
      password = params[:password]
      email = params[:email]
      user_name = User.find_by_name(name)
      if user_name
        render :json => 'nameerror'
      else
        user_email = User.find_by_email(email)
        if user_email
          render :json => 'emailerror'
        else
          user = User.new('name' => name,'password' => password,'email' => email,'status'=> '1')
          if user.save
            url =  User::URL_USER+"#{user.id}".to_s
            if user.update_attributes(:url => url)
              render :json => user
            end
          else
            render :json =>"error"
          end
        end
      end
    else
      render :json =>"close"
    end
  end
  #  找回密码api
  def forget_pwd
    name = params[:name]
    email = params[:email]
    user = User.find_by_name_and_email(name,email)
    if user
      render :json => user
    else
      render :json =>'error'
    end
  end
  #  修改密码api
  def change_pwd
    name = params[:name]
    email = params[:email]
    user = User.find_by_name_and_email(name,email)
    password = params[:password].to_s
    if user
      if  user.update_attributes(:password => password)
        render :json =>'success'
      else
        render :json =>'error'
      end
    else
      render :json =>'emailerror'
    end
  end
  #  修改相册密码api
  def album_pwd
    user = User.find(params[:id])
    photo_password = params[:photo_password]
    if user.update_attributes(:photo_password => photo_password)
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  #  修改个人描述api
  def change_describle
    user = User.find(params[:id])
    describle = params[:describle]
    if user.update_attributes(:describle => describle)
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  #  修改邮箱api
  def change_email
    id = params[:id]
    email = params[:email]
    user = User.find_by_email(email)
    if user
      render :json =>'emailerror'
    else
      users = User.find(id)
      if users.update_attributes(:email => email)
        render :json =>'success'
      else
        render :json =>'error'
      end
    end
  end
  #  修改所在地api
  def change_city
    user = User.find(params[:id])
    city_name = params[:name]
    city = City.find_by_name(city_name)
    if city
      city_id = city.id
      if user.update_attributes(:city_id => city_id)
        render :json =>'success'
      else
        render :json =>'error'
      end
    else
      if citys = City.create('name' => city_name)
        city_id = citys.id
        if user.update_attributes(:city_id => city_id)
          render :json =>'success'
        else
          render :json =>'error'
        end
      else
        render :json => 'notcreate'
      end
    end
  end
  #  注销用户api
  def destroy_user
    user = User.find_by_id(params[:id])
    if  user && user.destroy
      FileUtils.remove_dir "#{File.expand_path(Rails.root)}/public/uploads/#{user.id}" if  FileTest.directory?("#{File.expand_path(Rails.root)}/public/uploads/#{user.id}")
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  def show
    user_id = params[:id]
    if session[:user_id] != user_id
      session[:photopwd] = nil
    end
    session[:user_id] = user_id
    @user = User.find(user_id)
    if @user.status == 0
      render :private
    end
    #    photo_pwd = show_pwd
    @photos = Photo.find_by_sql("select * from photos where user_id = '#{user_id}' and status = 1").paginate(:page => params[:page] ||= 1, :per_page => User::PER_PAGE_PHOTO)
    @page = params[:page]||1
    @ads = Ads.find(1)
    @pub_pho = 1

     p @pub_pho
    render :layout => nil
  end
  def show_pwd
    if session[:photopwd]
      @photo_pwd = session[:photopwd]
      user_id = session[:user_id]
    else
      @photo_pwd = params[:user][:photo_password]
      user_id = params[:user_id]
    end
    @user = User.find_by_photo_password_and_id(@photo_pwd,user_id)
    @photos = @user.photos.where(:status => 0).paginate(:page => params[:page] ||= 1, :per_page => User::PER_PAGE_PHOTO)  if @user
    if @user
      session[:photopwd] = @photo_pwd
    end
    @page = params[:page]||1
    @ads = Ads.find(1)
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end

  end
  def destroy
    @user = User.find(params[:id])
    FileUtils.remove_dir "#{File.expand_path(Rails.root)}/public/uploads/#{@user.id}" if @user.destroy && FileTest.directory?("#{File.expand_path(Rails.root)}/public/uploads/#{@user.id}")
    respond_to do |format|
      format.html { redirect_to index_path }
      format.json { head :no_content }
    end
  end
  #  def search
  #    name = params[:name].strip.blank? ? "1=1" : ["name like ?", "%#{params[:name].strip}%"]
  #    url = params[:url].strip.blank? ? "1=1" : ["url = ?", "#{params[:url].strip}"]
  #    @users = User.where(name).where(url).paginate(:page => params[:page] ||= 1, :per_page => User::PER_PAGE_USER)
  #    @cities = City.all
  #  end
end