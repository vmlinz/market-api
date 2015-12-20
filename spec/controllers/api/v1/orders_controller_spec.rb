require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:current_user) { FactoryGirl.create :user }
  before { api_authorization_header current_user.auth_token }
  describe "GET #index" do
    before do
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, user_id: current_user.id
    end

    it "returns 4 orders from the user" do
      expect(json_response[:orders].size).to eql 4
    end

    it { is_expected.to respond_with 200 }
  end

  describe "GET #show" do
    let(:order) { FactoryGirl.create :order, user: current_user } 
    before do
      get :show, user_id: current_user.id, id: order.id
    end

    it "returns the order record" do
      expect(json_response[:order][:id]).to eql order.id  
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    let(:product1) { FactoryGirl.create :product } 
    let(:product2) { FactoryGirl.create :product } 
    before do
      order_params =  { product_ids: [product1.id, product2.id]}
      post :create, user_id: current_user.id, order: order_params
    end

    it "returns the order record" do
      expect(json_response[:order][:id]).to be_present
    end

    it { should respond_with 201 }
  end
end
