require 'rails_helper'

RSpec.describe 'general routing', type: :routing do
  it 'does not expose api' do
    expect(get: '/api/v1').not_to be_routable
    expect(get: '/api').not_to be_routable
  end
end
