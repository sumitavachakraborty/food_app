class OrderMailer < ApplicationMailer
    def order_confirmation(user,order)
        @user = user
        @total = order.total
        order_attachment = pdf_generation(order)
        attachments["Order_details.pdf"] = order_attachment
        @address = order.delivery_address
        @review_link = new_resturant_review_url(order.resturant_id)
        # binding.pry
        mail(to: @user.email , subject: "Order placed succesfully")
    end

    def pdf_generation(order)
        pdf = Prawn::Document.new

        pdf.text "ZOMZOM", size: 24, style: :bold, :color => "FF0000",align: :center 
        pdf.move_down 10
        pdf.text "Order Details", size: 18, style: :bold,align: :center
        pdf.text "Food items name: #{order.foodname_array.join(", ")}",align: :center
        pdf.text "Food items prices : #{order.food_price_array.join(", ")}",align: :center
        pdf.move_down 10
        pdf.text "Total Price : Rs.#{order.total}",align: :center,size: 16, style: :bold
        pdf.render

    end
end
