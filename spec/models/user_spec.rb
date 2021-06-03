require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) {User.create(email: user1_email, password: user1_password, role: :cinema_owner)}
  let(:user1_email) {FFaker::Internet.email}
  let(:user1_password) {FFaker::Internet.password}

  it "#cinema_owner?" do
    expect(user1.cinema_owner?).to be_truthy
  end
end
