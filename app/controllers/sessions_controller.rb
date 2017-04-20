class SessionsController < ApplicationController
  def create
    begin

        begin 
          user = Lender.find_by_email(params[:session][:email])
          session[:user_type] = "lender"
          session[:user_id] = user.id
          redirect_to lender_path user
        rescue
          user = Borrower.find_by_email(params[:session][:email])
          session[:user_type] = "borrower"
          session[:user_id] = user.id
          redirect_to borrower_path user
        end
          user.authenticate(params[:session][:password])
    rescue 
          flash[:login_error] = "Could not find a user with that email and password combination"
          redirect_to online_lending_login_path
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    flash[:message] = 'You have successfully logged out'
    redirect_to online_lending_login_path
  end
end
