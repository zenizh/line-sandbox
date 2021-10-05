class SessionsController < ApplicationController
  def new
  end

  def create
    response = Faraday.post('https://api.line.me/oauth2/v2.1/token') do |request|
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      request.body = {
        grant_type: 'authorization_code',
        code: params['code'],
        redirect_uri: ENV.fetch('LINE_LOGIN_REDIRECT_URI'),
        client_id: ENV.fetch('LINE_LOGIN_CLIENT_ID'),
        client_secret: ENV.fetch('LINE_LOGIN_CLIENT_SECRET'),
        code_verifier: ENV.fetch('LINE_LOGIN_CODE_VERIFIER')
      }.to_param
    end

    body = JSON.parse(response.body)
    session['access_token'] = body['access_token']

    redirect_to account_path
  end
end
