# frozen_string_literal: true

# Formats Mocha Reports JSON API
class SerializableMochaReport < JSONAPI::Serializable::Resource
  type 'mocha_report'

  attribute :project_name do
    @object.project.project_name
  end

  attribute :project_id do
    @object.project.id
  end

  attribute :report_id do
    @object.report.id
  end

  attribute :report_tags do
    @object.report.tags
  end

  attribute :report_type do
    'Mocha'
  end

  attribute :tests do
    @object.tests&.map(&:serializable_hash)
  end

  attribute :suites
  attribute :total
  attribute :passes
  attribute :pending
  attribute :failures
  attribute :duration
  attribute :start
  attribute :end

  attribute :date do
    {
      created_at: @object.report.created_at,
      updated_at: @object.report.updated_at
    }
  end
end
