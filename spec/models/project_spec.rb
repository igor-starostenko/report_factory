# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, :project, type: :model do
  let :project { FactoryBot.create(:project, project_name: 'Web App') }

  it 'has :project_name' do
    expect(project).to be_valid
  end

  it 'has :timestamps' do
    expect(project.created_at).to be_truthy
    expect(project.updated_at).to be_truthy
  end

  it 'is not valid without :project_name' do
    project.project_name = nil
    expect(project).to_not be_valid
  end

  it 'is not valid with :project_name < 3' do
    project.project_name = 'AB'
    expect(project).to_not be_valid
  end

  it 'is not valid with :project_name > 10' do
    project.project_name = '12345678901'
    expect(project).to_not be_valid
  end
end
