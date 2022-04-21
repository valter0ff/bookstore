# frozen_string_literal: true

RSpec.describe 'Reviews->Show', type: :feature do
  let(:show_review_page) { Pages::Admin::Reviews::Show.new }
  let(:admin) { create(:admin_user) }
  let(:review) { create(:review) }

  before do
    sign_in(admin)
    show_review_page.load(id: review.id)
  end

  context 'when shows review info section' do
    let(:review_info) { show_review_page.review_info }

    it 'all fields present with appropriate values' do
      expect(review_info).to have_review_title(text: review.title)
      expect(review_info).to have_body(text: review.body)
      expect(review_info).to have_rating(text: review.rating)
      expect(review_info).to have_book(text: review.book.title)
      expect(review_info).to have_user_account(text: review.user_account.email)
      expect(review_info).to have_status(text: review.status)
      expect(review_info).to have_created_at(text: I18n.l(review.created_at, format: :admin))
      expect(review_info).to have_updated_at(text: I18n.l(review.updated_at, format: :admin))
    end
  end

  context 'when shows action buttons section' do
    let(:buttons_section) { show_review_page.action_buttons }

    it 'all buttons present' do
      expect(buttons_section).to have_approve_button
      expect(buttons_section).to have_reject_button
      expect(buttons_section).to have_delete_button
    end
  end

  context 'when delete button clicked', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Review.to_s) }

    it 'deletes review from database' do
      expect { show_review_page.delete_review }.to change(Review, :count).by(-1)
    end

    it 'redirects to reviews index page' do
      show_review_page.delete_review
      expect(page).to have_current_path(admin_reviews_path)
    end

    it 'shows apropriate flash message' do
      show_review_page.delete_review
      expect(show_review_page).to have_flash_notice
      expect(show_review_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when `Approve` button clicked' do
    let(:approve_review) { show_review_page.action_buttons.approve_button.click }
    let(:notice_message) { I18n.t('reviews.admin.approved') }

    it 'changes review`s status' do
      expect { approve_review }.to change { review.reload.status }.from('unprocessed').to('approved')
    end

    it 'shows apropriate flash message' do
      approve_review
      expect(show_review_page).to have_flash_notice
      expect(show_review_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when `Reject` button clicked' do
    let(:reject_review) { show_review_page.action_buttons.reject_button.click }
    let(:notice_message) { I18n.t('reviews.admin.rejected') }

    it 'changes review`s status' do
      expect { reject_review }.to change { review.reload.status }.from('unprocessed').to('rejected')
    end

    it 'shows apropriate flash message' do
      reject_review
      expect(show_review_page).to have_flash_notice
      expect(show_review_page.flash_notice.text).to match(notice_message)
    end
  end
end
