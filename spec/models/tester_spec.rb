# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tester, :tester, type: :model do
  let :tester do
    FactoryBot.create(:tester,
                      name: 'Tester',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
  end

  it 'is valid' do
    expect(tester).to be_valid
  end

  it 'has :type' do
    expect(tester.type).to eql(described_class.to_s)
  end
end
