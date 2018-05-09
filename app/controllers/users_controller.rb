class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    User.transaction do
      @user = User.create!(params.require(:user).permit(:username))
      @user.verify
    end
    render action: :show
  rescue User::IdentityVerificationError
    render_error(400, "Identity Verification Failure!")
  end
  
  def destroy
    @user = User.destroy(params[:id])
    render action: :show
  end
end