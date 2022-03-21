# frozen_string_literal: true

module Pages
  module Books
    class Index < SitePrism::Page
      set_url '/books{?query*}'

      element :page_title, 'h1.general-title-margin'
    end
  end
end
