class FetchGithubActivities
  attr_reader :user, :github_service, :github_repository

  def initialize(user)
    @user = user
    @github_service = GithubService.new(user.github_username)
    @github_repository = GithubRepository.new(user)
  end

  def execute
    return { success: false, errors: ["GitHub username not set"] } unless user.github_username.present?

    repositories_data = github_service.fetch_repositories

    if repositories_data
      github_repository.store_repositories(repositories_data)

      top_repos = repositories_data.sort_by { |repo| repo["stargazers_count"] }.reverse.take(3)
      top_repos.each do |repo|
        commits_data = github_service.fetch_commits(repo["name"])
        github_repository.store_activities(commits_data) if commits_data
      end

      { success: true, activities: github_repository.find_all_activities}
    else
      { success: false, errors: ["Failed to fetch GitHub data"] }
    end
  end
end
