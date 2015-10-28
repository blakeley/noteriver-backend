class BaseSerializer < ActiveModel::Serializer
  def attributes *args
    Hash[super.map do |key, value|
      [key.to_s.dasherize.to_sym, value]
    end]
  end
end
