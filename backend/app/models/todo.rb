class Todo < ApplicationRecord
	attribute :completed, :boolean, default: false

	validates :title, presence: true, length: { maximum: 120 }
end
