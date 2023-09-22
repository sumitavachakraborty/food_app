#rubocop:disable all
# frozen_string_literal: true

# order Mailer
class OrderMailer < ApplicationMailer
  require 'prawn/table'
  def order_confirmation(user, order)
    @order = order
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
    pdf.move_down 10
    table_data = [["Item Name", "Quantity", "Price"]]
    order.foodname_array.each_with_index do |food_name, index|
      table_data << [food_name, order.foodquantity_array[index], "Rs.#{order.food_price_array[index]}"]
    end
    pdf.table(table_data, header: true, width: pdf.bounds.width) do
      row(0).font_style = :bold
      columns(0..2).align = :center
      self.header = true
    end
    pdf.move_down 15
    pdf.text "Delivery Address:", size: 12, style: :bold
    pdf.text order.delivery_address, size: 12
    pdf.move_down 15
    pdf.text "Total Price: Rs.#{order.total}", size: 18, style: :bold, align: :center
    pdf.render
  end
  
end

#rubocop:enable all