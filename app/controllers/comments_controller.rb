class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:item_id])
    @comment = item.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "コメントしました"
      redirect_back(fallback_location: root_path)
    else
      flash[:success] = "コメントできませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = Comment.find_by(params[:id])
    if @comment.destroy
       flash[:success] = "コメント削除しました"
       redirect_back(fallback_location: root_path)
    end
  end

  private

    def comment_params
        params.require(:comment).permit(:content)
    end

end
