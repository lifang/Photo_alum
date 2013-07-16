PhotoAlum::Application.routes.draw do
  resources :cities

  resources :messages do
    collection do

      get 'delete'
      get 'send_messaging','read_messages'
      post 'mass_message'
      post 'send_one',"send_many_message"
    end
    member do
    end
  end

  resources :admins do
    collection do
      get 'checkornot','advert','exit_admins','download_apk','setup_user'
      get 'registerornot'
      get 'currect_user','cities_change'
      post 'advert_show'
    end
    member do
    end
  end
  match 'admins/admin_login' => 'admins#admin_login'
  match '/denglu'=>'admins#admin_denglu'
  
  resources :photos do
    collection do
      get 'download','delete',"replace_big_phont",'friends_pwd'
      post 'upload','replace_bigphotos'
    end
  end
  match '/replace_bigphotos' => 'photos#replace_bigphotos'

  resources :users do
    collection do
      get 'forget_pwd','change_pwd','album_pwd',
        'change_describle','change_email','change_city','destroy_user','search','users_citys'
      post 'show'
    end
  end
  match '/register' => 'users#register'
  match '/user_signin' => 'users#user_signin'
  match 'users/show_pwd' => 'users#show_pwd'
  match '/index' => 'users#index'
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
  root :to => 'admins#admin_denglu'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
