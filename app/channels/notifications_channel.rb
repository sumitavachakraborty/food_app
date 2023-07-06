class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    user = User.find(3)
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
