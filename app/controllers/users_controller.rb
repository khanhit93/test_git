class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :correct_admin, only: [:destroy]

  def new
    if logged_in?
      log_out
    end

  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], :per_page => 15)
  end

  def show
  	@user = User.find_by(id: params[:id])
    @microposts = @user.feed.paginate(page: params[:page], :per_page => 15)
    @comment = Comment.new
  	# debug on screen console and treat rails console
  	# debugger
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activate_email
      flash[:success] = t("email.verify")
      redirect_to root_url
      #   log_in @user
  		# flash[:notice] = "Welcome #{@user.name} to sample app"
  		# redirect_to users_path @user
  	else
  		render :new
  	end
  end

  def edit
    @user = User.find params["id"]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      flash[:success] = "Oke"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    name = User.find(params[:id]).name
    User.find_by(id: params[:id]).destroy
    flash[:danger] = "deleted #{name}"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find params[:id]
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find params[:id]
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please login"
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find params[:id]
      if @user != current_user
        flash[:danger] = "You only change your acount !!!"
        redirect_to root_url
      end
    end

    def correct_admin
      if current_user.admin? == false
        redirect_to root_url
        flash[:danger] = "You are not admin"
      end
    end
end
