class ApplicationController < ActionController::Base
  protect_from_forgery

  def getToken(code)
  	    app_id = "Kep4uX9xGEu67Tg57rixxzu8oexKu5ko"
        app_secret = "1a96bd6b6fc11a84a1f7dff8b01c2604077119a4a7d839e8e132bbdd6501b7d7"
        response = Net::HTTP.post_form(URI.parse('http://developer.globelabs.com.ph/oauth/access_token'),
        {'app_id'=>app_id, 'app_secret'=> app_secret, 'code' => code})
        access_token = JSON.parse(response.body)['access_token']
        msisdn = JSON.parse(response.body)['subscriber_number']
        logger.info response.code
        logger.info response.message
        logger.info response.body
        session[:access_token] = access_token
        session[:msisdn] = msisdn
  end

end
