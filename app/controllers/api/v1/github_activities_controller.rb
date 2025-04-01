class Api::V1::GithubActivitiesController < ApplicationController
  def index
    activities = current_user.github_activities.order(activity_date: :desc)
    render json: activities, status: :ok
  end

  def fetch
    result = FetchGithubActivities.new(current_user).execute

    if result[:success]
      render json: result[:activities], status: :ok
    else
      render json: { errors: [ result[:errors] ] }, status: :unprocessable_entity
    end
  end

  def repositories
    activities = current_user.github_activities.where(activity_type: "Repository").order(activity_date: :desc)
    render json: activities, status: :ok
  end

  def commits
    activities = current_user.github_activities.where(activity_type: "Commit").order(activity_date: :desc)
    render json: activities, status: :ok
  end

  def profile
    result = FetchGithubProfile.new(current_user).execute

    if result[:success]
      render json: result[:profile], status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end
end
