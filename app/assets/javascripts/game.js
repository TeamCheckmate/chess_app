function render_chess_board(game_id) {
  var url = "/games/" + game_id + "/render_chess_board"

  $.get(url, function(data) {
    $(".chess_board_partial").empty();
    $(".chess_board_partial").append(data.html);
  }).done(function() {
    draggable_droppable();
  });
}

function draggable_droppable() {
  $( ".pieces" ).draggable({
     containment: '#chess_board',
     cursor: 'move',
   });
   $( ".square" ).droppable({
    drop: handleDropEvent
  });
}

function handleDropEvent( event, ui ) {
  var game_id = $(".chess_board_partial").data('game-id');
  var x = $(event.target).data("x-coord");
  var y = $(event.target).data("y-coord");
  var draggable = ui.draggable;
  var piece_id = draggable.data("piece-id");
  
  $(this).append(draggable.css('position','static'))

  $.ajax({
        type: 'PUT', 
        statusCode: {
          205: function() {
            render_chess_board(game_id);
          },
          422: function() {
            render_chess_board(game_id);   
          },
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
         
                  $('.close').trigger("click");
                  render_chess_board(game_id);
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

function check_pawn_promtion() {
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
}

$(document).ready(function() {
  check_pawn_promtion();
  draggable_droppable();
});

$(document).ajaxComplete(function () {
  draggable_droppable();;
});
