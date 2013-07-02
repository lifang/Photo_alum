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
    user = User.find(id)
    messages = params[:message][:content].to_s
    if user
      if user.phone_type && user.phone_type==0
        APNS.host = 'gateway.sandbox.push.apple.com'
        APNS.pem  = File.join(Rails.root, 'pem', 'cert.pem')
        APNS.port = 2195
        #      token = user.token
        token = "52fe9d83 b291edbb 95d9f80d 779209ca 0bae2e72 623a7348 27320fce 267c4c1c"
        APNS.send_notification(token,:alert => messages, :badge => 1, :sound => 'default')
      else
        sendno = '1001'
        receiverType = '1'
        receivervalue = user.token.to_s
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
        puts (Net::HTTP.post_form(URI.parse("http://api.jpush.cn:8800/sendmsg/v2/notification"), map)).body.split(",")[1].split(":")[1]
      end
      Message.create(:content => messages, :user_id => id)
      render :nothing => true
    end
  end
  #  消息群发功能
  def send_many_message
    @admin = Admin.find(1)
    content = params[:content]
    if content && content != ""
      started_at = params[:started_at].nil? || params[:started_at].strip == "" ? "1 = 1" : ["date_format(login_time,'%Y-%m-%d') >=?",params[:started_at].strip]
      ended_at = params[:ended_at].nil? || params[:ended_at].strip == "" ? "1 = 1" : ["date_format(login_time,'%Y-%m-%d') <=?",params[:ended_at].strip]
      city = params[:city].nil? || params[:city].strip == "" ? "1 = 1" : ["city_id = ?", City.find_by_name(params[:city].strip).id]
      @users = User.where(started_at).where(ended_at).where(city)
      if @users
        @users.each do |user|
          if user.phone_type && user.phone_type==0
            APNS.host = 'gateway.sandbox.push.apple.com'
            APNS.pem  = File.join(Rails.root, 'pem', 'cert.pem')
            APNS.port = 2195
            #      token = user.token
            token = "52fe9d83 b291edbb 95d9f80d 779209ca 0bae2e72 623a7348 27320fce 267c4c1c"
            APNS.send_notification(token,:alert => content, :badge => 1, :sound => 'default')
          else
            sendno = '1001'
            receiverType = '1'
            receivervalue = user.token.to_s
            masterSecret = "69d84905cad3ff9382635449"
            input = sendno+ receiverType + receivervalue + masterSecret
            code = Digest::MD5.hexdigest(input)
            map = Hash.new
            map.store("sendno", sendno)
            map.store("app_key", "3a8ed33f0e693055b7663665")
            map.store("receiver_type", receiverType)
            map.store("receiver_value",receivervalue)
            map.store("verification_code", code)
            map.store("txt", content)
            map.store("platform", "android")
            puts (Net::HTTP.post_form(URI.parse("http://api.jpush.cn:8800/sendmsg/v2/notification"), map)).body.split(",")[1].split(":")[1]
          end
          Message.create(:content => content, :user_id =>user.id)
        end
        render :json => {:status =>1, :con_exist =>1}
      else
        render :json => {:status =>0, :con_exist =>1}
      end
    else
      render :json => {:con_exist =>0}
    end
    #    render :nothing => true
  end
#  获取消息集合
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
    if message && message.destroy
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  def send_messaging
  end
  def mass_message
    @admin = Admin.find(1)
    started_at = params[:started_at].nil? || params[:started_at].strip == "" ? "1 = 1" : ["date_format(login_time,'%Y-%m-%d') >=?",params[:started_at].strip]
    ended_at = params[:ended_at].nil? || params[:ended_at].strip == "" ? "1 = 1" : ["date_format(login_time,'%Y-%m-%d') <=?",params[:ended_at].strip]
    city = params[:city].nil? || params[:city].strip == "" ? "1 = 1" : ["city_id = ?", City.find_by_name(params[:city].strip).id]
    @users = User.where(started_at).where(ended_at).where(city)
    #    started_at = params[:started_at]
    #    ended_at = params[:ended_at]
    #    city = params[:city]
    #    if !started_at.empty? && !ended_at.empty?
    #      if !city.empty?
    #        @users= User.find_by_sql("select * from users,cities where date_format(login_time,'%Y-%m-%d')>='#{started_at}' and date_format(login_time,'%Y-%m-%d')<='#{ended_at}' and users.city_id=cities.id and cities.name='#{city}'")
    #      else
    #        @users= User.find_by_sql("select * from users where '#{started_at}'<=date_format(login_time,'%Y-%m-%d') and date_format(login_time,'%Y-%m-%d')<='#{ended_at}'")
    #      end
    #    else
    #      if !city.empty?
    #        @users= User.find_by_sql("select * from users,cities where users.city_id=cities.id and cities.name='#{city}'")
    #      else
    #        @users=User.all
    #      end
    #    end
  end
end
