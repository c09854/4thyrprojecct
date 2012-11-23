class ApplicationController < ActionController::Base
    include ApplicationHelper
    protect_from_forgery
  
    def authorise
        unless signed_in?
            redirect_to signin_path, :notice => "Please sign in to access this page." unless request.env['PATH_INFO'] == '/signin'
        end
    end
   
    def store_location
       session[:return_to] = request.fullpath
    end
    
    def redirect_to_user
        redirect_to user_path
    end
    
    private
    def current_user
        @current_user = User.find(session[:user_id])
    end 
end
