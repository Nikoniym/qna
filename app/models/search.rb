class Search
  ATTR = %w(all user question answer comment)

  def initialize(text, model)
    @objects = {}
    @text = text
    @model = model
  end

  def call
    check_model(@model)
    @text.present? ? @objects = @model.search(Riddle.escape(@text), page: 1, per_page: 50) :  @objects = {}
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
