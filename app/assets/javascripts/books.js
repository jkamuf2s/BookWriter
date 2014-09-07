$(document).ready(function(){
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