class FriendshipsController < ApplicationController
  before_action :set_friend, only: [:create]

  # 1. As a user, I need an API to create a friend connection between two email addresses.
  # POST http://localhost:3000/friendships
  def create
    if Friendship.where(user: @key, friend: @val).exists?
      render json: {message: "Relationship already establish"}
    else
      if User.where(email: @friends[0]).exists? && !User.where(email: @friends[1]).exists?
        @user = @key
        @friend = User.create email: @friends[1]
        @user.friendships.create friend_id: @friend.id
        render json: {success: true}

      elsif !User.where(email: @friends[0]).exists? && User.where(email: @friends[1]).exists?
        @user = User.create email: @friends[0]
        @friend = @val
        @user.friendships.create friend_id: @friend.id
        render json: {success: true}

      elsif User.where(email: @friends[0]).exists? && User.where(email: @friends[1]).exists?
        if Friendship.where(user: @key, friend: @val).exists?
          render json: {message: "Relationship already establish"}
        else
          @user = @key
          @friend = @val
          @user.friendships.create friend_id: @friend.id
          render json: {success: true}
        end

      else
        @user = User.create email: @friends[0]
        @friend = User.create email: @friends[1]
        @user.friendships.create friend_id: @friend.id

        render json: {success: true}
      end
    end
  end

  # 2. As a user, I need an API to retrieve the friends list for an email address.
  # GET http://localhost:3000/friendlist?email=andy@example.com
  def list
    @user = User.find_by_email params[:email]
    @friendship = Friendship.where user: @user
    render json: {success: true, friends: @friendship.map {|f| f.friend.email}, count: @friendship.count}
  end

  # 3. As a user, I need an API to retrieve the common friends list between two email addresses.
  # GET http://localhost:3000/common?friends=["andy@example.com","andy1@example.com"]
  def common
    @params = params[:friends]
    a = JSON.parse(@params)
    @key = User.find_by_email a[0]
    @val = User.find_by_email a[1]

    @friendship_key = Friendship.where user: @key
    @friendship_val = Friendship.where user: @val

    @lists_id = []
    @friendship_key.each do |f|
      @friendship_val.each do |g|
        if f.friend_id == g.friend_id
          @lists_id << g.friend_id
        end
      end
    end

    @user = User.find @lists_id

    render json: {success: true, friends: @user.map {|f| f.email}, count: @lists_id.count}
  end

  private

    def set_friend
      @friends = params[:friends]
      @key = User.find_by_email @friends[0]
      @val = User.find_by_email @friends[1]
    end
end
