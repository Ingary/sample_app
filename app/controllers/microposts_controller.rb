class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def index
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
      #La razón por la que falla, es debido a que render no se considera un request, por lo cual no ejecuta la
      #acción home en el StaticPagesController y es por eso que @feed_items aparece nil.
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end