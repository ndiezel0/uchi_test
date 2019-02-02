Rails.application.routes.draw do
  root 'default#index'
  get 'search', to: 'default#show', as: :search
  get 'pdf', to: 'default#pdf', as: :pdf
  get 'pdf_zip', to: 'default#pdf_zip', as: :pdf_zip
end
