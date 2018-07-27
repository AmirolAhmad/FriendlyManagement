class FriendshipsController < ApplicationController
  def create
    @friends = params[:friends]
    key = User.find_by_email @friends[0]
    val = User.find_by_email @friends[1]

    if Friendship.where(user: key, friend: val).exists?
      render json: {message: "Relationship already establish"}
    else
      if User.where(email: @friends[0]).exists? && !User.where(email: @friends[1]).exists?
        @user = key
        @friend = User.create email: @friends[1]
        @user.friendships.create friend_id: @friend.id
        render json: {success: true}

      elsif !User.where(email: @friends[0]).exists? && User.where(email: @friends[1]).exists?
        @user = User.create email: @friends[0]
        @friend = User.find_by_email(@friends[1])
        @user.friendships.create friend_id: @friend.id
        render json: {success: true}
        
      else
        @user = User.create email: @friends[0]
        @friend = User.create email: @friends[1]
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
