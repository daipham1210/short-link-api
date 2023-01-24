class ShortUrlSerializer < ActiveModel::Serializer
  attributes :id, :label, :origin, :expire_at, :short

  def short
    object.short
  end

  def expire_at
    (object.expire_at.to_f * 1000).to_i
  end
end
