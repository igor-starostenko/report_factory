require 'rails_helper'

RSpec.describe 'routing to rspec reports', :rspec_reports, type: :routing do
  it 'routes GET /api/v1/projects/:project_name/reports/rspec to reports#index' do
    expect(get: '/api/v1/projects/web_project/reports/rspec').to route_to(
      controller: 'rspec_reports',
      action: 'index',
      project_name: 'web_project'
    )
  end

  it 'routes POST /api/v1/projects/:project_name/reports/rspec to reports#create' do
    expect(post: '/api/v1/projects/web_project/reports/rspec').to route_to(
      controller: 'rspec_reports',
      action: 'create',
      project_name: 'web_project'
    )
  end

  it 'routes GET /api/v1/projects/:project_name/reports/rspec/:id to reports#show' do
    expect(get: '/api/v1/projects/web_project/reports/rspec/1').to route_to(
      controller: 'rspec_reports',
      action: 'show',
      project_name: 'web_project',
      id: '1'
    )
  end
end
