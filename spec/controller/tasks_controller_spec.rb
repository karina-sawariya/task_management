require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password',
      user_name: 'testuser'
    )
  end

  let!(:task) do
    user.tasks.create!(
      title: 'Test Task',
      description: 'Task description',
      start_date: Time.now,
      end_date: Time.now + 1.day,
      status: 'backlog' 
    )
  end

  # before do
  #   allow(controller).to receive(:authenticate_user).and_return(true)
  #   allow(controller).to receive(:current_user).and_return(user)
  # end

  describe 'GET #index' do
    it 'returns a list of tasks for the current user' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body).first['title']).to eq('Test Task')
    end
  end

  describe 'GET #show' do
    it 'returns a specific task' do
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq('Test Task')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new task and schedules reminders' do
        post :create, params: {
          task: {
            title: 'New Task',
            description: 'New task description',
            start_date: Time.now,
            end_date: Time.now + 1.day,
            status: 'in_progress'  
          }
        }
        expect(response).to have_http_status(:created)
        expect(Task.count).to eq(2)
        expect(JSON.parse(response.body)['title']).to eq('New Task')
      end
    end

    context 'with invalid attributes' do
      it 'returns validation errors' do
        post :create, params: {
          task: {
            title: '',
            description: 'Invalid task',
            start_date: Time.now,
            end_date: Time.now + 1.day,
            status: 'backlog' 
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Task.count).to eq(1)  
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the task' do
        put :update, params: { id: task.id, task: { title: 'Updated Task' } }
        expect(response).to have_http_status(:ok)
        expect(task.reload.title).to eq('Updated Task')
      end
    end

    context 'with invalid attributes' do
      it 'returns validation errors' do
        put :update, params: { id: task.id, task: { title: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the task' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end
