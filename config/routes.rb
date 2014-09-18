GlQa::Application.routes.draw do
  
  root :to => 'home#index'

  #Callbacks
  match 'redirect' => 'home#redirect'
  match 'notify' => 'home#notify'

  #API Routes
  match 'sms' => 'home#sms'
  match 'charge' => 'home#charge'
  match 'lbs' => 'home#lbs'
  match 'raven' => 'home#raven'

  #result
  match 'result' => 'home#result'
end
