# frozen_string_literal: true

module Pages
  module HomePages
    class Index < SitePrism::Page
      set_url '/'

      section :header, 'header' do
        element :site_title, 'a.navbar-brand', text: I18n.t('partials.header.site_title')
        element :home_btn, 'li>a', text: I18n.t('partials.header.home_link')
        element :log_in_link, 'li>a.log-in-link', text: I18n.t('partials.header.log_in')
        element :sign_up_link, 'li>a.sign-up-link', text: I18n.t('partials.header.sign_up')
        element :shop_btn, 'li>a.dropdown-toggle', text: I18n.t('partials.header.shop_link')
        section :shop_menu, 'ul.dropdown-menu' do
          element :mobile_dev_btn, 'li>a', text: I18n.t('partials.header.categories.mobile_dev_category')
          element :photo_btn, 'li>a', text: I18n.t('partials.header.categories.photo_category')
          element :web_design_btn, 'li>a', text: I18n.t('partials.header.categories.web_design_category')
          element :web_dev_btn, 'li>a', text: I18n.t('partials.header.categories.web_development_category')
        end
      end

      section :footer, 'footer' do
        element :home_link, 'li>a', text: I18n.t('partials.footer.home')
        element :shop_link, 'li>a', text: I18n.t('partials.footer.shop')
        element :orders_link, 'li>a', text: I18n.t('partials.footer.orders')
        element :settings_link, 'li>a', text: I18n.t('partials.footer.settings')
        element :email, 'p.general-nav-mail'
        element :phone_number, 'p.general-nav-number'
        section :social_buttons, '#social_buttons' do
          element :facebook, 'a .fa-facebook'
          element :twitter, 'a .fa-twitter'
          element :google_plus, 'a .fa-google-plus'
          element :instagram, 'a .fa-instagram'
        end
      end

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
