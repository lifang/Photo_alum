#encoding: utf-8
class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  #  创建消息api
  before_filter :correct_users, :only =>[:send_messaging]
  def correct_users
    if session[:currentuser].nil?
      redirect_to denglu_path, :notice =>"请先登录"
    end
  end
  def send_one
    messages = params[:message][:content].to_s
    APNS.host = 'gateway.sandbox.push.apple.com'
    APNS.pem  = File.join(Rails.root, 'pem', 'cert.pem')
    APNS.port = 2195
    token = '52fe9d83 b291edbb 95d9f80d 779209ca 0bae2e72 623a7348 27320fce 267c4c1c'
    APNS.send_notification(token,:alert => messages, :badge => 1, :sound => 'default')
  end
  def create_m
    unless params[:content].strip.empty? or params[:id].nil?
      id = params[:id]
      content = params[:content]
      user = User.find(id)
      Message.create(:content => content,:token => user.token,:user_id => id)
    end
  end
  def read_messages
   id = params[:id]
   messages = Message.where("user_id ='#{id}'")
   if messages
     render :json => messages
   else
     render :json => 'error'
   end
  end
  #  删除消息api
  def delete
    message = Message.find(params[:id])
    if message.destroy
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  def send_messaging
  end
  def mass_message
    @admin = Admin.find(1)
    started_at = params[:started_at]
    ended_at = params[:ended_at]
    city = params[:city]
    if !started_at.empty? && !ended_at.empty?
      if !city.empty?
        @users= User.find_by_sql("select * from users,cities where date_format(login_time,'%Y-%m-%d')>='#{started_at}' and date_format(login_time,'%Y-%m-%d')<='#{ended_at}' and users.city_id=cities.id and cities.name='#{city}'")
      else
        @users= User.find_by_sql("select * from users where '#{started_at}'<=date_format(login_time,'%Y-%m-%d') and date_format(login_time,'%Y-%m-%d')<='#{ended_at}'")
      end
    else
      if !city.empty?
        @users= User.find_by_sql("select * from users,cities where users.city_id=cities.id and cities.name='#{city}'")
      else
        @users=User.all
      end
    end
  end
end
