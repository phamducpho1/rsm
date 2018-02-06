$(document).on('change', '#form-apply-status-main input[type=radio]', function(event){
  event.preventDefault();
  var applyId = $('#form-apply-status-main #apply_status_apply_id').val();
  var value = $('#form-apply-status-main input[type=radio]:checked').val();
  if ($(this).is(':checked')) {
    $.get('/employers/apply_statuses/new?status_step_id=' + value + '&&apply_id=' + applyId);
  }
});

$(document).on('hidden.bs.modal', '.modal-apply', function () {
  var apply_id = $(this).data("id");
  $.get('/employers/applies/' +  apply_id);
})

$(document).on('click', '.btn-apply-status', function(event){
  var element = this.nextElementSibling;
  var textStep = $(this).next().children('.step-value').val();
  swal({
    title: I18n.t('jobs.apply.confirm_change_status'),
    text: I18n.t('jobs.apply.text_change_status_button', {step: textStep}),
    icon: 'warning',
    buttons: true,
    primaryMode: true,
  })
  .then(function(isConfirm){
    if (isConfirm) {
      element.commit.click();
    }
  });
});

$(document).on('click', '.btn-submit-apply-status-form', function(event){
  var apply_status_form = document.getElementById('new_apply');
  var textStatus = $('#form-apply-status-main input[type=radio]:checked').next().text();
  swal({
    title: I18n.t('jobs.apply.confirm_change_status'),
    text: I18n.t('jobs.apply.text_change_status', {status: textStatus}),
    icon: 'warning',
    buttons: true,
    primaryMode: true,
  })
  .then(function(isConfirm){
    if (isConfirm) {
      apply_status_form.commit.click();
    }
  });
});

$(document).on('click', '#pagination-history-apply .pagination a', function (event) {
  event.preventDefault();
  $.getScript($(this).attr('href'));
  return false;
});

$(document).on('click', '#cancel-apply-email', function (event) {
  $('#apply-handling-content').html('');
  $('#form-apply-status-main')[0].reset();
});
