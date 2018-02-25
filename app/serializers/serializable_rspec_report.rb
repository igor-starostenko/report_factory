# frozen_string_literal: true

# Formats Rspec Reports JSON API
class SerializableRspecReport < JSONAPI::Serializable::Resource
  include RspecReportSerializers

  type 'rspec_report'

  attribute :project_name do
    @object.project.project_name
  end
  attribute :project_id do
    @object.project.id
  end
  attribute :report_id do
    @object.report.id
  end
  attribute :report_type do
    'RSpec'
  end
  attribute :version
  attribute :examples do
    serialize_examples(@object)
  end
  attribute :summary do
    serialize_summary(@object)
  end
  attribute :summary_line
  attribute :date do
    {
      created_at: @object.report.created_at,
      updated_at: @object.report.updated_at
    }
  end
end
