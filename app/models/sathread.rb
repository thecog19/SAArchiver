class Sathread < ApplicationRecord
  belongs_to :user, :foreign_key => :op_id,  optional: true 
  has_many :posts, :primary_key => :thread_id, :foreign_key => :thread_id
end
