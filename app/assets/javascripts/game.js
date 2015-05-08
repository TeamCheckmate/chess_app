$(document).ready(function() {
  $(function() {
  $( ".pieces" ).draggable({
     containment: '#chess_board',
     cursor: 'move',
   });
   
   $( ".square" ).droppable({
    drop: handleDropEvent
  });
  });

  function handleDropEvent( event, ui ) {
    var x = $(event.target).data("x-coord");
    var y = $(event.target).data("y-coord");
    var draggable = ui.draggable;
    var piece_id = draggable.data("piece-id");
    window.piece_id = piece_id; //bad idea 
    
    $(this).append(draggable.css('position','static'))

    $.ajax({
          type: 'PUT', 
          statusCode: {
            205: function(data) {
              console.log(data);
              location.reload();
            },
            422: function(data) {
              console.log(data);
              location.reload();          
            },
            206: function(data){
              console.log(data["pawn_id"]);
              $(".promote").click(function() {
                
              });
              location.reload();
            },
            204: function(data) {
              console.log(data);
              alert("Check Mate!");
            }
          },
          url: draggable.data('update-url'),
          dataType: 'json',
          data: { piece: {x_coord: x, y_coord: y}}
        });
  }

  $(".promote").click(function() {
    $.ajax({
      type: "PUT",

      // send piece_id 
    })
  });
});