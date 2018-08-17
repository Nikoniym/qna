require_relative 'response'

class Search
  attr_reader :objects
  ATTR = %w(all user question answer comment)

  def initialize(text, model)
    @objects = {}

    check_model(model)

    text.present? ? @objects = @model.search(Riddle.escape(text), page: 1, per_page: 50) :  @objects = {}
  end

  def response
    @response = []
    @objects.each do |object|
      @response << Response.new(object)
    end
    @response
  end

  private

  def check_model(model)
    if model == 'all' || !ATTR.include?(model)
      @model = ThinkingSphinx
    else
      @model = model.classify.safe_constantize
    end
  end
end
