class SubscribesController < ApplicationController
  before_action :set_attr, only: [:create, :block]

  # 4. As a user, I need an API to subscribe to updates from an email address.
  # GET http://localhost:3000/subscribe
  def create
    requestor = User.where(email: @requestor)
    target = User.where(email: @target)

    if requestor.exists? && !target.exists?
      render json: { success: false, message: "Target Email not found" }

    elsif !requestor.exists? && target.exists?
      render json: { success: false, message: "Requestor Email not found" }

    elsif !requestor.exists? && !target.exists?
      render json: { success: false, message: "Both Email not found" }

    else
      if @requestor != @target || @target != @requestor
        user = User.find_by_email @requestor
        aim = User.find_by_email @target
        user.subscribes.create target_id: aim.id
        render json: { success: true }
      else
        render json: { success: false, message: "You can't subscribe yourself" }
      end

    end
  end

  # 5. As a user, I need an API to block updates from an email address.
  # PUT http://localhost:3000/block
  def block
    requestor = User.find_by_email @requestor
    target = User.find_by_email @target

    if requestor && target

      list = Subscribe.where(user: requestor, target: target).first
      if list.nil?
        list = requestor.subscribes.create target_id: target.id
      end
      list.update_attribute(:block, true)
      render json: { success: true }
    else
      render json: { success: false, message: "email not found" }
    end
  end

  # 6. As a user, I need an API to retrieve all email addresses that can receive updates from an email address.
  # POST http://localhost:3000/receive_update
  def receive_update
    @text = params[:text]
    user = User.find_by_email params[:sender]
    if user

      friendship = Friendship.where user_id: user

      # get the recipient
      recipients = []
      friendship.each do |f|
        recipients << f.friend.email
      end
      mention = @text.scan(/\w+@\w+.\w+/i)
      recipients << mention.join(', ')

      # get the block user
      excludes = []
      subscribes = Subscribe.where user: user, block: true
      subscribes.each do |f|
        excludes << f.target.email
      end

      recipients = recipients.reject { |i| excludes.include?(i) }

      render json: { success: true, recipients: recipients }
    else
      render json: { success: false, message: "Sender email not found" }
    end
  end

  private

    def set_attr
      @requestor = params[:requestor]
      @target = params[:target]
    end
end
