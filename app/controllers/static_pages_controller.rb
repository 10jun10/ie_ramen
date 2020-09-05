class StaticPagesController < ApplicationController
  def top
    @noodles = Noodle.order(id: :desc).page(params[:page]).per(10)
  end

  def about
  end
end
