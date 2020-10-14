$(document).ready(function(){
  $('select').formSelect();

  window.addEventListener('message', function(event) {
    if (event.data.action == 'open') {
      $('#wrapper').show();
    } else if (event.data.action == 'close') {
      $('#wrapper').hide();
    }
  });

  $('#parken').click(function() {
    post("parken", {});
    $('#wrapper').hide();
    return true;
});

  $('#hostpital').click(function() {
    post("hostpital", {});
    $('#wrapper').hide();
    return true;
});
  
  $('#sandy').click(function() {
    post("sandy", {});
    $('#wrapper').hide();
    return true;
});

  $('#motel').click(function() {
    post("motel", {});
    $('#wrapper').hide();
    return true;
	});
});

function post(name, data) {
  $.post('http://esx-delta-spawnmenu/'+name, JSON.stringify(data));
}

