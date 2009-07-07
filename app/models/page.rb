# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  permalink   :string(255)
#  description :text
#  state       :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Page < ActiveRecord::Base
  
  @@per_page = 10
  cattr_reader :per_page
  
  has_permalink :title, :permalink
  
  named_scope :active, :conditions => { :state => true }
  named_scope :inactive, :conditions => { :state => false }
  
  validates_presence_of :title, :permalink, :description
  validates_uniqueness_of :title, :permalink
    
  def self.search(query, options)
    conditions = ["title like ? or description like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, title"}
    
    paginate default_options.merge(options)
  end

end
