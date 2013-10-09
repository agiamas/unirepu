Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,'tSLKT4vfQm3aXHghTnPJsg', 'PefOD44TIrOCvtrradQbeHPNzjmDu4aQIvKx2MZMsQY'
  #           config.omniauth :facebook, '111000468948168', 'bdb3717129f2f1c6fc1d2d621ecbbdb4', scope: 'email,user_birthday,read_stream'

#provider :facebook, 'APP_ID', 'APP_SECRET'
  #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end