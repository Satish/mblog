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
      message_length_remaining = MAX_MESSAGE_LENGTH;
      message_length = $(this).attr('value').replace(/\r|\n|\r\n/, "").length;
      message_length_remaining = parseInt(MAX_MESSAGE_LENGTH - message_length);
      if(message_length_remaining < 0)
        $(message_characters_count_id).addClass("red");
      else
        $(message_characters_count_id).removeClass("red");
      if(message_length > MAX_MESSAGE_LENGTH || message_length <=0) {
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

var ReplyToMessageForm = {
  initialize: function() {
    $("#replyToMessageFormContainer").dialog({
                                               autoOpen: false,
                                               bgiframe: true,
                                               width: 650,
                                               height: 'auto',
                                               modal: true,
                                               position: 'center',
                                               resizable: false,
                                               overlay:
                                                       {
                                                         background: '#000',
                                                         opacity: 0.5
                                                       },
                                                title: 'Your Reply'
                                              });
  },

  open: function(parent_node_id, reply_to_name) {
    $("#replyToMessageForm #message_parent_node_id").attr("value", parent_node_id);
    $("#replyToMessageForm textarea").attr("value", '')
    $("#replyToMessageForm #message_parent_id").attr("value", parent_node_id);
    $("#replyToMessageFormContainer").dialog('open');
    setCursorAtEnd($('#replyToMessageFormBody'), reply_to_name + " ");
  },

  close: function() {
    $("#replyToMessageForm #message_parent_node_id").attr("value", 0);
    $("#replyToMessageCharactersCount").text(MAX_MESSAGE_LENGTH);
    $("#replyToMessageFormContainer").dialog('close');
  },

};

function setCursorAtEnd(myField, myValue) {
  if (document.selection) {
    myField.focus();
    sel = document.selection.createRange();
    sel.text = myValue;
  }
  else {
    myField.attr("value", myValue);
  }
}