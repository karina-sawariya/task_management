class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @tasks = @current_user.tasks
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = @current_user.tasks.new(task_params)
    if @task.save
      schedule_reminder(@task)
      render json: @task, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      schedule_reminder(@task)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = @current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :start_date, :end_date, :status, :user_id)
  end

  def schedule_reminder(task)
    TaskReminderJob.set(wait_until: task.end_date - 1.day).perform_later(task)
    TaskReminderJob.set(wait_until: task.end_date - 1.hour).perform_later(task)
  end
end
