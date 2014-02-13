class User < ActiveRecord::Base

	attr_accessor :signin

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

	has_many :posts

	validates :username, :uniqueness => {
		:case_sensitive => false
	}

	def self.find_first_by_auth_conditions(warden_conditions)
		conditions = warden_conditions.dup
		if signin = conditions.delete(:signin)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.downcase }]).first
    else
      where(conditions).first
    end
	end

	def self.find_for_facebook_oauth(provider, uid, name, email, signed_in_resource=nil)
		where(:provider => provider, :uid => uid).first_or_create do |user|
			user.provider = provider
			user.uid = uid
			user.email = email
			user.password = Devise.friendly_token[0,20]
		end
	end

	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
