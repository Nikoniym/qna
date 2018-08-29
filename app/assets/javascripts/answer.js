function openForm() {
  $('.answers-list').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    var answer_id = $(this).data('answerId')

    $('.answer-' + answer_id + ' .link-group').hide()
    $('.answer-' + answer_id + ' .answer-body').hide()

    $('form#edit_answer_' + answer_id).show()
  })
}

$( window ).on( "load", openForm )