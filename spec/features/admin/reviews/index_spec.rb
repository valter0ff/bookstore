# frozen_string_literal: true

RSpec.describe 'Reviews->Index', type: :feature do
  let(:index_reviews_page) { Pages::Admin::Reviews::Index.new }
  let(:admin) { create(:admin_user) }
  let(:reviews_count) { rand(2..20) }

  before do
    create_list(:review, reviews_count)
    sign_in(admin)
    index_reviews_page.load
  end

  context 'with page elemens' do
    it 'all elements present' do
      expect(index_reviews_page).to have_batch_menu_button
      expect(index_reviews_page).to have_batch_action_destroy_button(text: 'Delete Selected')
    end
  end

  context 'with reviews table' do
    let(:reviews_table) { index_reviews_page.reviews_table }

    it 'all elements present' do
      expect(reviews_table).to have_select_column
      expect(reviews_table).to have_select_all_checkbox
      expect(reviews_table).to have_book_column
      expect(reviews_table).to have_title_column
      expect(reviews_table).to have_date_column
      expect(reviews_table).to have_user_account_column
      expect(reviews_table).to have_status_column
      expect(reviews_table).to have_actions_column
      expect(reviews_table).to have_view_review_buttons
      expect(reviews_table).to have_delete_review_buttons
    end
  end

  context 'when use batch destroy function', js: true, bullet: :skip do
    let(:notice_message) { /Successfully deleted .+ reviews/ }

    it 'deletes reviews from database' do
      expect { index_reviews_page.batch_delete_reviews }.to change(Review, :count).from(reviews_count).to(0)
    end

    it 'shows apropriate flash message' do
      index_reviews_page.batch_delete_reviews
      expect(index_reviews_page).to have_flash_notice
      expect(index_reviews_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when delete one review from table', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Review.to_s) }

    it 'deletes one review from database' do
      expect { index_reviews_page.delete_review }.to change(Review, :count).by(-1)
    end

    it 'shows apropriate flash message' do
      index_reviews_page.delete_review
      index_reviews_page.wait_until_flash_notice_visible
      expect(index_reviews_page).to have_flash_notice
      expect(index_reviews_page.flash_notice.text).to match(notice_message)
    end
  end
end
