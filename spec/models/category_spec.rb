# frozen_string_literal: true

RSpec.describe Category do
  subject(:category) { create(:category, title: good_title) }
  
  let(:good_title) { FFaker::Book.unique.genre }

  describe 'ActiveRecord associations' do
    it { should have_many(:books).dependent(:destroy) }
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:title) }

    it 'is valid with title' do
      expect(category).to be_valid
    end

    it 'is not valid without a title' do
      category.title = nil
      expect(category).not_to be_valid
    end
  end

  describe 'database columns exists' do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:books_count).of_type(:integer) }
  end
end
