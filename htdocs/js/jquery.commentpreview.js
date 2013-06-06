jQuery(document).ready(function($) {
    $("#submitmoreopts").live("click", function(e) {
        var replyto = Number($('input[name=dtid]').val());
        var pid = Number($('input[name=parenttalkid]').val());
        var basepath = $('input[name=basepath]').val();

        e.stopPropagation();
        e.preventDefault();

        if(replyto > 0 && pid > 0) {
            $("#previewform").attr("action", basepath + "replyto=" + replyto );
        } else {
            $("#previewform").attr("action", basepath + "mode=reply" );
        }

        $("#previewform").submit();
    });
});

