class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.json
  #上传照片api
  require 'fileutils'
  require "rubygems"
  require "mini_magick"
  def upload
    begin
#      上传原图片
      user_id = params[:id]
      user = User.find_by_id(user_id)
      status = params[:status]
      describe = params[:describe]
      FileUtils.mkdir_p "#{File.expand_path(Rails.root)}/public/uploads/#{user_id}" if !(File.exist?("#{File.expand_path(Rails.root)}/public/uploads/#{user_id}"))
      image = params[:img]
      filename = image.original_filename
      fileext = File.basename(filename).split(".")[1]
      timeext = user_id.to_s+Time.now.strftime("%Y%m%dT%H%M%S")
      photo_big_name = Photo.find_by_big_photo_name(timeext+"."+fileext)
      if photo_big_name
        timeext = timeext + "1"
      end
      newfilename = timeext+"."+fileext
      File.open("#{Rails.root}/public/uploads/#{user_id}/#{newfilename}","wb") {
        |f| f.write(image.read)
      }
      file_path = "#{Rails.root}/public/uploads/#{user_id}/#{newfilename}"   #获取到路径
      img = MiniMagick::Image.open file_path,"rb"
      #图片添加水印
      my_text = user.name.to_s
      img.combine_options do |c|
        c.gravity 'SouthWest'
        c.pointsize '50'
        c.fill"white"
        c.draw "text 10,0 '#{my_text}'"
      end
      img.write(file_path)

      img1 = MiniMagick::Image.open file_path,"rb"
      #    缩小图片 上传进服务器中
      Photo::PHOTO_SIZE.each do |size|
        resize = size>img1["width"] ? img1["width"] :size
        new_file = file_path.split(".")[0]+"_"+resize.to_s+"."+file_path.split(".").reverse[0]
        resize_file_name = timeext+"_100."+fileext
        img1.run_command("convert #{file_path} -resize #{resize}x#{resize} #{new_file}")
        Photo.create(:big_photo_name => newfilename,:small_photo_name =>resize_file_name,:user_id => user_id,:status => status,:describe => describe)
      end
      photo=Photo.find_by_big_photo_name(newfilename)
      if photo
        render :json => photo
      else
        render :json => "error"
      end
    rescue
      render :json =>'error'
    end
  end
  # 手机端获取图片
  def download
    user_id = params[:id]
    status = params[:status]
    photos = Photo.where(["user_id = ?",user_id]).where(["status = ?",status])
    if photos
      render :json => photos
    else
      render :json =>'error'
    end
  end
  #删除照片api
  def delete
    photo = Photo.find(params[:id])
    if photo.destroy
      path1 = "#{Rails.root}/public/uploads/#{photo.user_id}/#{photo.big_photo_name}"
      path2 = "#{Rails.root}/public/uploads/#{photo.user_id}/#{photo.small_photo_name}"
      object_file1 = File.new(path1, "w+")
      object_file2 = File.new(path2, "w+")
      object_file1.close
      object_file2.close
      File.delete(path1)
      File.delete(path2)
      render :json =>'success'
    else
      render :json =>'error'
    end
  end
  
  def show
    @photo = Photo.find(params[:id])
    user_id = @photo.user_id.to_i
    @user = User.find(user_id)
    #      @photos = Photo.find_by_user_id(user_id)
    status = @photo.status
    if status==1
      @photos = Photo.find_by_sql("select * from photos where user_id = #{user_id} and status =1")
    else
      @photos = Photo.find_by_sql("select * from photos where user_id = #{user_id} and status =0")
    end
    @status = status
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end
  def replace_big_photo
    pid = prams[:photo_id].to_i
    @photo = Photo.find_by_id pid
    if @photo
      render :json => {:status =>1, :photo => @photo }
    else
      render :json => {:status =>0}
    end
  end
  def replace_bigphotos
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
    if @photos
      render "/users/show"
    end
  end
end
