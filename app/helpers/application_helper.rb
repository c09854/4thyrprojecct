module ApplicationHelper
  
    def signed_in?
        if session[:user_id].nil?
            redirect_to '/'
        else
            @current_user = User.find_by_id(session[:user_id])
        end
    end
    
    def redirect_to_user
        redirect_to user_path
    end

end
