class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # Adding the User model followed_users association
  # Explicitly tell Rails that the source of the followed_users is the set of followed ids
  has_many :followed_users, through: :relationships, source: :followed

  # Implementing user.followers using reverse relationships.
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:"Relationship",
                                   dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower


  has_secure_password
  attr_accessible :email, :name, :password,:password_confirmation,:admin
  before_save{email.downcase!}
  before_create :create_remember_token
  validates :name , presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-_]+(\.[a-z]+)*\.[a-z]{1,3}\z/i
  validates :email,  presence:true, format: {with: VALID_EMAIL_REGEX}, 
  					uniqueness:{case_sensitive: false}

  validates :password, length: {minimum: 6}

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  	#The call to_s is to make sure we can handle nil tokens
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    #Micropost.where("user_id= ?", id)
    Micropost.from_users_followed_by(self)
  end
  
  #USER RELATIONSHIPS
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
      relationships.find_by_followed_id(other_user.id).destroy
  end


  private 
	  def create_remember_token
	  	self.remember_token = User.encrypt(User.new_remember_token)
	  end
end
