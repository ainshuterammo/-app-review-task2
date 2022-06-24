class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    follower = current_user.relationships.build(followed_id: params[:user_id])
    follower.save
    redirect_to request.referrer || root_path
  end

  def destroy
    follower = current_user.relationships.find_by(followed_id: params[:user_id])
    follower.destroy
    redirect_to request.referrer || root_path
  end

  # def followers
  #   user = User.find(params[:id])
  #   @users = user.followers
  # end

  # def followeds
  #   user = User.find(params[:id])
  #   @users = user.followeds
  # end

  # end
  # フォローするとき
#   def create
#     current_user.follow(params[:user_id])
#     redirect_to request.referer
#   end
#   # フォロー外すとき
#   def destroy
#     current_user.unfollow(params[:user_id])
#     redirect_to request.referer
#   end
#   # フォロー一覧
#   def followings
#     user = User.find(params[:user_id])
#     @users = user.followings
#   end
#   # フォロワー一覧
#   def followers
#     user = User.find(params[:user_id])
#     @users = user.followers
#   end

end
