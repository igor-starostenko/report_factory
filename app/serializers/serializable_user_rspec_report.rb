# frozen_string_literal: true

# Formats User RSpec Reports JSON API
# NOTE: Not being used. Might be helpful in future
class SerializableUserRspecReport < JSONAPI::Serializable::Resource
  include RspecReportSerializers

  type 'user_rspec_report'

  attribute :user_id do
    @object.user.id
  end
  attribute :user_name do
    @object.user.name
  end
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
end
