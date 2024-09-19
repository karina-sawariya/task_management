class UsersController < ApplicationController
  skip_before_action :authenticate_user
  before_action :find_user, only: [:show, :update, :destroy]

  def index 
    @user = User.all 
    render json: @users, status:  200 
  end

  def show 
    render json: @user, status:  200 
  end 

  def create
    user = User.new(user_params)
    if user.save
      token = encode_jwt_token(user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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

  def encode_jwt_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.secrets.secret_key_base, 'HS256')
  end
end
  