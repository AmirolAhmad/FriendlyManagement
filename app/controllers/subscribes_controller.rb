class SubscribesController < ApplicationController
  before_action :set_attr, only: [:create, :block]

  # 4. As a user, I need an API to subscribe to updates from an email address.
  # GET http://localhost:3000/subscribe
  def create
    if User.where(email: @requestor).exists? && !User.where(email: @target).exists?
      render json: { success: false, message: "Target Email not found" }

    elsif !User.where(email: @requestor).exists? && User.where(email: @target).exists?
      render json: { success: false, message: "Requestor Email not found" }

    elsif !User.where(email: @requestor).exists? && !User.where(email: @target).exists?
      render json: { success: false, message: "Both Email not found" }

    else
      if @requestor != @target || @target != @requestor
        @user = User.find_by_email @requestor
        @aim = User.find_by_email @target
        @user.subscribes.create target_id: @aim.id
        render json: { success: true }
      else
        render json: { success: false, message: "You can't subscribe yourself" }
      end

    end
  end

  # 5. As a user, I need an API to block updates from an email address.
  # PUT http://localhost:3000/block
  def block
    @key = User.find_by_email @requestor
    @val = User.find_by_email @target

    @list = Subscribe.where(user: @key, target: @val).first
    @list.update_attribute(:block, true)
    render json: { success: true }
  end

  # 6. As a user, I need an API to retrieve all email addresses that can receive updates from an email address.
  # POST http://localhost:3000/receive_update
  def receive_update
    @text = params[:text]
    @user = User.find_by_email params[:sender]
    @friendship = Subscribe.where target: @user, block: false

    @recipients = []
    @friendship.each do |f|
      @recipients << f.user.email
    end
    @mention = @text.scan(/\w+@\w+.\w+/i)
    @recipients << @mention.join(', ')
    
    render json: { success: true, recipients: @recipients }
  end

  private

    def set_attr
      @requestor = params[:requestor]
      @target = params[:target]
    end
end
