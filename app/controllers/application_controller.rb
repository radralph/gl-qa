class ApplicationController < ActionController::Base
  protect_from_forgery

  def getToken(code)
  	    app_id = "56njHrXa8RfA7izgbXca6EfaE6orHyL8"
        app_secret = "cd58ad122c001bb8f92523ba6998e0338c6b8ba7446b22e4122e150de866d612"
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
