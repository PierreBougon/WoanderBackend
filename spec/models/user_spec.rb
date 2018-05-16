require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should have_many(:posts) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:password) }
  it { have_secure_password }
end