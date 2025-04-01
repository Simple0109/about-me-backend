require 'rails_helper'

RSpec.describe "Api::V1::GithubActivities", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_token}" } }

  describe "GET /api/v1/github_activities" do
    let!(:activity1) { create(:github_activity, user: user, activity_date: 1.day.ago) }
    let!(:activity2) { create(:github_activity, user: user, activity_date: 2.days.ago) }

    it "returns all activities ordered by date" do
      get api_v1_github_activities_path, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 2
      expect(json_response.first['id']).to eq activity1.id
      expect(json_response.last['id']).to eq activity2.id
    end
  end

  describe "GET /api/v1/github_activities/repositories" do
    let!(:repo_activity) { create(:github_activity, :repository, user: user) }
    let!(:commit_activity) { create(:github_activity, :commit, user: user) }

    it "returns only repository activities" do
      get repositories_api_v1_github_activities_path, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 1
      expect(json_response.first['activity_type']).to eq 'Repository'
    end
  end

  describe "GET /api/v1/github_activities/commits" do
    let!(:repo_activity) { create(:github_activity, :repository, user: user) }
    let!(:commit_activity) { create(:github_activity, :commit, user: user) }

    it "returns only commit activities" do
      get commits_api_v1_github_activities_path, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 1
      expect(json_response.first['activity_type']).to eq 'Commit'
    end
  end

  describe "GET /api/v1/github_activities/profile" do
    context "when GitHub username is set" do
      before do
        allow_any_instance_of(GithubService).to receive(:fetch_user_profile).and_return({
          "name" => "Test User",
          "bio" => "Test bio",
          "avatar_url" => "http://example.com/avatar.jpg",
          "public_repos" => 10,
          "followers" => 100,
          "following" => 50
        })
      end

      it "returns GitHub profile data" do
        get profile_api_v1_github_activities_path, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response["name"]).to eq "Test User"
        expect(json_response["bio"]).to eq "Test bio"
      end
    end

    context "when GitHub username is not set" do
      let(:user) { create(:user, github_username: nil) }

      it "returns error" do
        get profile_api_v1_github_activities_path, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include("GitHub username not set")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
