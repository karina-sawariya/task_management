class ApplicationController < ActionController::Base
  include JwtToken
  protect_from_forgery with: :null_session

	before_action :authenticate_user

	private
	def authenticate_user
		header = request.headers['Autherization']
		header = header.split(' ').last if header
		begin 
			@decode = JwtToken.decode(header)
			@current_user = User.find(@decode[:user_id])
		rescue ActiveRecord::RecordNotFound => e 
			render json: {errors: e.message}, status: :unauthorized 
		rescue  JWT::DecodeError => e 
			render json: {errors: e.message}, status: :unauthorized 
		end 
	end 
end
