# frozen_string_literal: true

# Formats Reports JSON API
class SerializableReport < JSONAPI::Serializable::Resource
  type 'reports'

  attribute :project_name { @object.project.project_name }
  attributes :project_id, :reportable_type, :reportable_id

  attribute :date do
    {
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end
end