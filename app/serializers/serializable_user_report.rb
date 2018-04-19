# frozen_string_literal: true

# Formats User Reports JSON API
class SerializableUserReport < JSONAPI::Serializable::Resource
  type 'user_report'

  attribute :user_id do
    @object.user.id
  end
  attribute :user_name do
    @object.user.name
  end
  attribute :report do
    report = @object.report
    if report.reportable_type == 'RspecReport'
      {
        project_name: report.project.project_name,
        project_id: report.project.id,
        report_id: report.id,
        report_type: 'RSpec',
        date: { created_at: report.created_at,
                updated_at: report.updated_at }
      }
    end
  end
end
