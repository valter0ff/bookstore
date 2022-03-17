# frozen_string_literal: true

RSpec.describe Book do
  subject(:book) { create(:book, category: category) }
  
  let(:category) { create(:category) }

  describe 'ActiveRecord associations' do
    it { should belong_to(:category).counter_cache }
    it { should have_many(:author_books).dependent(:destroy) }
    it { should have_many(:authors).through(:author_books) }
    it { should have_many(:book_materials).dependent(:destroy) }
    it { should have_many(:materials).through(:book_materials) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:title) }

    it 'is valid with title' do
      expect(book).to be_valid
    end

    it 'is not valid without a title' do
      book.title = nil
      expect(book).not_to be_valid
    end
  end

  describe 'database columns exists' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:string) }
    it { should have_db_column(:year_publication).of_type(:integer) }
    it { should have_db_column(:height).of_type(:float) }
    it { should have_db_column(:width).of_type(:float) }
    it { should have_db_column(:depth).of_type(:float) }
    it { should have_db_column(:price).of_type(:float) }
    it { should have_db_column(:quantity).of_type(:integer) }
    it { should have_db_column(:category_id).of_type(:integer).with_options(null: false) }
    it { should have_db_index(:title) }
    it { should have_db_index(:category_id) }
  end
end
