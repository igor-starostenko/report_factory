def format_rspec_report(json, user_report)
  report = user_report.report
  rspec_report = report.reportable

  json.project_name report.project.project_name
  json.project_id report.project.id
  json.report_id report.id
  json.report_type 'RSpec'
  json.version rspec_report.version
  json.examples rspec_report.examples do |example|
    json.id example.id
    json.spec_id example.spec_id
    json.description example.description
    json.full_description example.full_description
    json.status example.status
    json.file_path example.file_path
    json.line_number example.line_number
    json.run_time example.run_time
    json.pending_message example.pending_message
    if example.exception
      json.exception do
        exception = example.exception

        json.id exception.id
        json.rspec_example_id exception.rspec_example_id
        json.classname exception.classname
        json.message exception.message
        json.backtrace exception.backtrace
      end
    end
  end
  json.summary do
    summary = rspec_report.summary

    json.id summary.id
    json.duration summary.duration
    json.example_count summary.example_count
    json.failure_count summary.failure_count
    json.pending_count summary.pending_count
    json.errors_outside_of_examples_count summary.errors_outside_of_examples_count
  end
  json.summary_line rspec_report.summary_line
  json.date do
    json.created_at report.created_at
    json.updated_at report.updated_at
  end
end

json.data @user_reports do |user_report|
  json.id user_report.id
  json.type 'user_report'

  json.attributes do
    json.user_id user_report.user.id
    json.user_name user_report.user.name

    json.report do
      reportable_type = user_report.report.reportable_type
      __send__("format_#{reportable_type.underscore}", json, user_report)
    end
  end
end
