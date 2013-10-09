class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.create_with_omniauth(auth)
    auth.email = auth["info"]["email"]
    auth.password = auth.email
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      puts text: auth.inspect
      user.name = auth["info"]["name"]

    end
  end
end
