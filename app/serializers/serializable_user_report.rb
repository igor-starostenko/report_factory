# frozen_string_literal: true

# Formats User Reports JSON API
class SerializableUserReport < JSONAPI::Serializable::Resource
  type 'user_report'

  attribute :user_id { @object.user.id }
  attribute :user_name { @object.user.name }
  attribute :report do
    report = @object.report
    reportable = report.reportable
    if report.reportable_type == 'RspecReport'
      {
        project_name: report.project.project_name,
        project_id: report.project.id,
        report_id: report.id,
        report_type: 'RSpec',
        version: reportable.version,
        examples: serialize_examples(reportable),
        summary: serialize_summary(reportable),
        summary_line: reportable.summary_line,
        date: { created_at: report.created_at,
                updated_at: report.updated_at }
      }
    end
  end

  def serialize_examples(reportable)
    reportable.examples&.map do |example|
      example.serializable_hash(except: :rspec_report_id).tap do |e|
        e[:exception] = example.exception&.
          serializable_hash(except: :rspec_example_id)
      end
    end
  end

  def serialize_summary(reportable)
    reportable.summary&.serializable_hash(except: :rspec_report_id)
  end
end
