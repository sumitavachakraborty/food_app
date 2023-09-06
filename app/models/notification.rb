# frozen_string_literal: true

# Notification Model
class Notification < ApplicationRecord
  belongs_to :user
  scope :find_notification_count, ->(current_user) { current_user.notifications.where(read: false).count }
end
