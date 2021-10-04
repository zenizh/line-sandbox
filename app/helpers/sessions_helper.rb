module SessionsHelper
  def authorize_url
    query = {
      response_type: 'code',
      client_id: ENV.fetch('LINE_LOGIN_CLIENT_ID'),
      redirect_uri: ENV.fetch('LINE_LOGIN_REDIRECT_URI'),
      state: SecureRandom.hex,
      scope: 'profile openid'
    }.to_param

    uri = URI('https://access.line.me/oauth2/v2.1/authorize')
    uri.query = query
    uri.to_s
  end
end
