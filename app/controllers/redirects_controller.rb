class RedirectsController < ApplicationController
  include ActionView::Layouts
  include ActionController::Rendering

  def show
    @short_url = ShortUrl.find_by_shorten(params[:shorten])
    if @short_url.nil?
      render 'not_found'
      return
    end

    @short_url.increment!(:hits)
    redirect_to @short_url.origin, allow_other_host: true
  end
end
