# frozen_string_literal: true

# Formats Rspec Reports JSON API
class SerializableRspecReport < JSONAPI::Serializable::Resource
  type 'rspec_report'

  belongs_to :project do
    {
      project_name: @object.report.project.project_name,
      project_id: @object.report.project_id
    }
  end

  attribute :report_type { 'RSpec' }
  attributes :id
  attribute :date do
    {
      created_at: @object.report.created_at,
      updated_at: @object.report.updated_at
    }
  end
end
