# frozen_string_literal: true

RSpec.describe Author do
  subject(:author) { create(:author) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:books).through(:author_books) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
  end
end
