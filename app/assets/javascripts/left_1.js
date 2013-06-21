$(document).ready(function(){
    $("input[name='ajax_onloads']").click(function(){
        var button = $(this);
        var uid = $(this).attr("uid");
        $.ajax({
            async:true,
            type : 'get',
            url:"admins/checkornot",
            data  : {
                id : uid
            },
            success: function(data){
                if(data.status == 1){
                    alert("更新成功!");
                    if(data.u_status ==1 ){
                        button.val("可查看");
                    }
                    else{
                        button.val("不可查看");
                    }
                }else{
                    alert("更新失败!")
                }
            }
        })
    })
    $("input[name='ajax_regester']").click(function(){
        var button1 =$(this);
        var aid = $(this).attr("uid");
        $.ajax({
            async:true,
            type : 'get',
            url:"admins/registerornot",
            data  : {
                id : aid
            },
            success: function(data){
                if(data.status == 1){
                    alert("更新成功");
                    if(data.a_status == 1){
                        button1.val("可注册");
                    }
                    else{
                        button1.val("不可注册");
                    }
                }else{
                    alert("不可查看");
                }
            }
        })
    })
        $("#city_city_id").change(function(){
        var cid = $("#city_city_id").val();
        var name = $("#name").val();
        var url = $("#url").val();
        $.ajax({
            async:true,
            type : 'get',
            dataType : 'script',
            url:"/users",
            data : {city_city_id : cid, name : name, url : url}
        })
    });
    $(document).on('click', '#page_div .pageTurn a', function(){
        var url = $(this).attr("href");
        $.ajax({
            type : 'get',
            dataType:'script',
            url : url
        });
        return false;
    })
})
function search_users(){
    var name = $("#name").val();
    var url = $("#url").val();
    $.ajax({
        url:"/users",
        type: "get",
        dataType: "script",
        data:{
            name : name, url : url
        }
    })
}