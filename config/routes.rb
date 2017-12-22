Rails.application.routes.draw do
  get 'docs/index'
  get 'docs/show'

  root 'docs#index'
end
