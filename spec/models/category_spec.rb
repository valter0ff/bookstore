# frozen_string_literal: true

RSpec.describe Category do
  let(:good_title) { FFaker::Book.unique.genre }
  let(:category) { create(:category, title: good_title) }
   
  describe 'ActiveRecord associations' do
    it { expect(category).to have_many(:books).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { expect(category).to validate_presence_of(:title) }
  
    it 'is valid with title' do
      expect(category).to be_valid
    end

    it 'is not valid without a title' do
      category.title = nil
      expect(category).not_to be_valid
    end
  end
  
  describe 'database columns exists' do
    it { expect(category).to have_db_column(:title).of_type(:string) }
    it { expect(category).to have_db_column(:books_count).of_type(:integer) }
  end
end
