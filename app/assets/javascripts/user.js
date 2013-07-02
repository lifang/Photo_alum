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
        alert("消息已发送");
        return true;
    }
}
function qunfa(){ //群发功能
    var content = $("#content").val();
    var started_at = $("#started_at").val();
    var ended_at = $("#ended_at").val();
    var city = $("#city").val();
    if ($("#users_count").text() == 0){
        alert("没有相关用户");
    }
    else{
        $.ajax({
            type : 'post',
            dataType : 'json',
            url:"/messages/send_many_message",
            data : {
                content : content ,
                started_at : started_at ,
                ended_at : ended_at ,
                city : city
            },
            success:function(data){
                if(data.con_exist == 1){
                    if(data.status ==1){
                        alert("消息已发送");
                    }
                    else{
                        alert("没有符合条件的用户");
                    }
                }
                else{
                    alert("消息内容不能为空");
                }
            }
        })
    }
}