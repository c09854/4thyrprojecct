class User < ActiveRecord::Base
    attr_accessible :balance, :dob, :email, :first_name, :last_name, :username, :password, :confirm_password
    
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :username, :presence => true, :uniqueness => true
    validates :first_name, :presence => true, length: { minimum: 2 }
    validates :last_name, :presence => true, length: { minimum: 2 }
    validates_date :dob, :presence => true, :on_or_before => lambda {Date.today.years_ago(18)},
    :on_or_before_message => "must be at least 18 years old to join this site"
    validates :password, :presence => true, length: { minimum: 6 }
    validate :passwords_equal
    validates :email, :presence => true, :uniqueness => true ,
                      :format   => { :with => email_regex }
                    
    def passwords_equal
        erros.add(:password, "password and confirm password must be equal") unless password == confirm_password
    end
    
    
    def has_password?(submitted_password)
        password == submitted_password
    end
    
    def self.authenticate(email, submitted_password)  
	user = find_by_email(email)		
	return nil  if user.nil?
		
	return user if user.has_password?(submitted_password)
	return nil
    end
end
