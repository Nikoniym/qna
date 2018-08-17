class Response
  attr_reader :name, :url, :model

  def initialize(object)
    send(object.class.name.downcase.to_sym, object)
  end

  private

  def question(object)
    @name = object.title
    @url = "questions/#{object.id}"
    @model = 'Question:'
  end

  def comment(object)
    if object.commentable_type == 'Question'
      @name = object.body
      @url = "questions/#{object.commentable_id}"
    else
      @name = object.body
      @url = "questions/#{object.commentable.question_id}"
    end
    @model = 'Comment:'
  end

  def answer(object)
    @name = object.body
    @url = "questions/#{object.question_id}"
    @model = 'Answer:'
  end

  def user(object)
    @name = :email
    @url = object.email
    @model = 'User:'
  end
end