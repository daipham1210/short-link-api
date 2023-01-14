class ShortUrlContract < Dry::Validation::Contract
  params do
    required(:label).filled(:string)
    required(:origin).filled(:string)
    optional(:shorten).filled(:string)
  end

  rule(:origin) do
    key.failure('has invalid format') unless HttpUrlValidator.compliant?(value)
  end

  rule(:shorten) do |context:|
    key.failure('has invalid format') if key? && value.length > ShortUrl::CUSTOM_SHORTEN_LENGTH
    key.failure('has been used') if context[:is_create] && ShortUrl.exists?(shorten: value)
  end
end
