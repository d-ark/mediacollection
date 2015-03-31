require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'populates an array of items' do
      items = [create(:image), create(:video)]
      get :index
      expect(assigns :items).to eq(items)
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
