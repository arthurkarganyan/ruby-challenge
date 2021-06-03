class FilmReview < ApplicationRecord
  belongs_to :user
  belongs_to :film

  validates :stars, presence: true, inclusion: {in: [1, 2, 3, 4, 5], message: "stars can only be 1, 2, 3, 4 or 5"}
end
