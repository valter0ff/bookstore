# frozen_string_literal: true

module Pages
  module LayoutPartials
    class Footer < SitePrism::Section
      set_default_search_arguments 'footer'

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
  end
end
