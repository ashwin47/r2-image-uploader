class Image < ApplicationRecord
  has_one_attached :file
  validates :name, presence: true
  validates :file, presence: true

  def set_url
    if file.attached?
      update(url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true))
    end
  rescue => e
    Rails.logger.error "Failed to set URL for Image #{id}: #{e.message}"
    update(url: nil)
  end
end