class CommentDecorator < Draper::Decorator
  delegate_all

  def completion_link
    if commentable_type == 'Question'
      h.link_to body, h.question_path(commentable_id)
    else
      h.link_to body, h.question_path(commentable.question_id)
    end
  end

  def model
    h.content_tag(:span, 'Comment: ')
  end
end
