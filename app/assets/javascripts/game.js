$(document).ready(function() {
  var check_pawn_promotion_url = $('#chess_board').attr('data-game-url');

  $.ajax({
    type: 'PATCH',
    url: check_pawn_promotion_url,
    dataType: 'json',
    statusCode: {
      206: function(data){
        var pawn_id = data["pawn_id"];
        $("#pawn-promote-button").trigger("click");
        $(".promote").click(function() {
          var piece_type = $(this).html();
          var pawn_promote_url = '/pieces/' + pawn_id + '/change_piece_type/' + piece_type

          $.ajax({
            type: 'PATCH',
            url: pawn_promote_url,
            data: {},
            dataType: 'json',
            success: function(data) {
              console.log(data);
              $('.close').trigger("click");
              location.reload();
            }
          });
        });
      }
    }
  });


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
    
    $(this).append(draggable.css('position','static'))

    $.ajax({
          type: 'PUT', 
          statusCode: {
            205: function() {
              location.reload();
            },
            422: function() {
              location.reload();          
            },
            206: function(data){
              console.log(data["pawn_id"]);
              var pawn_id = data["pawn_id"];
              $("#pawn-promote-button").trigger("click");
              $(".promote").click(function() {
                var piece_type = $(this).html();
                var pawn_promote_url = '/pieces/' + pawn_id + '/change_piece_type/' + piece_type

                $.ajax({
                  type: 'PATCH',
                  url: pawn_promote_url,
                  data: {},
                  dataType: 'json',
                  success: function(data) {
                    console.log(data);
                    $('.close').trigger("click");
                    location.reload();
                  }
                });
              });
            },
            204: function() {
              alert("Check Mate!");
            }
          },
          url: draggable.data('update-url'),
          dataType: 'json',
          data: { piece: {x_coord: x, y_coord: y}}
    });
  }
});