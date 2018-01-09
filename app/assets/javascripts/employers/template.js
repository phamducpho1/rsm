$(document).ready(function() {
  $('#apply-handling-content').on('change', '.template_member', function(){
    var template = $(this).val();
    $.get('/employers/templates/' + template);
  });
});

$(document).ready(function() {
  $('#apply-handling-content').on('change', '.template_user', function(){
    var template = $(this).val();
    $.get('/employers/templates/' + template );
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
