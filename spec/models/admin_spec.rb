# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, :admin, type: :model do
  let :admin do
    FactoryBot.create(:admin,
                      name: 'Admin',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
  end

  it 'is valid' do
    expect(admin).to be_valid
  end

  it 'has :type' do
    expect(admin.type).to eql(described_class.to_s)
  end
end
