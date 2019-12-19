module UsersBackofficeHelper

  def avatar_url
    current_user.user_profile.avatar.attached? ? current_user.user_profile.avatar : '/assets/img.jpg'
  end
end
