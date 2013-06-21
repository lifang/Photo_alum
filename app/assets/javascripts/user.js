// JavaScript Document
//偶数行变色
$(document).ready(function(){
  $(".table > tbody > tr:odd").addClass("tbg");
});

//发短信弹出层
//弹出层
function popup(t,b){
	var doc_height = $(document).height();
	var doc_width = $(document).width();
	var win_height = $(window).height();
	//var win_width = $(window).width();
	
	var layer_height = $(t).height();
	var layer_width = $(t).width();
	
	//tab
	$(b).bind('click',function(){
		    $(".mask").css({display:'block',height:doc_height});
			//$(t).css('top',(doc_height-layer_height)/2);
			//+document.documentElement.scrollTop
			$(t).css('top',(doc_height-document.body.scrollTop-layer_height)/2);
			$(t).css('left',(doc_width-layer_width)/2);
			$(t).css('display','block');
			return false;
		}
	)
	$(".close").click(function(){
		$(t).css('display','none');
		$(".mask").css('display','none');
	})
}
$(function(){
	popup(".tab",".setMess_btn");
})
