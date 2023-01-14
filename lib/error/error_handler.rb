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
        rescue_from CustomError do |e|
          respond(e.error, e.status, e.messages)
        end
        rescue_from StandardError do
          respond(:internal_server_error, 500, 'Something went wrong')
        end
      end
    end

    private

    def respond(error, status, messages)
      messages = [messages] unless messages.is_a?(Array)
      render json: { error:, messages: }, status:
    end
  end

  class RecordNotFound < CustomError
    def initialize(messages)
      super(:record_not_found, 404, messages)
    end
  end

  class InvalidPayload < CustomError
    def initialize(messages)
      super(:invalid_payload, 400, messages)
    end
  end
end
