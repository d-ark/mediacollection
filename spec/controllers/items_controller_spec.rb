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

  describe "GET #show" do
    let(:item) {create(:image, public: true)}

    it "returns http success" do
      get :show, id: item.id
      expect(response).to have_http_status(:success)
    end

    it "returns 404 page if not exist" do
      get :show, id: "la_la_la"
      expect(response).to have_http_status(:not_found)
    end

    it "returns 403 page if not public" do
      item.update public: false
      get :show, id: item.id
      expect(response).to have_http_status(:forbidden)
    end

    it 'populates an array of items' do
      get :show, id: item.id
      expect(assigns :item).to eq(item)
    end

    it 'renders index template' do
      get :show, id: item.id
      expect(response).to render_template :show
    end
  end


  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
