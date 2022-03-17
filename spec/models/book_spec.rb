# frozen_string_literal: true

RSpec.describe Book do
  let(:category) { create(:category) }
  let(:book) { create(:book, category: category) }
  
  describe 'ActiveRecord associations' do
    it { expect(book).to belong_to(:category).counter_cache }
    it { expect(book).to have_many(:author_books).dependent(:destroy) }
    it { expect(book).to have_many(:authors).through(:author_books) }
    it { expect(book).to have_many(:book_materials).dependent(:destroy) }
    it { expect(book).to have_many(:materials).through(:book_materials) }
    it { expect(book).to have_many(:reviews).dependent(:destroy) }
  end
  
  describe 'ActiveModel validations' do
    it { expect(book).to validate_presence_of(:title) }
    
    it 'is valid with title' do
      expect(book).to be_valid
    end

    it 'is not valid without a title' do
      book.title = nil
      expect(book).not_to be_valid
    end
  end

  describe 'database columns exists' do
    it { expect(book).to have_db_column(:title).of_type(:string) }
    it { expect(book).to have_db_column(:description).of_type(:string) }
    it { expect(book).to have_db_column(:year_publication).of_type(:integer) }
    it { expect(book).to have_db_column(:height).of_type(:float) }
    it { expect(book).to have_db_column(:width).of_type(:float) }
    it { expect(book).to have_db_column(:depth).of_type(:float) }
    it { expect(book).to have_db_column(:price).of_type(:float) }
    it { expect(book).to have_db_column(:quantity).of_type(:integer) }
    it { expect(book).to have_db_column(:category_id).of_type(:integer).with_options(null: false) }
    it { expect(book).to have_db_index(:title) }
    it { expect(book).to have_db_index(:category_id) }
  end
end
