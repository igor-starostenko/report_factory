require 'rails_helper'

RSpec.describe 'routing to projects', :projects, type: :routing do
  it 'routes GET /api/v1/projects to projects#index' do
    expect(get: '/api/v1/projects').to route_to(
      controller: 'projects',
      action: 'index'
    )
  end

  it 'routes POST /api/v1/projects to projects#create' do
    expect(post: '/api/v1/projects').to route_to(
      controller: 'projects',
      action: 'create'
    )
  end

  it 'routes GET /api/v1/projects/:project_name to projects#show' do
    expect(get: '/api/v1/projects/web_project').to route_to(
      controller: 'projects',
      action: 'show',
      project_name: 'web_project'
    )
  end

  it 'routes PUT /api/v1/projects/:project_name to projects#update' do
    expect(put: '/api/v1/projects/web_project').to route_to(
      controller: 'projects',
      action: 'update',
      project_name: 'web_project'
    )
  end
end
