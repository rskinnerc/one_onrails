require 'rails_helper'

RSpec.describe SettingsHelper, type: :helper do
  describe '#theme' do
    context 'when user is nil' do
      it 'returns the default theme' do
        expect(helper.theme_for(nil)).to eq('winter')
      end
    end

    context 'when user is present' do
      let!(:user) { create(:user) }

      context 'when user has a setting' do
        let!(:setting) { create(:user_setting, user: user, theme: 'night') }

        it 'returns the user setting theme' do
          expect(helper.theme_for(user)).to eq('night')
        end
      end

      context 'when user does not have a setting' do
        it 'returns the default theme' do
          expect(helper.theme_for(user)).to eq('winter')
        end
      end
    end
  end
end
