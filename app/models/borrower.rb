class Borrower < ActiveRecord::Base
	has_secure_password
	has_many :histories

	email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

	validates :first_name, :last_name, presence: :true, length: { within: 2..25 }
	validates :email, presence: true, format: { with: email_regex }, uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, unless: :skip_password_validation
	validates :money, presence: true, numericality: { greater_than_or_equal_to: 1 }
	validates :purpose, presence: true, length: { minimum: 10 }
	validates :description, presence: true, length: { minimum: 15 }
	attr_accessor :skip_password_validation
	before_save :email_lowercase
	before_save :default_values
  	def default_values
    self.raised ||= 0 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  	end
	def email_lowercase
    email.downcase!
  	end
  	def has_password?(submitted_password)
   		self.password == submitted_password
  	end
  	def self.authenticate(email, submitted_password)
	    user = find_by_email(email)
	    return nil if user.nil?
	    return user if user.has_password?(submitted_password)
  	end
end
