$(document).ready(function(){
  var source = new EventSource('/commits/stream');
  source.addEventListener('results', function(e){
    if(e.data != "null"){
      commit = jQuery.parseJSON(e.data)
      // #TODO Set templates for commits and render them here.
      $("#commits tbody").prepend(
        "<tr><td>"+commit.id+"</td><td>"+commit.username+"</td><td>"+
        commit.message+"</td><td>"+commit.sha+"</td><td>"+commit.url+"</td></tr>"
      );
    } 
  });
  source.addEventListener('finished', function(e){
    source.close();
  });
});


