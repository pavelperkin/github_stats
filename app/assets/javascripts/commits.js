$(document).ready(function(){
  var source = new EventSource('/commits/stream');
  source.addEventListener('results', function(e){
    if(e.data != "null"){
      commit = jQuery.parseJSON(e.data);
      html = JST["templates/commit"](commit);
      $("#commits tbody").prepend(html);
    }
  });
  source.addEventListener('finished', function(e){
    source.close();
  });
});
