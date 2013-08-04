class UsersController < ApplicationController
  #before_action :signed_in_user, only: [:edit, :update]   #rails 4.0
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  before_filter :nonsign_user, only:[:create, :new]
  def index #index action
    @users = User.paginate(page: params[:page], per_page: 20)
    #@users = User.paginate(page: params[:page], per_page: 20).order('id DESC')
    #per_page display: 20 users
    #render :json => @users.to_json
    #return
  end 

  def destroy
    User.find(params[:id]).destroy
    flash[:success]= "User destroyed."
    redirect_to users_url
  end
    
  def create
  	#@user = User.new(user_params) # Not the final implementation!
    @user = User.new(params[:user])
  	if @user.save
  		# Handle a successful save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #redirect_to user_url
  	else
  		render 'new'
  	end
  end

  def show
    @user = User.find(params[:id])
    @microposts= @user.microposts.paginate(page: params[:page])
  	#render :json => @user.to_json
  	#return
  end

  def new
  	@user = User.new
  end

  def edit 
    @user = User.find(params[:id])
  end

  def update 
    if @user.update_attributes(params[:user]) #user_params   #rails 4
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    # Strong pamnent #rails 4
    #def user_params
    #		params.require(:user).permit(:name,:email,:password,:password_confirmation)
    #end

    # Before filters
      def correct_user
        @user =User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)      
      end

      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end

      def nonsign_user
        if signed_in?
          redirect_to(root_url)
        end  
      end
end
