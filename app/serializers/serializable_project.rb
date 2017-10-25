class SerializableProject < JSONAPI::Serializable::Resource
  type 'project'

  attributes :project_name

  attribute :date do
    {
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end
end
