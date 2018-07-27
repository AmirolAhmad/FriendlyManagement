class FriendshipsController < ApplicationController
  def create
    # do code if email already exists in db
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

  def list
    @user = User.find_by_email params[:email]
    @friendship = Friendship.where user: @user
    render json: {success: true, friends: @friendship.map {|f| f.friend.email}, count: @friendship.count}
  end
end
