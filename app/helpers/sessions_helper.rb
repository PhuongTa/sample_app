module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token,User.encrypt(remember_token))
		self.current_user= user
	end

	def signed_in?
    	!current_user.nil? # ! mean not operator
  	end

	def current_user=(user) #Defining assignment to current_user.
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by_remember_token(remember_token)
	end
	
	def current_user?(user)
		user == current_user
	end

	#Move from user-controller ???? Tai sao move qua day lai co the su dung trong micropost controller
	def signed_in_user
        # unless signed_in?
        unless signed_in?
          store_location
          #flash[:notice] ="Please sign in."
          #redirect_to signin_url
          redirect_to signin_url, notice: "Please sign in."
        end
     end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	# friendly forward
	def redirect_back_or(default)
		redirect_to(session[:return_to]|| default)
		session.delete(:return_to)
	end

	def store_location 
		session[:return_to] = request.url
	end
end
