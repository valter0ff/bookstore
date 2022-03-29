# frozen_string_literal: true

RSpec.describe 'HomePages' do
  describe '#index' do
    let(:home_page) { Pages::HomePages::Index.new }
    let(:categories) { I18n.t('partials.header.categories').values }

    before do
      categories.map { |name| create(:category, title: name) }
      home_page.load
    end

    context 'when header elements present' do
      let(:header) { home_page.header }
      let(:shop_menu_block) { header.shop_menu }

      it do
        expect(header).to have_site_title
        expect(header).to have_home_btn
        expect(header).to have_log_in_link
        expect(header).to have_sign_up_link
        expect(header).to have_shop_btn
        expect(header).to have_shop_menu
        expect(shop_menu_block).to have_photo_btn
        expect(shop_menu_block).to have_mobile_dev_btn
        expect(shop_menu_block).to have_web_design_btn
        expect(shop_menu_block).to have_web_dev_btn
      end
    end

    context 'when footer elements present' do
      let(:footer) { home_page.footer }
      let(:social_block) { footer.social_buttons }

      it do
        expect(footer).to have_home_link
        expect(footer).to have_shop_link
        expect(footer).to have_email
        expect(footer).to have_phone_number
        expect(footer).to have_social_buttons
        expect(social_block).to have_facebook
        expect(social_block).to have_twitter
        expect(social_block).to have_google_plus
        expect(social_block).to have_instagram
      end
    end

    context 'when page elements present' do
      let(:best_sellers_block) { home_page.best_sellers }

      it do
        expect(home_page).to have_carousel_left_btn
        expect(home_page).to have_carousel_right_btn
        expect(home_page).to have_get_started_btn
        expect(home_page).to have_best_sellers
        expect(best_sellers_block).to have_books_items
        expect(best_sellers_block).to have_best_sellers_title
      end
    end

    context 'when `Get started` button clicked' do
      it 'redirects to catalog page' do
        home_page.get_started_btn.click
        expect(page).to have_current_path('/books')
      end
    end
  end
end
