class HomeController < ApplicationController
  Pusher.url = "http://5202b0c7334e2375c8ab:d3095b832476748486f8@api.pusherapp.com/apps/76332"
  Pusher.app_id = '76332'
  Pusher.key = '5202b0c7334e2375c8ab'
  Pusher.secret = 'd3095b832476748486f8'




	def index

	end

	def redirect
    getToken(params[:code]) if params[:code]
		logger.info "yep"
		logger.info session[:access_token]
		logger.info session[:msisdn]
		redirect_to :root 
 	end

	def notify
	    msisdn = params['inboundSMSMessageList']['inboundSMSMessage'].first['senderAddress']
      msisdn = msisdn[7..msisdn.length]
      msg = params['inboundSMSMessageList']['inboundSMSMessage'].first['message']
      hello = msg
      hello2 = msisdn
      Pusher['test_channel'].trigger('my_event', {
        message: hello,
        message2: hello2
      })
      logger.info "=============="
      logger.info msg
      logger.info msisdn
      logger.info params.to_json
	end


	def sms
	  uri = URI.parse("http://devapi.globelabs.com.ph/smsmessaging/v1/outbound/7636/requests")
    uri.query = "access_token=#{session[:access_token]}"
    response = Net::HTTP.post_form(uri, {"address" => session[:msisdn], "message" => params[:message]})
    logger.info "============"
    logger.info session[:msisdn]
    logger.info session[:access_token]
    logger.info params[:message]
    session[:response] = response
    redirect_to result_path
	end

  def charge
      json = JSON.parse(content)
      increment = json['result'].first['reference_code'].to_i+1
        uri = URI.parse("http://devapi.globelabs.com.ph/payment/v1/transactions/amount/")
        uri.query = "access_token="+session[:access_token]
        response = Net::HTTP.post_form(uri, {'description' => 'desc',
        'endUserId' => session[:msisdn], 'amount' => params[:amount], 'referenceCode' => increment,
          'transactionOperationStatus' => 'charged'}) 
      session[:response] = response
      redirect_to result_path
  end

  def lbs
    res = HTTParty.get("http://devapi.globelabs.com.ph/location/v1/queries/location?access_token=#{session[:access_token]}&address=#{session[:msisdn]}&requestedAccuracy=100")
    logger.info res.body
    logger.info res.code
    json = JSON.parse(res.body)
    lat = json['terminalLocationList']['terminalLocation']['currentLocation']['latitude']
    long = json['terminalLocationList']['terminalLocation']['currentLocation']['longitude']
    redirect_to "http://maps.google.com/?q=#{lat},#{long}"
  end

  def raven
    logger.info params[:raven]
    res = HTTParty.get("http://devapi.globelabs.com.ph/location/v1/queries/#{params[:raven]}?access_token=#{session[:access_token]}&address=#{session[:msisdn]}")
    res['yes'] if res 
    render :json => res
  end

  ##CHANGE TO HTTPS
  # uri = "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/3822/requests?" + QString
  # response = HTTParty.post(uri,
  #   :body => {:address => address, :message => message, :passphrase => passphrase})


end
