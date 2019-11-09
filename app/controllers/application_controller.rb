class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def set_search
   @items = Item.where(state:nil)
   @search = @items.ransack(params[:q])
   @searchs = @search.result.page(params[:page]).per(16).order('updated_at DESC')
  end

    protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:self_introduction])
        devise_parameter_sanitizer.permit(:account_update, keys: [:request])
        devise_parameter_sanitizer.permit(:account_update, keys: [:image])
      end






  private



end
