require 'sidekiq/web'

Rails.application.routes.draw do
  root 'categories#index'

  get 'search' => 'links#search', as: :links_search

  devise_for :users


  admin_constraint = ->(request) { request.env['warden'].authenticate? && request.env['warden'].user.is_admin }
  constraints admin_constraint do
    mount Sidekiq::Web, at: '/sidekiq', as: :background_tasks_dashboard
  end
  get 'links/recent' => 'links#recent', as: :recent_links
  get 'links/no_titles' => 'links#links_without_titles', as: :links_without_titles
  post 'links/fetch_missing_titles' => 'links#fetch_missing_titles', as: :fetch_missing_titles

  get 'reading_list' => 'saved_links#index', as: :reading_list
  post 'saved_link/:link_id' => 'saved_links#create', as: :save_link
  delete 'saved_link/:link_id' => 'saved_links#delete', as: :delete_saved_link

  get 'import_links' => 'link_import#new', as: :import_links_form
  post 'import_links' => 'link_import#import', as: :import_links

  post 'categories/reorder' => 'categories#reorder', as: :reorder_categories
  resources :categories do
    post 'reorder_subcategories'
    resources :subcategories, shallow: true do
      post 'reorder_links'
      resources :links do
        member do
          post 'upvote'
          post 'downvote'
          post 'unvote'
        end
      end
    end
  end



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
