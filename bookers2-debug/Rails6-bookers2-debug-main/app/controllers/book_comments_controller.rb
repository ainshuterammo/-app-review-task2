class BookCommentsController < ApplicationController

  def create
  # book = Book.find(params[:book_id])
  # comment = current_user.book_comments.new(book_comment_params)
  # comment.book_id = book.id
  # comment.save
  # @books=Book.find(params[:book_id])
  # @book_comment = BookComment.new
    # redirect_to request.referer
    @book = Book.find(params[:book_id])
  @book_comment = current_user.comments.new(book_comment_params)
  @book_comment.book_id = @book.id
  if @book_comment.save
    flash.now[:notice] = 'コメントを投稿しました'
    render :book_comments
  else
    render :error  #render先にjsファイルを指定
  end
  end

  def destroy
    # @books=Book.find(params[:book_id])
    # @book_comment=BookComment.find_by(id: params[:id], book_id: params[:book_id])
    # @book_comment.destroy
    # @book_comment = BookComment.new
    # redirect_to request.referer
    # Comment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    # redirect_to book_path(params[:book_id]), alert: 'コメントを削除しました'
    Book_Commen.find_by(id: params[:id], book_id: params[:book_id]).destroy
    flash.now[:alert] = '投稿を削除しました'
    #renderしたときに@postのデータがないので@postを定義
    @book = Book.find(params[:book_id])
    render :book_comments  #render先にjsファイルを指定
    else
    render :error  #render先にjsファイルを指定
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
