class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  before_action :find_user, only: [:show, :update, :destroy]

  def index 
    @user = User.all 
    render json: @users, status:  200 
  end

  def show 
    render json: @user, status:  200 
  end 

  def create
    Rails.logger.debug("Received parameters: #{params.inspect}")   
    @user = User.new(user_params)
    if @user.save
      render json: { message: "User created successfully" }, status: :created
    else
      Rails.logger.debug("User errors: #{@user.errors.full_messages.inspect}")
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: {errors: @user.errors.full_messages}, status: 503
    end
  end 

  def destroy
    @user.destroy
  end 

  private 

  def user_params
    Rails.logger.debug("User params: #{params[:user].inspect}")
    params.require(:user).permit(:email, :password, :password_confirmation, :user_name)
  end
  
  def find_user
    @user = User.find(params[:id])
  end 
end
  