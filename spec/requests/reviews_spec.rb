#rubocop:disable all
require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  restaurant = FactoryBot.build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
  restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                    filename: 'food2.jpg', content_type: 'image/jpg')
  restaurant.save

  describe 'GET #new' do
    before do
      session[:user_id] = user.id
    end

    it 'returns a successful response' do
      get :new, params: { restaurant_id: restaurant.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before do
      session[:user_id] = user.id
    end

    it 'creates a new review' do
      expect {
        post :create, params: { restaurant_id: restaurant.id, review: FactoryBot.attributes_for(:review) }
      }.to change(Review, :count).by(1)
    end

    it 'redirects to the restaurant page' do
      post :create, params: { restaurant_id: restaurant.id, review: FactoryBot.attributes_for(:review) }
      expect(response).to redirect_to(restaurant_path(restaurant))
    end

    it 'displays a flash message on success' do
      post :create, params: { restaurant_id: restaurant.id, review: FactoryBot.attributes_for(:review) }
      expect(flash[:success]).to be_present
    end

    it 'renders the new template on failure' do
      post :create, params: { restaurant_id: restaurant.id, review: FactoryBot.attributes_for(:review, comment: '') }
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let(:review) { create(:review, user: user, restaurant: restaurant) }
    before do
      session[:user_id] = user.id
    end
    it 'returns a successful response' do
      get :edit, params: { restaurant_id: restaurant.id, id: review.id }
      expect(response).to have_http_status(200)
    end

    it 'renders the edit template' do
      get :edit, params: { restaurant_id: restaurant.id, id: review.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'patch #update' do
    let(:review) { FactoryBot.create(:review, restaurant: restaurant) }

    before do
      session[:user_id] = user.id
    end

    it 'updates the review' do
      new_comment = 'Updated comment'
      patch :update, params: {restaurant_id: restaurant.id, id: review.id, review: { comment: new_comment } }
      expect(review.reload.comment).to eq(new_comment)
    end

    it 'redirects to the restaurant page' do
      patch :update, params: {restaurant_id: restaurant.id, id: review.id, review: FactoryBot.attributes_for(:review) }
      expect(response).to redirect_to(restaurant_path(restaurant))
    end

    it 'displays a flash message on success' do
      patch :update, params: { restaurant_id: restaurant.id, id: review.id, review: FactoryBot.attributes_for(:review) }
      expect(flash[:warning]).to be_present
    end

    it 'renders the edit template on failure' do
      put :update, params: {restaurant_id: restaurant.id, id: review.id, review: FactoryBot.attributes_for(:review, comment: '') }
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE #destroy' do
    let(:review) { FactoryBot.create(:review, restaurant: restaurant) }

    before do
      session[:user_id] = user.id
    end

    it 'redirects to the restaurant page' do
      delete :destroy, params: {restaurant_id: restaurant.id, id: review.id }
      expect(response).to redirect_to(restaurant_path(restaurant))
    end
  end

  describe 'POST #approve' do
    let(:review) { FactoryBot.create(:review, restaurant: restaurant) }

    before do
      session[:user_id] = user.id
    end

    it 'approves the review' do
      post :approve, params: {restaurant_id: restaurant.id, id: review.id }, format: :js
      expect(review.reload.approval).to eq(true)
    end
  end
end
#rubocop:enable all