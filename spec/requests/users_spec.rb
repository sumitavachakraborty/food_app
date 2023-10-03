#rubocop:disable all
# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, admin: true) } 
  
  describe 'GET #index' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(restaurants_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'renders the show template' do
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end


  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'creates a new user' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'renders the edit template' do
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'updates the user information' do
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        expect(response).to redirect_to(user)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id] = user.id
    end
    it 'destroys the requested user' do
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the root path' do
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(root_path)
    end
  end


  let(:valid_attributes) do
    {
      username: 'testuser',
      email: 'test1@example.com',
      password: 'password',
      city: 'Test City',
      address: 'Test Address'
    }
  end

  let(:user2) { User.create!(valid_attributes) }

  describe 'POST #makeadmin' do
    it 'toggles the admin attribute' do
      expect do
        post :makeadmin, params: { id: user2.id, format: :js }
        user2.reload
      end.to change(user2, :admin).from(false).to(true)
    end

    it 'responds with JavaScript' do
      post :makeadmin, params: { id: user2.id, format: :js }
      expect(response).to render_template(:makeadmin)
    end
  end

  describe 'GET #change_address' do
    it 'returns a success response' do
      get :change_address, params: { id: user2.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #location' do
    it 'returns a success response' do
      get :location, params: { id: user2.id ,address_line1: "5/4 b.t road, khardah", address_line2: "new road", city: "kolkata", pincode: '700119'}
      expect(response).to redirect_to(user2)
    end
  end

  describe 'GET #admin_login' do
    it 'returns a success response' do
      get :admin_login
      expect(response).to be_successful
    end
  end

  describe 'POST #check_admin' do
    let(:admin_user) { FactoryBot.create(:user, admin: true, password: 'password')}
    it 'logs in an admin user with valid credentials' do
      
      post :check_admin, params: { email: admin_user.email, password: 'password' }
      expect(session[:user_id]).to eq(admin_user.id)
      expect(response).to redirect_to(admin_user)
    end

    it 'redirects to admin_login with invalid credentials' do
      post :check_admin, params: { email: user2.email, password: 'wrong_password' }
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(admin_login_users_path)
    end
  end
end

#rubocop:enable all