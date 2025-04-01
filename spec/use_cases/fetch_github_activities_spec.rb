require 'rails_helper'

RSpec.describe FetchGithubActivities do
  let(:user) { create(:user, github_username: 'testuser') }
  let(:github_service) { instance_double(GithubService) }
  let(:github_repository) { instance_double(GithubRepository) }
  let(:repositories_data) do
    [
      { "id" => 1, "name" => "repo1", "stargazers_count" => 10, "html_url" => "http://github.com/repo1", "description" => "Test repo", "created_at" => Time.current.to_s },
      { "id" => 2, "name" => "repo2", "stargazers_count" => 5, "html_url" => "http://github.com/repo2", "description" => "Test repo 2", "created_at" => Time.current.to_s }
    ]
  end
  let(:commits_data) do
    [
      { "sha" => "abc123", "repository" => { "full_name" => "testuser/repo1" }, "created_at" => Time.current.to_s }
    ]
  end

  before do
    allow(GithubService).to receive(:new).and_return(github_service)
    allow(GithubRepository).to receive(:new).and_return(github_repository)
  end

  describe '#execute' do
    context 'when GitHub username is present' do
      before do
        allow(github_service).to receive(:fetch_repositories).and_return(repositories_data)
        allow(github_service).to receive(:fetch_commits).and_return(commits_data)
        allow(github_repository).to receive(:store_repositories)
        allow(github_repository).to receive(:store_activities)
        allow(github_repository).to receive(:find_all_activities).and_return([])
      end

      it 'returns success with activities' do
        result = described_class.new(user).execute

        expect(result[:success]).to be true
        expect(result[:activities]).to eq([])
      end

      it 'fetches repositories from GitHub' do
        described_class.new(user).execute
        expect(github_service).to have_received(:fetch_repositories)
      end

      it 'stores repositories data' do
        described_class.new(user).execute
        expect(github_repository).to have_received(:store_repositories).with(repositories_data)
      end
    end

    context 'when GitHub username is blank' do
      let(:user) { create(:user, github_username: nil) }

      it 'returns error' do
        result = described_class.new(user).execute

        expect(result[:success]).to be false
        expect(result[:errors]).to include("GitHub username not set")
      end
    end

    context 'when GitHub API fails' do
      before do
        allow(github_service).to receive(:fetch_repositories).and_return(nil)
      end

      it 'returns error' do
        result = described_class.new(user).execute

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Failed to fetch GitHub data")
      end
    end
  end
end
