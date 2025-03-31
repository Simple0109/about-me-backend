class CreateProfile
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def execute
    profile = user.build_profile(params)

    if profile.save
      { success: true, profile: profile }
    else
      { success: false, errors: profile.errors.full_messages }
    end
  end
end
