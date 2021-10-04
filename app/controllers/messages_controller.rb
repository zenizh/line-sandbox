class MessagesController < ApplicationController
  def create
    Faraday.post('https://api.line.me/v2/bot/message/push') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Bearer #{ENV.fetch('LINE_MESSAGING_API_CHANNEL_ACCESS_TOKEN')}"
      request.body = {
        to: session['user_id'],
        messages: [
          {
            type: 'text',
            text: message_params['content']
          }
        ]
      }.to_json
    end

    redirect_to account_path
  end

  private

  def message_params
    params.permit(:content)
  end
end
