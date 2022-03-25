# frozen_string_literal: true

RSpec.describe Book do
  subject(:book) { create(:book, category: category) }

  let(:category) { create(:category) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:category).counter_cache }
    it { is_expected.to have_many(:author_books).dependent(:destroy) }
    it { is_expected.to have_many(:authors).through(:author_books) }
    it { is_expected.to have_many(:book_materials).dependent(:destroy) }
    it { is_expected.to have_many(:materials).through(:book_materials) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'database columns exists' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:year_publication).of_type(:integer) }
    it { is_expected.to have_db_column(:height).of_type(:float) }
    it { is_expected.to have_db_column(:width).of_type(:float) }
    it { is_expected.to have_db_column(:depth).of_type(:float) }
    it { is_expected.to have_db_column(:price).of_type(:float) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:category_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_index(:title) }
    it { is_expected.to have_db_index(:category_id) }
  end
end
