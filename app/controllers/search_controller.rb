class SearchController < ApplicationController
  skip_authorization_check

  def index
    if params[:text].present?
      model = params[:model] == 'all' ? ThinkingSphinx : params[:model].classify.safe_constantize
      @objects = model.search(Riddle.escape(params[:text]))
    else
      redirect_back(fallback_location: root_path)
    end
  end
end