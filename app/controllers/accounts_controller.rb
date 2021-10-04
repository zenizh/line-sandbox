class AccountsController < ApplicationController
  def show
    response = Faraday.get('https://api.line.me/v2/profile') do |request|
      request.headers['Authorization'] = "Bearer #{session['access_token']}"
    end

    body = JSON.parse(response.body)

    @user_id = body['userId']
    @display_name = body['displayName']
    @picture_url = body['pictureUrl']

    session['user_id'] = @user_id
  end
end
