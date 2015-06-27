$( document ).ready(function() {
    // Shift nav in mobile when clicking the menu.
    $(".document a").each(function(){
        if(this.href.indexOf("//"+location.host)<0){
            this.target = "_blank"
        } 
    })
});
