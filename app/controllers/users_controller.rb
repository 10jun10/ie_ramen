class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

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
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_update_params)
      flash[:success] = "更新成功しました"
      redirect_to @user
    else
      flash.now[:danger] = "更新失敗しました"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "アカウントを削除しました。またのご利用をお待ちしております。"
    redirect_to root_path
  end

  private

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
end
