# frozen_string_literal: true

RSpec.describe Picture, type: :model do
  subject(:picture) { create(:picture, imageable: user) }

  let(:user) { create(:user_account) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:imageable).optional }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:imageable_type).of_type(:string) }
    it { is_expected.to have_db_column(:imageable_id).of_type(:integer) }
    it { is_expected.to have_db_column(:image_data).of_type(:text) }
  end

  describe 'database indexes exists' do
    it { is_expected.to have_db_index(%i[imageable_type imageable_id]) }
  end
end
