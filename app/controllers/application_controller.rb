class ApplicationController < ActionController::Base
  before_action :set_search
  include SessionsHelper

  def set_search
    @search_word = params[:q][:name_cont] if params[:q]
    @search = Noodle.ransack(params[:q])
    @noodles = @search.result(distinct: true).page(params[:page]).per(10)
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_path
    end
  end
end
