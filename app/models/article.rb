class Article < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :slug, presence: true, uniqueness: true

    scope :recent, -> { order(created_at: :desc) } # Store articles in a descending time order ex.(Date.now. 1.hour.ago, etc)
end
