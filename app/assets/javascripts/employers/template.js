$(document).ready(function() {
  $('#apply-handling-content').on('change', '.template_member', function(){
    var template = $(this).val();
    $.get('/employers/templates/' + template);
  });
});

$(document).on('click', '.open', function(){
  var id = $(this).val();
  if ($('.open').is(':checked')){
    $('.view_' + id).show();
  }else{
    $('.view_' + id).hide();
  }
});

$(document).on('click', '.show-inter', function(){
  var id = $(this).val();
  $('#body_template_'+id).modal('show');
});

$(document).on('change', '.template-user', function(){
  var template = $(this).val();
  var status_apply = document.getElementById('new_apply');
  var data_apply = new FormData(status_apply);
  var data = {
    step_id: data_apply.get('step_id'),
    address: data_apply.get('apply_status[appointment_attributes][address]'),
    start_time: data_apply.get('apply_status[appointment_attributes][start_time]'),
    end_time: data_apply.get('apply_status[appointment_attributes][end_time]'),
    name: data_apply.get('user_name')
  };
  $.ajax('/employers/templates/' + template, {
    type: 'GET',
    data: data
  });
});

$(document).on('click', '#check-template', function(){
  if ($('#check-template').is(':checked')){
    $('#content-note').show();
  }else{
    $('#content-note').hide();
  }
});

$(document).on('click', '.view_mail', function(){
  var step_id = $(this).val();
  var content_mail = $('#content-template-user-'+ step_id).val();
  $('#contentmail-'+ step_id).html(content_mail);
  $('#review_template_'+ step_id).modal('show');
});
