class GithubRepository
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def store_activities(activities_data)
    return [] unless activities_data&.any?

    activities = []

    activities_data.each do |activity_data|
      resource_id = activity_data["sha"] || activity_data["id"]
      next unless resource_id.present?

      activity = GithubActivity.find_or_initialize_by(
        user: user,
        github_id: resource_id.to_s
      )

      if activity_data["sha"] # コミットデータの場合
        update_push_event(activity, activity_data)
      elsif activity_data["type"] == "CreateEvent"
        update_create_event(activity, activity_data)
      elsif activity_data["type"] == "PullRequestEvent"
        update_pull_request_event(activity, activity_data)
      end

      activities << activity if activity.save
    end

    activities
  end

  def store_repositories(repositories_data)
    return [] unless repositories_data&.any?

    activities = []

    repositories_data.each do |repo_data|
      activity = GithubActivity.find_or_initialize_by(
        user: user,
        github_id: repo_data["id"].to_s
      )

      activity.assign_attributes(
        activity_type: "Repository",
        repository_name: repo_data["name"],
        repository_url: repo_data["html_url"],
        description: repo_data["description"],
        url: repo_data["html_url"],
        activity_date: repo_data["created_at"]
      )

      activities << activity if activity.save
    end

    activities
  end

  def find_all_activities
    user.github_activities.order(activity_date: :desc)
  end

  def find_activities_by_type(type)
    user.github_activities.where(activity_type: type).order(activity_date: :desc)
  end

  private

  def update_push_event(activity, activity_data)
    repo_name = activity_data["repository"]&.dig("full_name") ||
                activity_data.dig("repo", "name") ||
                "unknown"

    activity.assign_attributes(
      activity_type: "Commit",
      repository_name: repo_name.split("/").last,
      repository_url: "https://github.com/#{repo_name}",
      description: "Pushed #{activity_data.dig("payload", "size") || 'some'} commits",
      url: "https://github.com/#{repo_name}/commits",
      activity_date: activity_data["created_at"] || Time.current
    )
  end

  def update_create_event(activity, activity_data)
    activity.assign_attributes(
      activity_type: "Repository",
      repository_name: activity_data.dig("repo", "name")&.split("/")&.last,
      repository_url: "https://github.com/#{activity_data.dig("repo", "name")}",
      description: "Created #{activity_data.dig("payload", "ref_type")}",
      url: "https://github.com/#{activity_data.dig("repo", "name")}",
      activity_date: activity_data["created_at"]
    )
  end

  def update_pull_request_event(activity, activity_data)
    activity.assign_attributes(
      activity_type: "PullRequest",
      repository_name: activity_data.dig("repo", "name")&.split("/")&.last,
      repository_url: "https://github.com/#{activity_data.dig("repo", "name")}",
      description: "#{activity_data.dig("payload", "action")} pull request: #{activity_data.dig("payload", "pull_request", "title")}",
      url: activity_data.dig("payload", "pull_request", "html_url"),
      activity_date: activity_data["created_at"]
    )
  end
end
