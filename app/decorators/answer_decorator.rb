class AnswerDecorator < Draper::Decorator
  delegate :body, :question_id

  def completion_link
    h.link_to body, h.question_path(question_id)
  end

  def model
    h.content_tag(:span, 'Answer: ')
  end
end
