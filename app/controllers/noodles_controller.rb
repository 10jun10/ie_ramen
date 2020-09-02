class NoodlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_noodle, only: [:show, :edit, :update, :destroy]

  def index
    @noodles = Noodle.order(id: :desc).page(params[:page]).per(10)
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
  end

  def edit
  end

  def update
    if @noodle.update_attributes(noodle_params)
      flash[:success] = "家ラーメンが更新されました"
      redirect_to @noodle
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if current_user.admin? || current_user?(@noodle.user)
      @noodle.destroy
      flash[:success] = "家ラーメンが削除されました"
      # redirect_back(fallback_location: root_path)
      redirect_to root_path
    else
      flash.now[:danger] = "他人の家ラーメンは削除できません"
      redirect_to root_path
    end
  end

  private

  def set_noodle
    @noodle = Noodle.find(params[:id])
  end

  def noodle_params
    params.require(:noodle).permit(:name, :maker, :place, :eat, :image)
  end

  def correct_user
    @noodle = current_user.noodles.find_by(id: params[:id])
    redirect_to root_url if @noodle.nil?
  end
end
