class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.create_with_omniauth(auth)
    puts text: auth.inspect

    User.create(email: auth["info"]["email"],
                password: auth["info"]["email"],
                provider: auth["provider"],
                uid: auth["uid"],
                name: auth["info"]["name"]
    )
  end
end
