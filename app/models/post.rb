class Post < ApplicationRecord
  belongs_to :sathread, :primary_key => :thread_id, :foreign_key => :thread_id, class_name: "Sathread", optional: true
  belongs_to :user
end
