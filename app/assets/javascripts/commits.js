$(document).ready(function(){
  var org_id = $("h1.org_name")[0].id;
  var source = new EventSource('/commits/stream?org_id='+org_id);
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
