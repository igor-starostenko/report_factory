# frozen_string_literal: true

# Helpers for RSpecReports Serializables
module RspecReportSerializers
  def serialize_examples(rspec_report)
    rspec_report.examples.order('id asc')&.map do |example|
      example.serializable_hash(except: :rspec_report_id).tap do |e|
        if example.exception
          e[:exception] = example.exception&.
            serializable_hash(except: :rspec_example_id)
        end
      end
    end
  end

  def serialize_summary(rspec_report)
    rspec_report.summary&.serializable_hash(except: :rspec_report_id)
  end
end
