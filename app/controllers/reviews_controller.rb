# frozen_string_literal: true

class ReviewsController < ClientController
  def create
    @book = Book.find(params[:book_id]).decorate
    @review = @book.reviews.new(review_params)
    if @review.save
      redirect_to book_path(@book), notice: I18n.t('reviews.create.success')
    else
      set_reviews
      render 'books/show', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :rating).merge(user_account_id: current_user.id)
  end

  def set_reviews
    @reviews = @book.reviews.includes(user_account: %i[billing_address shipping_address]).order(:created_at).decorate
  end
end
