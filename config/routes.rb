AssetsContainer::Application.routes.draw do
  root to: "test_pages#index"
  get "/test_pages" => "test_pages#index", as: "test_pages"
  get "/test_pages/:name" => "test_pages#index", as: "test_pages"
end
