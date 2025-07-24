class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :quantity, :unit_price, :total_price

  def id
    object.product_id
  end

  def product_name
    object.product.name
  end
end