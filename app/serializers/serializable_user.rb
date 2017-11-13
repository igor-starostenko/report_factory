# frozen_string_literal: true

# Formats Users JSON API
class SerializableUser < JSONAPI::Serializable::Resource
  type 'user'

  attributes :name, :email, :api_key, :type

  attribute :date do
    {
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end
end
