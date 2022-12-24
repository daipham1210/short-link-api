class ShortUrlSerializer < ActiveModel::Serializer
  attributes :origin, :expire_at, :short

  def short
    object.short
  end
end
