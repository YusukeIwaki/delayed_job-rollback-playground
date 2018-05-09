class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.create!(params.require(:user).permit(:username))
    render action: :show
  end
  
  def destroy
    @user = User.destroy(params[:id])
    render action: :show
  end
end