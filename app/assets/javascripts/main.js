// JavaScript Document
//修改图片名称
$(function(){
	
    $(".photo_p").bind("click",function(){
		
        var thisHtml= $(this).html();
        $(this).hide().next("input.photo_input").show().val(thisHtml).focus();
		
        $(this).next("input.photo_input").blur(function(){
            var thisVal= $(this).val();
            $(this).hide().prev(".photo_p").show().html(thisVal);

            if (thisVal!=thisHtml){
                thisHtml=thisVal;
                $(".ok_tab").show();
                $(".ok_tab").css('top',(doc_height-document.body.scrollTop-layer_height)/2);
                $(".ok_tab").css('left',(doc_width-layer_width)/2);
				
                setTimeout(oknone,1500);
            }
            function oknone(){
                $(".ok_tab").hide();
            }
        });
	
	
    });
	
});

//私有相册输入密码弹出层
$(function(){
	var doc_width = $(document).width();
	var doc_height = $(document).height();
	var layer_height = $(".password_tab").height();
	var layer_width = $(".password_tab").width();
	$(".private").bind("click",function(){
		$(this).removeClass("private").addClass("hover").siblings().removeClass("hover");
		$(".mask").css("display","block");
		$(".mask").css("height",doc_height);
		$(".password_tab").show();
		$(".password_tab").css('top',(doc_height-document.body.scrollTop-layer_height)/2);
		$(".password_tab").css('left',(doc_width-layer_width)/2);
	})
	$(".close").click(function(){
		$(".mask").hide();
		$(".password_tab").hide();
	})
        $("#exchange").one("click",function(){
            $(this).removeClass("exchange").addClass("hover").siblings().removeClass("hover");
        })
	$("#public").one("click",function(){
		$(this).removeClass("public").addClass("hover").siblings().removeClass("hover");
	})

})


//修改个人信息
$(function(){
    var aa=false;
    $(".set_mess").bind("click",function(){
        if(aa==false){
            $(".mess_text").slideUp("fast");
            $(".mess_setArea").slideDown("fast");
            $(this).html("确定");
            aa=true;
        }else if(aa==true){
            $(".mess_text").slideDown("fast");
            $(".mess_setArea").slideUp("fast");
            $(this).html("修改");
            aa=false;
        }
    });
})

//展示图片手表经过图片显示介绍文字
$(function(){
    $(".showMiddle").mouseover(function(){
        $(this).find(".showText").show();
    })
    $(".showMiddle").mouseout(function(){
        $(this).find(".showText").hide();
    })
})

//scrollBox的长度
$(function(){
    var sbWidth = $(".scrollBox li").length*180;
    $(".scrollBox ul").css("width",sbWidth);
})

//scrollBox小图点击替换大图效果
$(function(){
    $('.scrollBox > ul > li img').click(function(){
        $(this).parent(".scrollBox > ul > li").addClass("sc_active").siblings().removeClass("sc_active");
        var imgSrc = $(this).attr('src');
  
        var i = imgSrc.lastIndexOf('.');
        var jpg = imgSrc.substring(i);

        var j = imgSrc.lastIndexOf('_');
        var bigImgName = imgSrc.substring(0,j);

        var imgSrc_big = bigImgName + jpg;
        $('.showPic img').attr('src',imgSrc_big);
    //alert(o);
    })
})

//showBox图片左右点击移动
$(function(){
    var page = 1;
    var i = 1;
    $('span.next').click(function(){
        //alert(0)
        var $parent = $(this).parents('div.showBox');
        var $pic_show = $parent.find('.showPic ul')
        var $smallImg = $parent.find('.showPic');
        var small_width = $smallImg.width();
        var len = $pic_show.find('li').length;
        var page_count = Math.ceil(len/i);
		
        if(!$pic_show.is(':animated')){
			
            if(page == page_count){
                $pic_show.animate({
                    left:'0px'
                },'slow');
                page = 1;
                $('div.scrollBox > ul > li').eq(0).addClass("sc_active").siblings().removeClass("sc_active");
            }else{
                $pic_show.animate({
                    left:'-='+small_width
                    },'slow');
                page++;
            }
        }
        ////
        var imgWidth = $(".showPic ul li").width();
        var divLeft = parseInt($(".showPic ul").css("left"));
		
        //alert(divLeft)
        var leftNum =Math.abs(divLeft/imgWidth);
        $('div.scrollBox > ul > li').eq(leftNum+1).addClass("sc_active").siblings().removeClass("sc_active");
    //var index = $('div.tab_ul li').index(this);
		
		
		
    })
	
	
    $('span.prev').click(function(){
        //alert(0)
        var $parent = $(this).parents('div.showBox');
        var $pic_show = $parent.find('.showPic ul')
        var $smallImg = $parent.find('.showPic');
        var small_width = $smallImg.width();
        var len = $pic_show.find('li').length;
        var page_count = Math.ceil(len/i);
		
        if(!$pic_show.is(':animated')){
			
            if(page == 1){
                $pic_show.animate({
                    left:'-='+small_width*(page_count-1)
                    },'slow');
                page = page_count;
				
            }else{
                $pic_show.animate({
                    left:'+='+small_width
                    },'slow');
                page--;
            }
        }
		
        ////
        var imgWidth = $(".showPic ul li").width();
        var divLeft = parseInt($(".showPic ul").css("left"));
		
        //alert(divLeft)
        var leftNum =Math.abs(divLeft/imgWidth);
        $('div.scrollBox > ul > li').eq(leftNum-1).addClass("sc_active").siblings().removeClass("sc_active");
		
    })
	
})
