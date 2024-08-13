module ApplicationHelper
  def registrations_enabled?
    Rails.application.credentials.allow_registrations
  end
end
