class Image < ApplicationRecord
  has_one_attached :file
  validates :name, presence: true
  validates :file, presence: true

  after_create :set_url

  def set_url
    update(url: custom_url) if file.attached?
  end

  private

  def custom_url
    "https://static.superforum.io/#{file.key}"
  end
end
