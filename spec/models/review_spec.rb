# frozen_string_literal: true

RSpec.describe Review do
  let(:review) { create(:review) }

  describe 'ActiveRecord associations' do
    it { expect(review).to belong_to(:book) }
  end
  
  describe 'database columns exists' do
    it { expect(review).to have_db_column(:title).of_type(:string) }
    it { expect(review).to have_db_column(:rating).of_type(:integer) }
    it { expect(review).to have_db_column(:body).of_type(:text) }
    it { expect(review).to have_db_column(:book_id).of_type(:integer).with_options(null: false) }
    it { expect(review).to have_db_index(:book_id) }
  end
end
