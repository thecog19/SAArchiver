class User < ApplicationRecord
  has_many :sathreads, :foreign_key => :op_id
  has_many :posts
end
