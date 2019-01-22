# frozen_string_literal: true

# Formats User Reports JSON API
class SerializableUserReport < JSONAPI::Serializable::Resource
  include RspecReportSerializers

  type 'user_report'

  attribute :user_id do
    @object.user.id
  end
  attribute :user_name do
    @object.user.name
  end
  attribute :report do
    report = @object.report
    report_object = {
      project_name: report.project.project_name,
      project_id: report.project.id,
      report_id: report.id,
      report_type: report.reportable_type,
      date: { created_at: report.created_at,
              updated_at: report.updated_at }
    }
    type = @type || 'default'
    __send__("#{type.underscore}_object", report_object, report)
  end

  private

  def default_object(base_report_object, _report = {})
    base_report_object
  end

  def mocha_object(base_report_object, report)
    mocha_report = report.reportable
    hash = mocha_report.serializable_hash.merge!(
      tests: mocha_report.tests&.map(&:serializable_hash)
    )
    base_report_object.merge(hash)
  end

  def rspec_object(base_report_object, report)
    rspec_report = report.reportable
    base_report_object.merge(
      version: rspec_report.version,
      examples: serialize_examples(rspec_report),
      summary: serialize_summary(rspec_report),
      summary_line: rspec_report.summary_line
    )
  end
end
