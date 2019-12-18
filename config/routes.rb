Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'order#home'
  post '/recieve-order' => 'order#recieve'

end
