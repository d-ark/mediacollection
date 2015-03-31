require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  context 'when not signed in' do
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

    describe "GET #new" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    describe "GET #edit" do
      it "redirects to sign in page" do
        get :edit, id: "any_id"
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    describe "POST #create" do
      it "redirects to sign in page" do
        post :create
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  context 'when signed in' do
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

      it "returns 403 page if not public" do
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

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it 'populates a new item' do
        get :new
        expect(assigns :item).to be_new_record
      end
      it 'renders new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "GET #edit" do
      let(:item) {create(:image, public: false, user: find_or_create(:alice))}

      it "returns http success" do
        get :edit, id: item.id
        expect(response).to have_http_status(:success)
      end

      it "returns 404 page if not exist" do
        get :edit, id: "la_la_la"
        expect(response).to have_http_status(:not_found)
      end

      it "returns 403 page if not public" do
        item.update public: false, user: find_or_create(:bob)
        get :edit, id: item.id
        expect(response).to have_http_status(:forbidden)
      end

      it "returns 403 page if not owned by current user" do
        item.update public: true, user: find_or_create(:bob)
        get :edit, id: item.id
        expect(response).to have_http_status(:forbidden)
      end

      it 'populates an item' do
        get :edit, id: item.id
        expect(assigns :item).to eq(item)
      end

      it 'renders edit template' do
        get :edit, id: item.id
        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do

      it "renders :new when data is not valid" do
        post :create, item: {title: ''}
        expect(response).to render_template :new
      end

      it "saves record when data is valid" do
        post :create, item: attributes_for(:image)
        item = assigns :item
        expect(item).not_to be_new_record
      end

      it "redirects to show page when data is valid" do
        post :create, item: attributes_for(:image)
        item = assigns :item
        expect(response).to redirect_to "/items/#{item.id}"
      end

      it "saves record with current_user id" do
        post :create, item: attributes_for(:image, user: find_or_create(:bob))
        item = assigns :item
        expect(item.user_id).to eq(find_or_create(:alice).id)
      end

    end
  end
end
