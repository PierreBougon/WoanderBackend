require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:coordinates) }
  it { should validate_presence_of(:media_type) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:content) }
end