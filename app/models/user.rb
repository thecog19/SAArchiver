class User < ApplicationRecord
  include PgSearch 
  has_many :sathreads, :foreign_key => :op_id
  has_many :posts

  pg_search_scope :prefix_search_for, against: :name,
                  :using => {
                    :tsearch => {:prefix => true}
                  }

  pg_search_scope :exact_search_for, against: :name
                  
end
