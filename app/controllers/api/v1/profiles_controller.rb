class Api::V1::ProfilesController < ApplicationController
  def show
    profile = current_user.profile

    if profile
      render json: profile, status: :ok
    else
      render json: { error: "Profile not found" }, status: :not_found
    end
  end

  def create
    result = CreateProfile.new(current_user, profile_params).execute

    if result[:success]
      render json: result[:profile], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def update
    result = UpdateProfile.new(current_user, profile_params).execute

    if result[:success]
      render json: result[:profile], status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :bio, :avatar_url, :location, :website)
  end
end
