class Post < ApplicationRecord
  include PgSearch 
  belongs_to :sathread, :primary_key => :thread_id, :foreign_key => :thread_id, class_name: "Sathread", optional: true
  belongs_to :user


  pg_search_scope :exact_search_for, against: %i(body), :using => {tsearch: {tsvector_column: "tsv"}}
  pg_search_scope :fuzzy_search_for, against: %i(body), :using => { :tsearch => {:prefix => true, :dictionary => "english", tsvector_column: "tsv" }}

end
