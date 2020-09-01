class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :user_admin, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ご登録ありがとうございます。"
      redirect_to @user
    else
      flash.now[:danger] = '登録に失敗しました。'
      render :new
    end
  end

  def show
    @noodles = @user.noodles
  end

  def edit
  end

  def update
    if @user.update_attributes(user_update_params)
      flash[:success] = "更新成功しました"
      redirect_to @user
    else
      flash.now[:danger] = "更新失敗しました"
      render :edit
    end
  end

  def destroy
    if current_user.admin?
       @user.destroy
       flash[:success] = "アカウントを削除しました。"
       redirect_to users_url
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "アカウントを削除しました。またのご利用をお待ちしております。"
      redirect_to root_path
    else
      flash[:danger] = "他社のアカウンは削除できません"
      redirect_to root_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :introduction)
  end

  def correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      flash[:danger] = "アクセス権限がありません"
      redirect_to root_path
    end
  end

  def user_admin
    @users = User.all.page(params[:page]).per(10)
    if current_user.admin == false
      redirect_to root_path
      flash[:danger] = "アクセス権限がありません"
    else
        render action: "index"
    end
  end
end
