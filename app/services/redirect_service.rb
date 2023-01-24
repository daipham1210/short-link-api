class RedirectService
  class << self
    REDIRECT_CODE = {
      'SUCCESS' => 'SUCCESS',
      'LINK_NOT_FOUND' => 'LINK_NOT_FOUND',
      'NEED_VERIFY_PASS' => 'NEED_VERIFY_PASS',
      'VERIFY_FAILED' => 'VERIFY_FAILED'
    }.freeze

    def success_payload(link)
      link.increment!(:hits)
      ServiceResponse.success(payload: {
                                code: REDIRECT_CODE['SUCCESS'],
                                data: ShortUrlSerializer.new(link).serializable_hash
                              })
    end

    def check(params)
      shorten = params[:shorten].to_s || ''
      password = params[:password].to_s || ''

      link = ShortUrl.find_by_shorten(shorten)
      if !link || link.expired?
        ServiceResponse.success(payload: { code: REDIRECT_CODE['LINK_NOT_FOUND'] })
      elsif link.secured?
        return authenticate_link(link, password) unless password.empty?

        ServiceResponse.success(payload: { code: REDIRECT_CODE['NEED_VERIFY_PASS'] })
      else
        success_payload(link)
      end
    end

    def authenticate_link(link, password)
      if link.authenticate(password)
        success_payload(link)
      else
        ServiceResponse.success(payload: { code: REDIRECT_CODE['VERIFY_FAILED'] })
      end
    end
  end
end
