class CartSerializer < ActiveModel::Serializer
  attributes :id, :products, :total_price

  def products
    object.cart_items.includes(:product).map do |cart_item|
      CartItemSerializer.new(cart_item).as_json
    end
  end

  def total_price
    object.cart_items.sum { |cart_item| cart_item.quantity * cart_item.product.price }
  end
end
