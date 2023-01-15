module Error
  class CustomError < StandardError
    attr_reader :status, :error, :messages

    def initialize(error = nil, status = nil, messages = [])
      @error = error
      @status = status
      @messages = messages
    end
  end

  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          logger.debug(e.message)
          respond(:internal_server_error, 500, 'Something went wrong')
        end
        rescue_from CustomError do |e|
          respond(e.error, e.status, e.messages)
        end
      end
    end

    private

    def respond(error, status, messages)
      messages = [messages] unless messages.is_a?(Array)
      render json: { error:, messages: }, status:
    end
  end
end
