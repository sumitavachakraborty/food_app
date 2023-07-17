Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '259664635785-n7dp4h1bjl2t9to2jvuerb98bh77snvn.apps.googleusercontent.com',
           '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'
end
