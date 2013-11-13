class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	#The order here is ’created_at DESC’, where DESC is SQL for “descending”, i.e., in descending 
	#order from newest to oldest.
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

  #class method
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
