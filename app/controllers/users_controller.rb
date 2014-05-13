class UsersController < ApplicationController
  	before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  	before_action :limit_sign_up,  only: [:new, :create]
  	before_action :correct_user,   only: [:edit, :update]
  	before_action :admin_user,     only: :destroy

  	def destroy
  		User.find(params[:id]).destroy
  		flash[:success] = "User deleted."
  		redirect_to users_url
  	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
	    	flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
      		flash[:success] = "Profile updated"
      		redirect_to @user
		else
			render 'edit'
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

  	def following
    	@title = "Following"
    	@user = User.find(params[:id])
    	@users = @user.followed_users.paginate(page: params[:page])
    	render 'show_follow'
  	end

  	def followers
	    @title = "Followers"
	    @user = User.find(params[:id])
	    @users = @user.followers.paginate(page: params[:page])
	    render 'show_follow'
  	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

	    # Before filters
    	def correct_user
      		@user = User.find(params[:id])
      		redirect_to(root_url) unless current_user?(@user)
    	end

    	def admin_user
      		redirect_to(root_url) unless current_user.admin?
    	end

    	def limit_sign_up
    		if signed_in?
	    		redirect_to root_url, notice: "You already have an account, redirecting to the homepage"
	    	end
    	end
end
