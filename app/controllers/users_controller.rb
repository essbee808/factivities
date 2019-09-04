require 'pry'

class UsersController < ApplicationController

 get '/' do
  @user = User.find_by("id" => session[:id])
  if @user != nil
    erb :'users/show'
  else
    erb :'index'
  end
 end

  get '/registrations/new' do 
  	erb :'users/registrations/new'
  end  

  post '/registrations' do # collects login info
     #persist to database if user email does not exist
     existing_user = User.find_by(:email => params[:user][:email])
      
      if existing_user == nil
        @user = User.create(:email => params[:user][:email], :password => params[:user][:password_digest], :name => params[:user][:name])
        redirect "/success"
      else
        redirect "/failure"
      end
  end

  post '/sessions/login' do
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      @session = session
      @session[:id] = user.id
      redirect to '/'
    else
      erb :'users/error'
    end
  end

  get '/success' do
    erb :'users/registrations/confirmation'
  end

  get '/failure' do
    erb :'users/registrations/error'
  end

  # get '/home/:id' do 
  # 	@user = User.find(params[:id])
  # 	@events = Event.all
  # 	erb :'/users/show'
  # end

  get '/logout' do
  	#render logout page
    session.clear
    session
  	erb :'/users/sessions/logout'
  end

end