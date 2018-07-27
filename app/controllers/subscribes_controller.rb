class SubscribesController < ApplicationController

  # 4. As a user, I need an API to subscribe to updates from an email address.
  # http://localhost:3000/subscribe
  def create
    requestor = params[:requestor]
    target = params[:target]

    if User.where(email: requestor).exists? && !User.where(email: target).exists?
      render json: { success: false, message: "Target Email not found" }

    elsif !User.where(email: requestor).exists? && User.where(email: target).exists?
      render json: { success: false, message: "Requestor Email not found" }

    elsif !User.where(email: requestor).exists? && !User.where(email: target).exists?
      render json: { success: false, message: "Both Email not found" }

    else
      if requestor != target || target != requestor
        @requestor = User.find_by_email requestor
        @target = User.find_by_email target
        @requestor.subscribes.create target_id: @target.id
        render json: { success: true }
      else
        render json: { success: false, message: "You can't subscribe yourself" }
      end

    end
  end
end
