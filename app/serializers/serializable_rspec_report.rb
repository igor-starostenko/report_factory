# frozen_string_literal: true

# Formats Rspec Reports JSON API
class SerializableRspecReport < JSONAPI::Serializable::Resource
  type 'rspec_report'

  attribute :project_name { @object.project.project_name }
  attribute :project_id { @object.project.id }
  attribute :report_id { @object.report.id }
  attribute :report_type { 'RSpec' }
  attribute :version
  attribute :examples do
    @object.examples&.map { |e| e.serializable_hash(except: :rspec_report_id) }
  end
  attribute :summary do
    @object.summary&.serializable_hash(except: :rspec_report_id)
  end
  attribute :summary_line
  attribute :date do
    {
      created_at: @object.report.created_at,
      updated_at: @object.report.updated_at
    }
  end
end
