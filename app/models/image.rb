class Image < ApplicationRecord
  has_one_attached :file
  validates :name, presence: true

  def set_url
    update(url: rails_blob_path(file, only_path: true)) if file.attached?
  end
end