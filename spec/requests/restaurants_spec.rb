#rubocop:disable allrestaurant
# spec/controllers/restaurants_controller_spec.rb

require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  let(:user) { FactoryBot.create(:user, admin: true) }
  
  describe 'GET #show' do
    before do
      session[:user_id] = user.id
    end
    it 'renders the show template' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      get :show, params: { id: restaurant.id }
      check = controller.instance_variable_get(:@all_review)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #index' do
    before do
      session[:user_id] = user.id
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before do
      session[:user_id] = user.id
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before do
      session[:user_id] = user.id
    end
    it 'renders the edit template' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      get :edit, params: { id: restaurant.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    before do
      session[:user_id] = user.id
    end
  
    it 'redirects to restaurants_path on success' do
      post :create, params: { restaurant: FactoryBot.attributes_for(:restaurant)}
      expect(response).to be_successful
    end
  
    it 'renders new template on failure' do
      post :create, params: { restaurant: FactoryBot.attributes_for(:restaurant, name: '') }
      expect(response).to render_template('new')
    end
  end

  describe 'PATCH #update' do
    before do
      session[:user_id] = user.id
    end
    it 'updates the restaurant' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      patch :update, params: { id: restaurant.id, restaurant: { name: 'New Name' } }
      restaurant.reload
      expect(restaurant.name).to eq('New Name')
    end

    it 'redirects to restaurant_path on success' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      patch :update, params: { id: restaurant.id, restaurant: { name: 'New Name' } }
      expect(response).to redirect_to(restaurant_path)
    end

    it 'renders edit template on failure' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      patch :update, params: { id: restaurant.id, restaurant: { name: '' } }
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id] = user.id
    end
    it 'deletes the restaurant' do
      restaurant1 = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant1.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant1.save
      expect do
        delete :destroy, params: { id: restaurant1.id }
      end.to change(Restaurant, :count).by(-1)
    end

    it 'redirects to restaurants_path on success' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      delete :destroy, params: { id: restaurant.id }
      expect(response).to redirect_to(restaurants_path)
    end
  end
  
  describe 'POST #markread' do
    before do
      session[:user_id] = user.id
    end
    it 'deletes notifications for the user' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      user.notifications.create(message: 'Test notification', read: true,restaurant_id: restaurant.id)
      
      post :markread, params: { id: user.id }, format: :js
      expect(user.notifications.count).to eq(0)
    end
  end

  describe 'POST #count' do
    before do
      session[:user_id] = user.id
    end
    it 'marks notifications as read for the user' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      user.notifications.create(message: 'Test notification', read: false,restaurant_id: restaurant.id)
      
      post :count, params: { id: user.id }, format: :js
      expect(user.notifications.first.read).to eq(true)
    end
  end

  describe 'GET #gallery' do
    before do
      session[:user_id] = user.id
    end
    let(:restaurant) { FactoryBot.create(:restaurant) }
    it 'renders the gallery template' do
      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save
      get :gallery, params: { restaurant_id: restaurant.id }
      expect(response).to render_template('gallery')
    end
  end

  describe 'POST #attach_image' do
    before do
      session[:user_id] = user.id
    end

    it 'attaches an image to the restaurant' do
      image = fixture_file_upload('spec/fixtures/food2.jpg', 'image/jpeg') 

      restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
      restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                     filename: 'food2.jpg', content_type: 'image/jpg')
      restaurant.save

      post :attach_image, params: { restaurant_id: restaurant.id, cover_image: image }
      expect(response).to redirect_to(restaurant_gallery_path(restaurant))
    end
  end

  describe 'GET #search' do
    before do
      session[:user_id] = user.id
    end
    Restaurant.delete_all
    restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
    restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
    restaurant.save

    it 'returns results when searching by name' do
      get :search, params: { search: restaurant.name }
      expect(assigns(:restaurant)).to include(restaurant)
    end

    it 'returns results when filtering by category' do
      category = FactoryBot.create(:category)
      restaurant.update(category_id: category.id)

      get :search, params: { category_id: category.id }
      expect(assigns(:restaurant)).to include(restaurant)
    end
  end
end

