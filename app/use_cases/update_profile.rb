class UpdateProfile
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def execute
    profile = user.profile

    if profile.nil?
      return { success: false, errors: ["Profile not found"] }
    end

    if profile.update(params)
      { success: true, profile: profile }
    else
      { success: false, errors: profile.errors.full_messages }
    end
  end
end
