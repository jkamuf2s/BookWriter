BookWriter::Application.routes.draw do

  resources :booksearches

  get "conversations/index"

  mount Ckeditor::Engine => '/ckeditor'

  # Startseite der Applikation
  root :to => 'books#index'

  #devise_for :users #default devise route without recaptcha

  # new_user_session GET    /users/sign_in(.:format)                  devise/sessions#new
  # user_session POST   /users/sign_in(.:format)                  devise/sessions#create
  # destroy_user_session DELETE /users/sign_out(.:format)                 devise/sessions#destroy
  # cancel_user_registration GET    /users/cancel(.:format)                   registrations#cancel
  # user_registration POST   /users(.:format)                          registrations#create
  #      new_user_registration GET    /users/sign_up(.:format)                  registrations#new
  # edit_user_registration GET    /users/edit(.:format)                     registrations#edit

  devise_for :users, :controllers => {:registrations => "registrations"} # route to custom controller for recaptcha verification

  resources :books do
    get 'print', :on => :member
    post 'close', :on => :member
    get 'new_edition', :on => :member
    resources :chunks, :except => [:index]
  end

  get 'show_simple_searchform' => 'books#show_simple_searchform' # for javascript
  get 'show_advanced_searchform' => 'books#show_advanced_searchform' # for javascript


  # Routes for Mailboxer
  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
    end
  end
  get 'chunk_version/:book_id/:id' => 'chunks#version', :as => :chunk_version

  # Required, because some forms, which are working with conversations claim it
  get 'conversations/:id' => "conversations#show", :as => :mailboxer_conversation, :constraints => {:id => /\d+/ } # generates  mailboxer_conversation_path
  post '/conversations/:id/reply' => "conversations#reply", :as => :reply_mailboxer_conversation # generates  reply_mailboxer_conversation_path

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
