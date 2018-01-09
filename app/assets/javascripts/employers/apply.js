$(document).on('change', '.apply_select', function(event){
  var applyId = $(this).next().val();
  var value = $(this).val();
  var textStatus = I18n.t('employers.applies.statuses.' + value.toString());
  $('#apply-handling-content').html('');
  swal({
    title: I18n.t('jobs.apply.confirm_change_status'),
    text: I18n.t('jobs.apply.text_change_status', {status: textStatus}),
    icon: 'warning',
    buttons: true,
    primaryMode: true,
  })
  .then((willDelete) => {
    if (willDelete) {
      if(value === 'interview_scheduled' || value === 'test_scheduled'){
        event.preventDefault();
        $.get('/employers/applies/' + applyId + '/edit/?status=' + value);
      }else{
        this.form.commit.click();
      }
    }else{
      $('#apply-handling .edit_apply')[0].reset();
    }
  });
});

$(document).on('hidden.bs.modal', '.modal-apply', function () {
  var apply_id = $(this).data("id");
  $.get('/employers/applies/' +  apply_id);
})
