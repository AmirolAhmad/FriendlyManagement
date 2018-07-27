class FriendshipsController < ApplicationController
  def create
    @friends = params[:friends]

    @friends.each do |key,value|
      if @friends[0] == key
        @user = User.create email: key
        @friend = User.create email: value
        @user.friendships.create friend_id: @friend.id

        render json: {success: true}
      end
    end
  end
end
