# frozen_string_literal: true

# Notification Model
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :book_table, optional: true
  scope :unread_notifications, ->(current_user) { current_user.notifications.where(read: false).count }
end
