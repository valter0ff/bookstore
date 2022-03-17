# frozen_string_literal: true

RSpec.describe Author do
  let(:author) { create(:author) }

  describe 'ActiveRecord associations' do
    it { expect(author).to have_many(:author_books).dependent(:destroy) }
    it { expect(author).to have_many(:books).through(:author_books) }
  end
  
  describe 'database columns exists' do
    it { expect(author).to have_db_column(:first_name).of_type(:string) }
    it { expect(author).to have_db_column(:last_name).of_type(:string) }
  end
end
