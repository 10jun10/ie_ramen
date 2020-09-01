class NoodlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @noodles = Noodle.all.page(params[:page]).per(10)
  end

  def new
    @noodle = Noodle.new
  end

  def create
    @noodle = current_user.noodles.build(noodle_params)
    if @noodle.save
      flash[:success] = "家ラーメンが投稿されました"
      redirect_to noodle_path(@noodle)
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new
    end
  end

  def show
    @noodle = Noodle.find(params[:id])
  end

  def edit
    @noodle = Noodle.find(params[:id])
  end

  def update
    @noodle = Noodle.find(params[:id])
    if @noodle.update_attributes(noodle_params)
      flash[:success] = "家ラーメンが更新されました"
      redirect_to @noodle
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @noodle = Noodle.find(params[:id])
    if current_user.admin? || current_user?(@noodle.user)
      @noodle.destroy
      flash[:success] = "家ラーメンが削除されました"
      redirect_back(fallback_location: root_url)
    else
      flash.now[:danger] = "他人の家ラーメンは削除できません"
      redirect_to root_url
    end
  end

  private

  def noodle_params
    params.require(:noodle).permit(:name, :maker, :place, :eat, :image)
  end

  def correct_user
    @noodle = current_user.noodles.find_by(id: params[:id])
    redirect_to root_url if @noodle.nil?
  end
end
