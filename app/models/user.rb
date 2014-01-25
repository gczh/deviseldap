class User < ActiveRecord::Base

	attr_accessor :signin

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

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

end
