class NoodlesController < ApplicationController
  before_action :logged_in_user, only: [:new]

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
      redirect_to root_path
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new
    end
  end

  def show
  end

  private

  def noodle_params
    params.require(:noodle).permit(:name, :maker, :place, :eat, :image)
  end
end
