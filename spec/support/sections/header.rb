# frozen_string_literal: true

module Sections
  class Header < SitePrism::Section
    set_default_search_arguments 'header'

    element :home_btn, 'li>a', text: I18n.t('partials.header.home_link')
    element :my_account_btn, 'li>a', text: I18n.t('partials.header.my_account')
    element :shop_btn, 'li>a', text: I18n.t('partials.header.shop_link')
    section :shop_menu, 'ul.dropdown-menu' do
      element :mobile_dev_btn, 'li>a', text: I18n.t('partials.header.categories.mobile_dev_category')
      element :photo_btn, 'li>a', text: I18n.t('partials.header.categories.photo_category')
      element :web_design_btn, 'li>a', text: I18n.t('partials.header.categories.web_design_category')
      element :web_dev_btn, 'li>a', text: I18n.t('partials.header.categories.web_development_category')
    end
  end
end
