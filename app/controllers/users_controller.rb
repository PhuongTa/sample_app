class UsersController < ApplicationController
  
  def create
  	#@user = User.new(user_params) # Not the final implementation!
    @user = User.new(params[:user])
  	if @user.save
  		# Handle a successful save
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
  	#render :json => @user.to_json
  	#return
  end

  def new
  	@user = User.new
  end

  #private
  #def user_params
  		#params.require(:user).permit(:name,:email,:password,:password_confirmation)
  #end
end
