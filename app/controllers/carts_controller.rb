# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :set_cart, only: [:create, :add_item, :remove_item, :show]

  # POST /cart
  def create
    product, quantity = product_params.values_at(:product_id, :quantity)
    item = @cart.cart_items.find_or_initialize_by(product_id: product)
    item.quantity += quantity.to_i
    item.save!

    update_cart_total(@cart)
    render_cart
  end

  # PATCH /cart/add_item
  def add_item
    product, quantity = product_params.values_at(:product_id, :quantity)
    item = @cart.cart_items.find_or_initialize_by(product_id: product)
    item.quantity += quantity.to_i
    item.save!

    update_cart_total(@cart)
    render_cart
  end

  # GET /cart
  def show
    render_cart
  end

  # DELETE /cart/:product_id
  def remove_item
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    item&.destroy

    update_cart_total(@cart)
    render_cart
  end

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])

    if @cart.nil? && params[:product_id]
      # fallback to the cart linked to the product if session[:cart_id] is missing
      @cart = CartItem.find_by(product_id: params[:product_id])&.cart
    end

    unless @cart
      @cart = Cart.create!(total_price: 0)
      session[:cart_id] = @cart.id
    end
  end

  def product_params
    params.permit(:product_id, :quantity)
  end

  def update_cart_total(cart)
    total = cart.cart_items.includes(:product).sum { |item| item.quantity * item.product.price }
    cart.update!(total_price: total)
  end

  def render_cart
    render json: @cart, serializer: CartSerializer
  end
end
