class UsersController < ApplicationController
  def index
    render json: { users: User.all.map{|user| user.attributes.symbolize_keys.slice(:id, :username) } }
  end
  
  def create
    user = User.create!(params.require(:user).permit(:username))
    render json: { user: user.attributes.symbolize_keys.slice(:id, :username) }
  end
  
  def destroy
    user = User.destroy(params[:id])
    render json: { user: user.attributes.symbolize_keys.slice(:id, :username) }
  end
end