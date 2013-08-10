class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order('created_at DESC')} #sort data sql follow DESC
  #default_scope order: 'microposts.created_at DESC'
  attr_accessible :content, :user_id
  validates :user_id, presence: true
  validates :content, presence: true, length:{ maximum: 140}

  # Return microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
  		followed_users_ids = "SELECT followed_id FROM relationships 
  								WHERE  follower_id = :user_id "
  		where("user_id IN (#{followed_users_ids}) OR user_id = :user_id ", user_id: user.id)
  end
end
