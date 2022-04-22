# frozen_string_literal: true

RSpec.shared_examples 'all attributes labels present' do
  it 'all author attributes labels present' do
    expect(author_form).to have_first_name_label
    expect(author_form).to have_last_name_label
    expect(author_form).to have_description_label
    expect(author_form).to have_submit_button
    expect(author_form).to have_cancel_button
  end
end

RSpec.shared_examples 'updates author`s attributes' do
  it 'updates author`s attributes' do
    expect(author.first_name).to eq(params[:first_name])
    expect(author.last_name).to eq(params[:last_name])
    expect(author.description).to eq(params[:description])
  end
end

RSpec.shared_examples 'shows apropriate flash message' do
  it 'shows apropriate flash message' do
    expect(page).to have_flash_notice
    expect(page.flash_notice.text).to match(notice_message)
  end
end

RSpec.shared_examples 'returns blank errors' do
  let(:params) { { first_name: '', last_name: '', description: '' } }
  let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

  before { author_form.fill_and_submit_form(params) }

  it 'returns blank errors' do
    expect(author_form).to have_first_name_error(text: error_message)
    expect(author_form).to have_last_name_error(text: error_message)
    expect(author_form).to have_description_error(text: error_message)
  end
end
