class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter]

  def self.create_with_omniauth(auth)
    provider = auth["provider"]
    uid = auth["uid"]

    if provider === 'facebook'
      email = auth["info"]["email"]
      name = auth["info"]["name"]
    else
      name = "John Doe" #TODO: replace it with the twitter name
      email = "Johndoe@example.org" #NOTICE: Twitter API does not return email
    end
    password = Devise.friendly_token[0,20]

    User.create!(email: email,
                password: password,
                provider: provider,
                uid: uid,
                name: name
    )
  end

  def self.new_with_session(params, session)
    super.tap do |user|

      if data = session["devise.provider_data"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
