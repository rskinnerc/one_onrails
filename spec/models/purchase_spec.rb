require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'associations' do
    it { should belong_to(:subscription).optional }
    it { should belong_to(:user) }
  end
end
