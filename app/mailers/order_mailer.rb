#rubocop:disable all
# frozen_string_literal: true

# order Mailer
class OrderMailer < ApplicationMailer
  def order_confirmation(user, order)
    @name = order.foodname_array.join(', ')
    @quantity = order.foodquantity_array.join(', ')
    @price = order.food_price_array.join(', ')
    @user = user
    @total = order.total
    order_attachment = pdf_generation(order)
    attachments['Order_details.pdf'] = order_attachment
    @address = order.delivery_address
    @review_link = new_resturant_review_url(order.resturant_id)
    mail(to: @user.email, subject: 'Order placed succesfully')
  end

  def pdf_generation(order)
    pdf = Prawn::Document.new

    pdf.text 'ZOMZOM', size: 28, style: :bold, color: 'FF0000', align: :center
    pdf.move_down 15
    pdf.text 'Order Details', size: 24, style: :bold, align: :center
    pdf.text "Ordered items name: #{order.foodname_array.join(', ')}", align: :center
    pdf.text "Ordered items quantity: #{order.foodquantity_array.join(', ')}", align: :center
    pdf.text "Ordered items prices : #{order.food_price_array.join(', ')}", align: :center
    pdf.move_down 15
    pdf.text "Delivery address : #{order.delivery_address}", align: :center, size: 10, style: :bold
    pdf.text "Total Price : Rs.#{order.total}", align: :center, size: 24, style: :bold
    pdf.render
  end
end

#rubocop:enable all