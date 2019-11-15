class CommentsController < ApplicationController
  before_action :set_item

  def create
    @comment = @item.comments.build(comment_params)
    @comment.user = current_user
    flash[:success] = if @comment.save
                        @item.notification_comment!(current_user, @comment.id)
                         'コメントしました'
                      else
                        'コメントできませんでした'
                      end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @comment = @item.comments.find_by(params[:id])
    if @comment.destroy
       flash[:success] = 'コメント削除しました'
       redirect_back(fallback_location: root_path)
    end
  end

  private

    def set_item
      @item = Item.find(params[:item_id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
