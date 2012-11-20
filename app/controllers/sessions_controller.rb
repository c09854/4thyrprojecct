class SessionsController < ApplicationController
  
    
    

    def new
    end

    def create
        user = User.authenticate(params[:session][:email].downcase,params[:session][:password])
        unless user.nil?
            session[:user_id] = user.id
            redirect_to user
        else
            @error = 'Invalid email/password combination' # Not quite right!
        end
    end

    def destroy
        if signed_in?
            session[:user_id] = nil
        else
            flash[:notice] = "you need to sign in first"
        end
          redirect_to signin_path
    end
  
end
