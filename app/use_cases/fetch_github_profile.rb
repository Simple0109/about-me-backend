class FetchGithubProfile
  attr_reader :user, :github_service

  def initialize(user)
    @user = user
    @github_service = GithubService.new(user.github_username)
  end

  def execute
    return { success: false, errors: ["GitHub username not set"] } unless user.github_username.present?

    profile_data = github_service.fetch_user_profile

    if profile_data
      {
        success: true,
        profile: {
          name: profile_data["name"],
          bio: profile_data["bio"],
          avatar_url: profile_data["avatar_url"],
          public_repos: profile_data["public_repos"],
          followers: profile_data["followers"],
          following: profile_data["following"]
        }
      }
    else
      { success: false, errors: ["Failed to fetch GitHub profile"] }
    end
  end
end
