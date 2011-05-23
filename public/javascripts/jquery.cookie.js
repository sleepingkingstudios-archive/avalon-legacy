function set_cookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  } // end if
  else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
} // end function set_cookie

function get_cookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    } // end for
    return null;
} // end function get_cookie

function clear_cookie(name) {
    set_cookie(name,"",-1);
} // end function clear_cookie