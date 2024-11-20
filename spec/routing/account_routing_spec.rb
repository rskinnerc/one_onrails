require 'rails_helper'

RSpec.describe 'AccountController', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: "/account").to route_to("account#index")
    end
  end
end
