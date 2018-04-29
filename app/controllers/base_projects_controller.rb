# frozen_string_literal: true

# Abstract class that stores common behavior for all controllers
# that are routed from /api/v1/projects
class BaseProjectsController < ApplicationController
  private

  def set_project
    @project = Project.by_name(project_name)
    return render_not_found(:project) unless @project
  end

  def project_name
    params.fetch(:project_name)
  end
end
