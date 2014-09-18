class HomeController < ApplicationController

  Pusher.url = "http://5202b0c7334e2375c8ab:d3095b832476748486f8@api.pusherapp.com/apps/76332"
  Pusher.app_id = '76332'
  Pusher.key = '5202b0c7334e2375c8ab'
  Pusher.secret = 'd3095b832476748486f8'




	def index

	end

	def redirect
		logger.info params
		logger.info params
		getToken(params[:code]) if params[:code]
		logger.info "watwatwatwatwatwatwtawtawtawt"
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
	end


	def sms
	uri = URI.parse("http://devapi.globelabs.com.ph/smsmessaging/v1/outbound/9996/requests")
    uri.query = "access_token=#{session[:access_token]}"
    response = Net::HTTP.post_form(uri, {"address" => session[:msisdn], "message" => params[:message]})
    logger.info "============"
    logger.info session[:msisdn]
    logger.info session[:access_token]
    logger.info params[:message]
    session[:response] = response
    redirect_to result_path
	end


end
