require 'rails_helper'

RSpec.describe "/cart", type: :request do  
  let(:product) { Product.create(name: "Test Product", price: 10.0) }
  describe "GET /cart" do
    let(:cart) { Cart.create }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 2) }

    it "returns the current cart" do
      get "/cart", as: :json
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe "POST /add_item" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }  
    
    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
  
  describe "DELETE /cart/:product_id" do
    let(:cart) { Cart.create }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    subject do
      delete "/cart/#{product.id}", as: :json
    end

    it "removes the item from the cart" do
      expect { subject }.to change { cart.cart_items.count }.by(-1)
    end
  end
end
