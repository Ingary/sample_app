class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, 
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page], :per_page => 30)
  end

  def show
   @user = User.find(params[:id])
   @microposts = @user.microposts.paginate(page: params[:page], :per_page => 10)
  end

  def new
    if signed_in?
      redirect_to root_url, notice: "Sorry. You can’t add new user."
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      redirect_to root_url, notice: "Sorry. You can’t add new user."
    else
      @user = User.new(user_params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user #Note that we can omit the user_url in the redirect, 
        #writing simply redirect_to @user to redirect to the user show page.
      else
        render 'new'
      end
    end
  end

  #Now that the correct_user before filter defines @user, we can omit it from both edit and update.
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #Web browsers can’t send DELETE requests natively, so Rails fakes them with JavaScript. This means 
  #that the delete links won’t work if the user has JavaScript disabled. 
  def destroy
    @user = User.find(params[:id])
    if @user.admin
      flash[:error] = "You can’t delete yourself."
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
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
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
