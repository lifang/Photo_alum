class AdminsController < ApplicationController
  #管理员登录
  def admin_denglu
    if session[:currentuser].nil?
      @title = "Sign in"
      render :newdl
    else
      redirect_to index_path
    end
  end
  def admin_login
    name = params[:admin][:name]
    password = params[:admin][:password]
    @admin = Admin.find_by_name_and_password(name,password)
    session[:currentuser] = nil
    if @admin
      session[:currentuser] = @admin.id
      redirect_to index_path
    else
      redirect_to denglu_path
    end
  end
  #  打开关闭注册
  def registerornot
    id = session[:currentuser]
    @admin = Admin.find_by_id(id)
    if @admin.status==0
      if @admin.update_attribute(:status, "1")
        render :json =>{:status => 1,:a_status => @admin.status}
      else
        render :json =>{:status => 0,:a_status => @admin.status}
      end
    else
      if @admin.update_attribute(:status, "0")
        render :json => {:status =>1,:a_status => @admin.status}
      else
        render :json => {:status =>0,:a_status => @admin.status}
      end
    end
  end
  #  设置是否可查看
  def checkornot
    @user = User.find_by_id(params[:id])
    if @user.status==0
      if  @user.update_attribute(:status, "1")
        render :json=>{:status => 1,:u_status => @user.status}
      else
        render :json=>{:status => 0,:u_status => @user.status}
      end
    else
      if @user.update_attribute(:status, "0")
        render :json=>{:status => 1,:u_status => @user.status}
      else
        render :json=>{:status => 0,:u_status => @user.status}
      end
    end
  end
  def cities_change
    city_id = params[:cid]
    @users = User.find_all_by_city_id(city_id)
  end
end
