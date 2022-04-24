# frozen_string_literal: true

class ReviewsController < ClientController
  def create
    @book = Book.find_by(id: params[:book_id]).decorate
    @review = @book.reviews.new(review_params)
    if @review.save
      redirect_to book_path(@book), notice: I18n.t('reviews.create.success')
    else
      render 'books/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :rating).merge(user_account_id: current_user.id)
  end
end
