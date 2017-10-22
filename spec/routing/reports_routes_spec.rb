require 'rails_helper'

RSpec.describe 'routing to reports', :reports, type: :routing do
  it 'routes GET /api/v1/projects/:project_name/reports to reports#index' do
    expect(get: '/api/v1/projects/web_project/reports').to route_to(
      controller: 'reports',
      action: 'index',
      project_name: 'web_project'
    )
  end

  it 'routes POST /api/v1/projects/:project_name/reports to reports#create' do
    expect(post: '/api/v1/projects/web_project/reports').to route_to(
      controller: 'reports',
      action: 'create',
      project_name: 'web_project'
    )
  end

  it 'routes GET /api/v1/projects/:project_name/reports/:id to reports#show' do
    expect(get: '/api/v1/projects/web_project/reports/1').to route_to(
      controller: 'reports',
      action: 'show',
      project_name: 'web_project',
      id: '1'
    )
  end
end
