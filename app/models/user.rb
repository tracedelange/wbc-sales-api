class User < ApplicationRecord
    has_secure_password

    validates :username, presence: true
    validates :username, length: {minimum: 2, maximum: 15}
    validates :username, uniqueness: { case_sensitive: false, message: "Username already taken."}


end
