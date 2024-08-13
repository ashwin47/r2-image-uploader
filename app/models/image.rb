class Image < ApplicationRecord
  has_one_attached :file
  validates :name, presence: true
  validates :file, presence: true, on: :create

  after_create :set_url, unless: -> { Rails.env.test? }

  def set_url
    update(url: custom_url) if file.attached?
  end

  private

  def custom_url
    "https://static.superforum.io/#{file.key}"
  end
end
