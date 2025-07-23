class CartsController < ApplicationController

  # GET /cart
  def show
    @cart = current_cart
    render json: @cart, serializer: CartSerializer
  end

  # POST /cart
  def create
    cart = current_cart
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    item = cart.cart_items.find_or_initialize_by(product_id: product.id)
    item.quantity += quantity
    item.save!

    cart.update!(total_price: calculate_total_price(cart))

    render json: @cart, serializer: CartSerializer
  end

  # PATCH /cart/add_item
  def add_item
    cart = current_cart
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    item = cart.cart_items.find_or_initialize_by(product_id: product.id)
    item.quantity += quantity
    item.save!

    cart.update!(total_price: calculate_total_price(cart))

    render json: @cart, serializer: CartSerializer
  end

  # DELETE /cart/:product_id
  def remove_item
    cart = current_cart
    product = Product.find(params[:product_id])
    item = cart.cart_items.find_by(product_id: product.id)
    item.destroy if item

    cart.update!(total_price: calculate_total_price(cart))

    render json: @cart, serializer: CartSerializer
  end


  private

  def current_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id])
    elsif (item = CartItem.find_by(product_id: params[:product_id]))
      item.cart
    else
      cart = Cart.create!(total_price: 0)
      session[:cart_id] = cart.id
      cart
    end
  end

  def calculate_total_price(cart)
    cart.cart_items.includes(:product).sum { |item| item.quantity * item.product.price }
  end
end
