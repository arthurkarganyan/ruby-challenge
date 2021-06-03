class ShowTime < ApplicationRecord
  belongs_to :film

  scope :future, -> {
    where('start_time > ?', DateTime.now)
  }

  def self.build(film:, price:, start_time:)
    if start_time.class == String
      start_time = DateTime.parse start_time
    end
    end_time = start_time + film.show_time_duration
    self.new(start_time: start_time, end_time: end_time, price: price, film: film)
  end

  def self.build_and_save!(**opts)
    s = build(**opts)
    s.save!
    s
  end
end
