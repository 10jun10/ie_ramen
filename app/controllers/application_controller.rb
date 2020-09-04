class ApplicationController < ActionController::Base
  before_action :set_search
  include SessionsHelper

  def set_search
    @search = Noodle.ransack(params[:q])
    @noodles = @search.result(distinct: true)
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
