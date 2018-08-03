class FriendshipsController < ApplicationController

  # 1. As a user, I need an API to create a friend connection between two email addresses.
  # POST http://localhost:3000/friendships
  def create
    @user = User.find_or_create_by(email: params[:friends][0])
    @friend = User.find_or_create_by(email: params[:friends][1])

    if Friendship.where(user: @user, friend: @friend).exists?
      render json: {message: "Relationship already establish"}
    else
      if @friend == @user
        render json: {success: false, message: "you can\'t create relationship with yourself"}
      else
        @user.friendships.create(friend_id: @friend.id)
        render json: {success: true}
      end
    end
  end

  # 2. As a user, I need an API to retrieve the friends list for an email address.
  # GET http://localhost:3000/friendlist?email=andy@example.com
  def list
    user = User.find_by_email params[:email]
    if user
      friendship = Friendship.where user: user
      render json: {success: true, friends: friendship.map {|f| f.friend.email}, count: friendship.count}
    else
      render json: {message: "email not found"}
    end
  end

  # 3. As a user, I need an API to retrieve the common friends list between two email addresses.
  # GET http://localhost:3000/common?friends=["andy@example.com","andy1@example.com"]
  def common
    @params = params[:friends]
    a = JSON.parse(@params)
    key = User.find_by_email a[0]
    val = User.find_by_email a[1]

    if key && val

      friendship_key = Friendship.where user: key
      friendship_val = Friendship.where user: val

      lists_id = []
      friendship_key.each do |f|
        friendship_val.each do |g|
          if f.friend_id == g.friend_id
            lists_id << g.friend_id
          end
        end
      end

      user = User.find lists_id

      render json: {success: true, friends: user.map {|f| f.email}, count: lists_id.count}
    else
      render json: {message: "user email not found"}
    end
  end
end
