require 'rails_helper'

RSpec.describe 'routing to reports', :reports, type: :routing do
  it 'routes GET /api/v1/projects/:project_name/reports to reports#index' do
    expect(get: '/api/v1/projects/web_project/reports').to route_to(
      controller: 'reports',
      action: 'index',
      project_name: 'web_project'
    )
  end
end
