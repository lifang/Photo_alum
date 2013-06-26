// JavaScript Document
//偶数行变色
$(document).ready(function(){
    $(".table > tbody > tr:odd").addClass("tbg");

});
function show_message(t){
    var doc_height = $(document).height();
    var doc_width = $(document).width();
    var win_height = $(window).height();
    //var t = ".tab"
    var layer_height = $(t).height();
    var layer_width = $(t).width();

    $(".mask").css({
        display:'block',
        height:doc_height
    });
    $(t).css('top',(doc_height-document.body.scrollTop-layer_height)/2);
    $(t).css('left',(doc_width-layer_width)/2);
    $(t).css('display','block');
    $(".close").click(function(){
        $(t).css('display','none');
        $(".mask").css('display','none');
    })
}
function send_msg(id){
    var id = id;
    show_message("#send_msg_div");
    $("#send_msg_div form").append("<input type='hidden' name='id'value="+id+" />");
}
function yincang(){
    if ($("#message_content").val() == ''){
        alert("发送信息不能为空");
        return false;
    }
        else{
    var t = ".tab"
    $(t).css('display','none');
    $(".mask").css('display','none');
    return true;
    }
}