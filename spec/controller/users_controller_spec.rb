require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password',
      user_name: 'testuser'
    )
  end

  describe 'GET #index' do
    it 'returns a success message for users' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'returns a specific user' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user ' do
        post :create, params: {
          user: {
            email: 'newuser@example.com',
            password: 'password',
            password_confirmation: 'password',
            user_name: 'newuser'
          }
        }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'returns validation errors' do
        post :create, params: {
          user: {
            email: 'invalidemail',
            password: 'password',
            password_confirmation: 'mismatchpassword',
            user_name: ''
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the user' do
        put :update, params: { id: user.id, user: { user_name: 'updatedname' } }
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid attributes' do
      it 'returns error messages' do
        put :update, params: {
          id: user.id,
          user: { email: '' }
        }
        expect(response).to have_http_status(503)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end
  end
end
