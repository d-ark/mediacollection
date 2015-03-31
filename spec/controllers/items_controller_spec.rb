require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  context 'user not signed in' do
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'populates an array of items' do
        public_items = [
          create(:image, public: true, user: find_or_create(:bob)),
          create(:image, public: true, user: find_or_create(:alice))
        ]

        get :index
        expect(assigns :my_items).to eq([])
        expect(assigns :public_items).to eq(public_items)
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

      it "redirects to sign in page if not public" do
        item.update public: false
        get :show, id: item.id
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'populates an item' do
        get :show, id: item.id
        expect(assigns :item).to eq(item)
      end

      it 'renders show template' do
        get :show, id: item.id
        expect(response).to render_template :show
      end
    end
  end

  context 'user signed in' do
    before { sign_in find_or_create :alice }

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'populates an array of items' do
        public_items = [create(:image, public: true, user: find_or_create(:bob))]
        my_items = [
          create(:image, public: true, user: find_or_create(:alice)),
          create(:image, public: false, user: find_or_create(:alice))
        ]
        create(:image, public: false, user: find_or_create(:bob))

        get :index
        expect(assigns :my_items).to eq(my_items)
        expect(assigns :public_items).to eq(public_items)
      end

      it 'renders index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "GET #show" do
      let(:item) {create(:image, public: false, user: find_or_create(:alice))}

      it "returns http success" do
        get :show, id: item.id
        expect(response).to have_http_status(:success)
      end

      it "returns 404 page if not exist" do
        get :show, id: "la_la_la"
        expect(response).to have_http_status(:not_found)
      end

      it "returns 403 page if not public for signed in users" do
        item.update public: false, user: find_or_create(:bob)
        get :show, id: item.id
        expect(response).to have_http_status(:forbidden)
      end

      it 'populates an item' do
        get :show, id: item.id
        expect(assigns :item).to eq(item)
      end

      it 'renders show template' do
        get :show, id: item.id
        expect(response).to render_template :show
      end
    end
  end
end
