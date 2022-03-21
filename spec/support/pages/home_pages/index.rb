# frozen_string_literal: true

module Pages
  module HomePages
    class Index < SitePrism::Page
      set_url '/'

      section :header, Pages::LayoutPartials::Header
      section :footer, Pages::LayoutPartials::Footer

      element :carousel_left_btn, '.left.carousel-control'
      element :carousel_right_btn, '.right.carousel-control'
      element :get_started_btn, 'a.btn', text: I18n.t('home_pages.index.get_started_button')
      section :best_sellers, 'div#best_sellers' do
        element :best_sellers_title, 'h3', text: I18n.t('home_pages.index.best_sellers_title')
        elements :books_items, 'div.col-sm-6'
      end
    end
  end
end
