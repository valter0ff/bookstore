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

      it { expect(header).to have_site_title }
      it { expect(header).to have_home_btn }
      it { expect(header).to have_my_account_btn }
      it { expect(header).to have_shop_btn }
      it { expect(header).to have_shop_menu }
      it { expect(shop_menu_block).to have_photo_btn }
      it { expect(shop_menu_block).to have_mobile_dev_btn }
      it { expect(shop_menu_block).to have_web_design_btn }
      it { expect(shop_menu_block).to have_web_dev_btn }
    end

    context 'when footer elements present' do
      let(:footer) { home_page.footer }
      let(:social_block) { footer.social_buttons }

      it { expect(footer).to have_home_link }
      it { expect(footer).to have_shop_link }
      it { expect(footer).to have_orders_link }
      it { expect(footer).to have_settings_link }
      it { expect(footer).to have_email }
      it { expect(footer).to have_phone_number }
      it { expect(footer).to have_social_buttons }
      it { expect(social_block).to have_facebook }
      it { expect(social_block).to have_twitter }
      it { expect(social_block).to have_google_plus }
      it { expect(social_block).to have_instagram }
    end

    context 'when page elements present' do
      let(:best_sellers_block) { home_page.best_sellers }

      it { expect(home_page).to have_carousel_left_btn }
      it { expect(home_page).to have_carousel_right_btn }
      it { expect(home_page).to have_get_started_btn }
      it { expect(home_page).to have_best_sellers }
      it { expect(best_sellers_block).to have_books_items }
      it { expect(best_sellers_block).to have_best_sellers_title }
    end

    context 'when `Get started` button clicked' do
      it 'redirects to catalog page' do
        home_page.get_started_btn.click
        expect(page).to have_current_path('/books')
      end
    end
  end
end
