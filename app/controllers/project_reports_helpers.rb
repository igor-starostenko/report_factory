# frozen_string_literal: true

# Common functionality for
# ProjectRspecReportController and ProjectMochaReportController
module ProjectReportsHelpers
  def new_report(reportable)
    @report = Report.new(project_id: @project.id,
                         reportable_type: reportable.class,
                         status: reportable.status,
                         tags: attributes(:report).fetch(:tags, []),
                         reportable_id: reportable.id)
  end

  def new_user_report
    @user_report = UserReport.new(user_id: @auth_user.id,
                                  report_id: @report.id)
  end

  def render_bad_report
    render json: { error: 'Bad report' }, status: :bad_request
  end

  def per_page
    @per_page ||= params.fetch(:per_page, 30)
  end

  def tags
    @tags ||= params[:tags]&.map(&:downcase)
  end
end
