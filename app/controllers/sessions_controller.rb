class SessionsController < ApplicationController
  # GET /login
  def new; end

  # POST /login
  def create
    # byebug
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      # important to use flash.now instead of flash
      flash.now[:alert] = 'Email or password is invalid'
      # must return status to show message flash.now[:alert]
      render :new, status: :unauthorized
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
