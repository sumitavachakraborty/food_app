class OrderMailer < ApplicationMailer
    def order_confirmation(user,order)
        @user = user
        @total = order.total
        @address = order.delivery_address
        @review_link = new_resturant_review_url(order.resturant_id)
        # binding.pry
        mail(to: @user.email , subject: "Order placed succesfully")
    end
end
