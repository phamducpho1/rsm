var CompCalendar = function() {
  var calendarEvents  = $('.calendar-events');
  var initEvents = function() {
    $('.calendar-events').find('li').each(function() {
      var eventObject = { title: $.trim($(this).text()), color: $(this).css('background-color') };
      $(this).data('eventObject', eventObject);
      $(this).draggable({ zIndex: 999, revert: true, revertDuration: 0 });
    });
  };

   return {
    init: function() {
      initEvents();
      var startDate = new Date();
      var d = startDate.getDate();
      var m = startDate.getMonth();
      var y = startDate.getFullYear();
      var endDate = new Date(y, m, d, 23, 0);
      eventsValues = $('#apply-appointments').data('events');
      var events = [];

      events = Object.keys(eventsValues).map(function(key){
        var event = eventsValues[key];
        var start_time = event[0]['start_time'];
        var end_time = event[0]['end_time'];
        return {
          title: key.toString(),
          start: moment(new Date(start_time)),
          end: moment(new Date(end_time)),
          allDay: false,
          color: 'black',
          editable: false
        };

      });

      var eventInput = $('#add-event');
      var eventInputVal = '';

      $('#add-event-btn').on('click', function(){
        eventInputVal = eventInput.prop('value');
        if( eventInputVal ){
          $('.calendar-events').append('<li class="animation-slideDown">' + eventInputVal + '</li>');
          eventInput.prop('value', '');
          initEvents();
        }
        return false;
      });

      $('#calendar').fullCalendar({
        header: {
          left: 'prev,next',
          center: 'title',
          right: 'month,agendaWeek,agendaDay'
        },
        firstDay: 1,
        timezone:'UTC',
        editable: true,
        droppable: true,

        drop: function(date, allDay) {
          var originalEventObject = $(this).data('eventObject');
          var copiedEventObject = $.extend({}, originalEventObject);
          copiedEventObject.start = startDate;
          copiedEventObject.end = endDate;

          setValueDate('.apply-appointment-start-time', moment(startDate).format(I18n.t('time.formats.format_datetime_picker')));
          setValueDate('.apply-appointment-end-time', moment(endDate).format(I18n.t('time.formats.format_datetime_picker')));
          $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
            $(this).remove();
        },

        events: events,
        eventRender: function( event, element, view ) {
          if(event.changing){
            if(event.start !== null) {
              var startTime = event.start.format(I18n.t('time.formats.format_datetime_picker'));
              setValueDate ('.apply-appointment-start-time', startTime);
            }

            if(event.end !== null) {
              var endTime = event.end.format(I18n.t('time.formats.format_datetime_picker'));
              setValueDate ('.apply-appointment-end-time', endTime);
            }
          }
        },

        eventResizeStart: function(event, jsEvent, ui, view ){
          event.changing = true;
        },

        eventResizeEnd: function(event, jsEvent, ui, view ){
          event.changing = false;
        },

        eventDragStart: function(event, jsEvent, ui, view ){
          event.changing = true;

        },

        eventDragEnd: function(event, jsEvent, ui, view ){
          event.changing = false;

        },

        eventResize: function(event, delta, revertFunc) {
          var endTime = event.end.format(I18n.t('time.formats.format_datetime_picker'));
          setValueDate ('.apply-appointment-end-time', endTime);
        }
      });
    }
  };
}();

function setValueDate (element, time){
  $(element).val(time);
}
