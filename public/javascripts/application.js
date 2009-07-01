// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var FlashMessage = {
  show: function(message) {
    $('#flash p').html(message);
    $('#flash').fadeIn(2000).fadeTo(6000, 1).fadeOut(2000);
  }
};

var MessageView = {
  updateMessageCharactersCount: function(message_body_id, message_characters_count_id) {
    $(message_body_id).live("keyup", function(){
      message_length_remaining = 300;
      message_length = $(this).attr('value').replace(/\r|\n|\r\n/, "").length;
      message_length_remaining = parseInt(300 - message_length);
      if(message_length_remaining < 0)
        $(message_characters_count_id).addClass("red");
      else
        $(message_characters_count_id).removeClass("red");
      if(message_length > 300 || message_length <=0) {
        $(message_body_id).parents("form").find("input[type=submit]").disable();
        $(message_body_id).parents("form").find("input[type=submit]").addClass("disabledSubmitButton");
      }
      else {
        $(message_body_id).parents("form").find("input[type=submit]").enable();
        $(message_body_id).parents("form").find("input[type=submit]").removeClass("disabledSubmitButton");
      }
      $(message_characters_count_id).text(message_length_remaining);
    });
  }
};