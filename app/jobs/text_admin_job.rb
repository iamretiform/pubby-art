class TextAdminJob < ApplicationJob
  queue_as :default

  def perform(location)
    TextMessager.new(
      recipient: Rails.application.secrets.admin_phone,
      message: "The location '#{location.title}' was just added. Go vet it!"
    ).send
  end
end