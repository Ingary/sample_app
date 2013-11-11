class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	  if user && user.authenticate(params[:session][:password])
        # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_back_or user
  	  else
        flash.now[:error] = 'Invalid email/password combination'
        #The issue is that the contents of the flash persist for one request, but—unlike a 
        #redirect, re-rendering a template with render doesn’t count as a request.
        #To get the failing test to pass, instead of flash we use flash.now, which is 
        #specifically designed for displaying flash messages on rendered pages; unlike the 
        #contents of flash, its contents disappear as soon as there is an additional request. 
        render 'new'
  	  end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
