konami = {
  input: "",
  pattern: "3838404037393739666513",
  code: function(){
    console.log("The President has been kidnapped by ninjas. Are you a bad enough dude to rescue the President?");
  } // end method code
}; // end object konami

jQuery(document).ready(function(){
  jQuery(document).keydown(function(event){
    konami.input += event.which;
    var i_len, p_len;
    if((i_len = konami.input.length) > (p_len = konami.pattern.length)) {
      konami.input = konami.input.substring(i_len - p_len, i_len);
    } // end if
    if(konami.input == konami.pattern) {
      konami.code();
    } // end if
  }); // end document.keydown
}); // end document.ready
