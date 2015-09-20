function render_chess_board() {
  var game_id = $(".chess_board_partial").data('game-id');
  var url = "/games/" + game_id + "/render_chess_board"

  $.get(url, function(data) {
    console.log('data', data);
    $(".chess_board_partial").empty();
    $(".chess_board_partial").append(data.chess_board);
    $(".move_list_partial").empty();
    $(".move_list_partial").append(data.move_list);
  }).done(function() {
    draggable_droppable();
  })
}

//function render_move_list() {
//  var game_id = $(".chess_board_partial").data('game-id');
//  var url = "/games/" + game_id + "/render_chess_board"


function draggable_droppable() {
  $( ".pieces" ).draggable({
     containment: '#chess_board',
     cursor: 'move',
   });
   $( ".square" ).droppable({
    drop: handleDropEvent
  });
}

function trigger_pawn_promotion_modal(pawn_id) {
  $("#pawn-promote-button").trigger("click");
  piece_type_buttons_listner(pawn_id);
  render_chess_board();
}

function piece_type_buttons_listner(pawn_id) { 
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
        $(".notice-alert").empty().append(data.notifications);
        render_chess_board();
      }
    });
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
          206: function(data){
            var pawn_id = data["pawn_id"];
            trigger_pawn_promotion_modal(pawn_id);
          }
        },
        url: draggable.data('update-url'),
        dataType: 'json',
        data: { piece: {x_coord: x, y_coord: y}}, 
        success: function (data) {
          render_chess_board();
          $(".notice-alert").empty().append(data.notifications);
        }  
  });
}

function check_pawn_promtion() {
  var check_pawn_promotion_url = $('#chess_board').attr('data-game-url');
  $.ajax({
    type: 'PATCH',
    url: check_pawn_promotion_url,
    dataType: 'json',
    success : function(data){
        var pawn_id = data.pawn_id;
        trigger_pawn_promotion_modal(pawn_id);
      }
  });
}

$(document).ready(function() {
  check_pawn_promtion();
  draggable_droppable();
});
