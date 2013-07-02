#encoding: utf-8
class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  #  创建消息api
  require 'uri'
  require 'net/http'
  before_filter :correct_users, :only =>[:send_messaging]
  def correct_users
    if session[:currentuser].nil?
      redirect_to denglu_path, :notice =>"请先登录"
    end
  end
#  对单个用户发送消息推送功能
  def send_one
    id = params[:id]
    p id
    user = User.find(id)
    messages = params[:message][:content].to_s
    if user.phone_type && user.phone_type==0
      APNS.host = 'gateway.sandbox.push.apple.com'
      APNS.pem  = File.join(Rails.root, 'pem', 'cert.pem')
      APNS.port = 2195
      token = user.token
      APNS.send_notification(token,:alert => messages, :badge => 1, :sound => 'default')
    else
      sendno = '1001'
      receiverType = '1'
      receivervalue = user.token
      masterSecret = "69d84905cad3ff9382635449"
      input = sendno+ receiverType + receivervalue + masterSecret
      code = Digest::MD5.hexdigest(input)
      map = Hash.new
      map.store("sendno", sendno)
      map.store("app_key", "3a8ed33f0e693055b7663665")
      map.store("receiver_type", receiverType)
      map.store("receiver_value",receivervalue)
      map.store("verification_code", code)
      map.store("txt", messages)
      map.store("platform", "android")
      puts (Net::HTTP.post_form(URI.parse("http://api.jpush.cn:8800/sendmsg/v2/notification"), map))
      render :nothing => true
    end

    #    
    #    APNS.host = 'gateway.sandbox.push.apple.com'
    #    APNS.pem  = File.join(Rails.root, 'pem', 'cert.pem')
    #    APNS.port = 2195
    #    token = '52fe9d83 b291edbb 95d9f80d 779209ca 0bae2e72 623a7348 27320fce 267c4c1c'
    #    APNS.send_notification(token,:alert => messages, :badge => 1, :sound => 'default')
    #    messages = params[:message][:content].to_s
    #		sendno = '1001'
    #   receiverType = '1'
    #   receivervalue = "867320006366656"
    #		masterSecret = "69d84905cad3ff9382635449"
    #		input = sendno+ receiverType + receivervalue + masterSecret
    #		code = Digest::MD5.hexdigest(input)
    #   p code
    #   map = Hash.new
    #		map.store("sendno", sendno)
    #		map.store("app_key", "3a8ed33f0e693055b7663665")
    #		map.store("receiver_type", receiverType)
    #   map.store("receiver_value",receivervalue)
    #		map.store("verification_code", code)
    #		map.store("txt", messages)
    #		map.store("platform", "android")
    #		puts (Net::HTTP.post_form(URI.parse("http://api.jpush.cn:8800/sendmsg/v2/notification"), map))
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
