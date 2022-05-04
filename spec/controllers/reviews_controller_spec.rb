# frozen_string_literal: true

RSpec.describe ReviewsController, type: :controller do
  let(:book) { create(:book) }
  let(:user) { create(:user_account) }

  before { sign_in(user) }

  describe '#create' do
    let(:make_request) { post :create, params: { review: review_params }.merge(book_id: book.id) }

    before { |example| make_request unless example.metadata[:skip_request] }

    context 'when review create successfull' do
      let(:redirect_status) { 302 }
      let(:review_params) { attributes_for(:review) }
      let(:success_message) { I18n.t('reviews.create.success') }

      it { is_expected.to respond_with(redirect_status) }
      it { is_expected.to redirect_to(book_path(book)) }
      it { is_expected.to set_flash[:notice].to(success_message) }

      it 'assigns book and review variables to corresponding objects' do
        expect(assigns(:book)).to eq(book)
        expect(assigns(:review)).to eq(book.reload.reviews.first)
        expect(assigns(:review).user_account_id).to eq(user.id)
      end

      it 'creates new address', skip_request: true do
        expect { make_request }.to change(Review, :count).by(1)
      end
    end

    context 'when review creation failed' do
      let(:review_params) { { title: '', rating: 0, body: '' } }
      let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

      it { is_expected.to render_template('books/show') }
      it { expect(response.status).to eq(422) }

      it 'assigns variables with separate objects' do
        expect(assigns(:book)).to eq(book)
        expect(assigns(:review)).to be_a(Review)
      end

      it 'not creates new address', skip_request: true do
        expect { make_request }.not_to change(Review, :count)
      end

      it 'assigns review`s attributes with corresponding errors' do
        expect(assigns(:review).errors[:title].first).to match(error_message)
        expect(assigns(:review).errors[:body].first).to match(error_message)
      end
    end
  end
end
