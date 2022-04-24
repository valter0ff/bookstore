class AddDefaultColumnForRatingToReviews < ActiveRecord::Migration[6.1]
  def change
    change_column_default :reviews, :rating, from: nil, to: 0
  end
end
