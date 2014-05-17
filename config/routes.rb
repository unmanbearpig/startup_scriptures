Rails.application.routes.draw do
  root 'categories#index'

  get 'search' => 'links#search', as: :links_search

  devise_for :users

  post 'categories/reorder' => 'categories#reorder', as: :reorder_categories
  resources :categories do
    resources :subcategories, shallow: true do
      resources :links do
        member do
          post 'upvote'
          post 'downvote'
          post 'unvote'
        end
      end
    end
  end

  get 'reading_list' => 'saved_links#index', as: :reading_list
  post 'saved_link/:link_id' => 'saved_links#create', as: :save_link
  delete 'saved_link/:link_id' => 'saved_links#delete', as: :delete_saved_link

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
