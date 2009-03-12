class HomeController < ApplicationController
  def about
    @about = AboutUs.find(:first)
    @about.text = @about.text.gsub("\n", "<br />")
    if @about.nil?
      @about = AboutUs.new(:text=>"Please edit")
      @about.save
    end
  end
  
  def neighborhood
    @user = User.find(session[:user_id])
    if params[:user]
      @user.status = params[:user][:status]
      @user.save
    end
    @posts = Post.find(:all, :conditions => ["user_id in (select user_id_1 from friends where user_id_2=#{session[:user_id]} and accepted=1) or user_id in (select user_id_2 from friends where user_id_1=#{session[:user_id]} and accepted=1)"], :order => "created_at DESC")
  end
  
  def index
    #pull in posts
    @posts = Post.find(:all, :conditions => ["home_page = 1"], :order => "created_at DESC")
    @news = Post.find(:all, :conditions => ["news = 1"], :order => "created_at DESC")
  end
  
  def community
    unless session[:user_id]
      redirect_to :action => :index
    end
    @posts = Post.find(:all, :conditions => ["community_page = 1"], :order => "created_at DESC")
  end
  
  def edit_about_us
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :action => :index
    end
    @about = AboutUs.find(:first)
  end
  
  def edit_about_us_backend
    unless User.find_by_id(session[:user_id]).admin
      redirect_to :action => :index
    end
    @about = AboutUs.find(:first)
    @about.text = params[:about][:text]
    if @about.save
      redirect_to :action => :about
    else
      redirect_to :action => :edit_about_us
    end
  end
end
