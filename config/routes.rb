# Rails.application.routes.draw do
#   post "auth/signup", to: "auth#signup"
#   post "auth/login", to: "auth#login"
#   # optional: refresh / signout endpoints can be added later

#   resources :tasks

# end
Rails.application.routes.draw do
  post "auth/signup", to: "auth#signup"
  post "auth/login", to: "auth#login"

  resources :tasks
end
