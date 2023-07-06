class NotificationController < ApplicationController
    def count
        count = current_user.Notification.count
        render json: { count: }
    end

end
