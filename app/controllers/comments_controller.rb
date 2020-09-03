class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @noodle = Noodle.find(params[:noodle_id])
    @comment = @noodle.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if @comment.save
      flash[:success] = "コメントを追加しました"
    else
      flash[:danger] = "コメント追加に失敗しました"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
    
  end
end
