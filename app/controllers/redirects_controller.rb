class RedirectsController < ApplicationController
  def show
    @short_url = ShortUrl.find_by_shorten(params[:shorten])
    return render 'errors/404', status: 404 if @short_url.nil?

    @short_url.increment!(:hits)
    redirect_to @short_url.origin, allow_other_host: true
  end
end
