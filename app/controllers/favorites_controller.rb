class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites.order(id: :desc).page(params[:page]).per(10)
  end

  def create
    @noodle = Noodle.find(params[:noodle_id])
    current_user.favorite(@noodle)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_path }
      format.js
    end
  end

  def destroy
    @noodle = Noodle.find(params[:noodle_id])
    current_user.favorites.find_by(noodle_id: @noodle.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_path }
      format.js
    end
  end
end
