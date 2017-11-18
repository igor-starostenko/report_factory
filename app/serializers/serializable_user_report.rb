# frozen_string_literal: true

# Formats User Reports JSON API
class SerializableUserReport < JSONAPI::Serializable::Resource
  type 'user_report'

  attribute :user_id { @object.user.id }
  attribute :user_name { @object.user.name }
  attribute :report do
    report = @object.report
    if report.reportable_type == 'RspecReport'
    {
      project_name: report.project.project_name,
      project_id: report.project.id,
      report_id: report.id,
      report_type: 'RSpec',
      version: report.reportable.version,
      examples: 
        report.reportable.examples&.map do |example|
          example.serializable_hash(except: :rspec_report_id).tap do |e|
            e[:exception] = example.exception&.
              serializable_hash(except: :rspec_example_id)
          end
        end,
      summary: report.reportable.summary&.serializable_hash(except: :rspec_report_id),
      summary_line: report.reportable.summary_line,
      date: { created_at: report.created_at,
              updated_at: report.updated_at }
    }
    end
  end
end
