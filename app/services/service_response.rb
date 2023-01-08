# frozen_string_literal: true

class ServiceResponse
  def self.success(message: nil, payload: {})
    new(status: :success, message:, payload:)
  end

  def self.error(message:, payload: {})
    new(status: :error, message:, payload:)
  end

  attr_reader :status, :message, :payload

  def initialize(status:, message: nil, payload: {})
    self.status = status
    self.message = message
    self.payload = payload
  end

  def [](key)
    to_h[key]
  end

  def to_h
    (payload || {}).merge(status:, message:)
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end

  def errors
    return [] unless error?

    Array.wrap(message)
  end

  private

  attr_writer :status, :message, :payload
end
