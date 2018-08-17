class SearchController < ApplicationController
  skip_authorization_check

  def index
    @objects = Search.new(params[:text], params[:model]).response
  end
end