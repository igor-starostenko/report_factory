# frozen_string_literal: true

# Formats Reports JSON API
class SerializableReport < JSONAPI::Serializable::Resource
  type 'reports'

  attribute :project_name do
    @object.project.project_name
  end
  attributes :project_id, :reportable_type, :reportable_id, :status, :tags

  attribute :date do
    {
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end
end
