#rubocop:disable all
# categories_controller_spec.rb

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, admin: true) } 
  let(:category) { FactoryBot.create(:category) }

  describe 'GET #index' do
    before do
      session[:user_id] = admin_user.id
    end
    it 'returns a successful response' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    before do
      session[:user_id] = admin_user.id
    end
    it 'returns a successful response' do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before do
      session[:user_id] = admin_user.id
    end
    it 'creates a new category and redirects to categories_path on success' do
      category_params = { category_name: 'New Category' }

      post :create, params: { category: category_params }

      expect(flash[:success]).to eq('Category created successfully')
      expect(response).to redirect_to(categories_path)
      expect(Category.last.category_name).to eq('New Category')
    end

    it 'renders the new template on failure' do
      post :create, params: { category: { category_name: '' } }

      expect(response).to render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id] = admin_user.id
    end
    it 'destroys the category and redirects to categories_path' do
      delete :destroy, params: { id: category.id }

      expect(flash[:danger]).to eq('Category deleted successfully')
      expect(response).to redirect_to(categories_path)
      expect(Category.exists?(category.id)).to be_falsey
    end
  end
end

#rubocop:enable all