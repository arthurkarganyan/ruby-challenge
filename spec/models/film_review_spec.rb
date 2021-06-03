require 'rails_helper'

RSpec.describe FilmReview, type: :model do
  describe 'validations' do
    it '#stars' do
      review = FilmReview.new
      review.validate
      expect(review.errors[:stars]).to include("can't be blank")
      review.stars = -1
      review.validate
      expect(review.errors[:stars]).to include("stars can only be 1, 2, 3, 4 or 5")
      review.stars = 5
      review.validate
      expect(review.errors[:stars].blank?).to be_truthy
    end
  end
end
