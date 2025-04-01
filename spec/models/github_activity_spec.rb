require 'rails_helper'

RSpec.describe GithubActivity, type: :model do
  let(:user) { create(:user) }
  let(:valid_attributes) {
    {
      user: user,
      github_id: "12345",
      activity_type: "Repository",
      repository_name: "test-repo",
      repository_url: "https://github.com/test/test-repo",
      description: "Test repository",
      url: "https://github.com/test/test-repo",
      activity_date: Time.current
    }
  }

  it "is valid with valid attributes" do
    activity = GithubActivity.new(valid_attributes)
    expect(activity).to be_valid
  end

  it "is not valid without a user" do
    activity = GithubActivity.new(valid_attributes.except(:user))
    expect(activity).not_to be_valid
  end

  it "is not valid without a github_id" do
    activity = GithubActivity.new(valid_attributes.except(:github_id))
    expect(activity).not_to be_valid
  end

  it "is not valid without an activity_type" do
    activity = GithubActivity.new(valid_attributes.except(:activity_type))
    expect(activity).not_to be_valid
  end

  it "has unique github_id per user" do
    GithubActivity.create!(valid_attributes)
    duplicate = GithubActivity.new(valid_attributes)
    expect(duplicate).not_to be_valid
  end
end
