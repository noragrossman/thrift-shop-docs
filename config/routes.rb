Rails.application.routes.draw do
  get 'docs/index'

  root 'docs#index'
end
