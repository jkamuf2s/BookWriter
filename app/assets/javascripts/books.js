$(document).ready(function(){

    //create Ajax request for Links
    $("#books th a, #books .pagination a").on("click",function(){   // EventHandler- creation 1. Param (Which event?) 2. Param (Which function to execute? (http://api.jquery.com/on/)
        $.getScript(this.href);                                     // Load a JavaScript file from the server using a GET HTTP request, then execute it.
        return false
    });


    // publish checkbox 
    $('[data-published]').click(function(){
        // when checked
        if($(this).prop('checked')){
            $("#booksearch_publishdate_from").attr("disabled", false);
            $("#booksearch_publishdate_to").attr("disabled", false);
            $(this).prop('checked', true);
        }
        // when unchecked
        else{
            $("#booksearch_publishdate_from").attr("disabled", true);
            $("#booksearch_publishdate_to").attr("disabled", true);
            $(this).prop('checked', false);
        }

    })

    $('[data-publicsearch]').click(function(){
        // when checked
        if($(this).prop('checked')){
            $("#booksearch_author").attr("disabled", false);
            $(this).prop('checked', true);
        }
        // when unchecked
        else{
            $("#booksearch_author").attr("disabled", true);
            $(this).prop('checked', false);
        }

    })

    $('#booksearch_is_published').change(function () {
        if ($(this).is(':checked')) {
            $('#booksearch_publishdate_from').enable();
            $('#booksearch_publishdate_to').enable();
        } else {
            $('#booksearch_publishdate_from').disable();
            $('#booksearch_publishdate_to').disable();
        }
    });
})