# frozen_string_literal: true

class CatalogViewObject < BaseViewObject
  def category_dropdown(model)
    h.select_tag 'category_id',
                 options_from_collection_for_select(model, 'id', 'title', h.session[:category_id]),
                 { include_blank: 'All',
                   data: { toggle: 'dropdown' },
                   aria: { haspopup: 'true', expanded: 'false' },
                   onchange: 'this.form.submit();',
                   class: 'dropdown-toggle lead small select-tag' }
  end

  def sorting_dropdown
    h.select_tag 'sorted_by',
                 options_for_select(t('books.catalog.sorting_hash').invert, h.session[:sorted_by]),
                 { data: { toggle: 'dropdown' },
                   aria: { haspopup: 'true', expanded: 'false' },
                   onchange: 'this.form.submit();',
                   class: 'dropdown-toggle lead small select-tag' }
  end
end
