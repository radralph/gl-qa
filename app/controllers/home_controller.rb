class HomeController < ApplicationController
  Pusher.url = "http://5202b0c7334e2375c8ab:d3095b832476748486f8@api.pusherapp.com/apps/76332"
  Pusher.app_id = '76332'
  Pusher.key = '5202b0c7334e2375c8ab'
  Pusher.secret = 'd3095b832476748486f8'




	def index
    logger.info params
	end

	def redirect
    getToken(params[:code]) if params[:code]
		logger.info " "
    logger.info params
    logger.info "=========="
    logger.info "%s %s" % ["access_token: ", session[:access_token]]
		logger.info "%s %s" % ["msisdn: ", session[:msisdn]]
		logger.info "=========="
    redirect_to :root 
 	end

	def notify
      logger.info "=============="
 
      logger.info params.to_json
 
      logger.info "=============="
	    msisdn = params['inboundSMSMessageList']['inboundSMSMessage'].first['senderAddress']
      msisdn = msisdn[7..msisdn.length]
      msg = params['inboundSMSMessageList']['inboundSMSMessage'].first['message']
      hello = msg
      hello2 = msisdn
      Pusher['test_channel'].trigger('my_event', {
        message: hello,
        message2: hello2
      })
      logger.info "MESSAGE: " + msg
      logger.info "MSISDN: " + msisdn
      logger.info "=============="
	end


	def sms
    token = session[:access_token]
    uri = "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/7635/requests?access_token=#{token}"
    response = HTTParty.post(uri,:body => {:address => session[:msisdn], :message => params[:message]})
    logger.info response.code
    logger.info response.message
    logger.info response.body

	  # # uri = URI.parse("https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/7636/requests")
   # #  uri.query = "access_token=#{session[:access_token]}"
   # #  response = Net::HTTP.post_form(uri, {"address" => session[:msisdn], "message" => params[:message]})
   #  logger.info "============"
   #  logger.info session[:msisdn]
   #  logger.info session[:access_token]
   #  logger.info params[:message]
   @response = response
   render "home/result"
   #redirect_to result_path
	end

  def charge
      content = open('https://devapi.globelabs.com.ph/payments/1183').read
      json = JSON.parse(content)
      increment = json['result'].first['reference_code'].to_i+1
        uri = URI.parse("https://devapi.globelabs.com.ph/payment/v1/transactions/amount?access_token=#{session[:access_token]}")
       # uri.query = "access_token="+session[:access_token]

        response = HTTParty.post(uri,:body => {'description' => 'desc',
        'endUserId' => session[:msisdn], 'amount' => params[:amount], 'referenceCode' => increment,
          'transactionOperationStatus' => 'charged'})
      session[:response] = response
      logger.info response.code
      logger.info response.message
      logger.info response.body
      logger.info increment
      redirect_to result_path
  end

  def lbs
    res = HTTParty.get("https://devapi.globelabs.com.ph/location/v1/queries/location?access_token=#{session[:access_token]}&address=#{session[:msisdn]}&requestedAccuracy=100")
    logger.info res.body
    logger.info res.code
    json = JSON.parse(res.body)
    lat = json['terminalLocationList']['terminalLocation']['currentLocation']['latitude']
    long = json['terminalLocationList']['terminalLocation']['currentLocation']['longitude']
    redirect_to "http://maps.google.com/?q=#{lat},#{long}"
  end

  def raven
    logger.info params[:raven]
    res = HTTParty.get("https://devapi.globelabs.com.ph/location/v1/queries/#{params[:raven]}?access_token=#{session[:access_token]}&address=#{session[:msisdn]}")
    res['yes'] if res 
    render :json => res
  end

end
