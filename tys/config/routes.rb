Rails.application.routes.draw do
  get "applications/:id/details" => "appdetails#load_details"
  get "stacktraces/:id/details" => "stacktraces#show_details"
end
