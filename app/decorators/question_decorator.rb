class QuestionDecorator < Draper::Decorator
  delegate :title

  def completion_link
    h.link_to title, h.question_path(self)
  end

  def model
    h.content_tag(:span, 'Question: ')
  end
end
