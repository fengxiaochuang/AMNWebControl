<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@include file="/include/sysfinal.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>jQuery plugin - Flex - Demo</title>
<style>
*{margin:0;padding:0;list-style-type:none;}
a,img{border:0;}
body{font:12px/180% Arial, Helvetica, sans-serif, "新宋体";background-image:url(<%=ContextPath%>/fullScree2/images/6448917381_0b754e86fb_z.jpg)}
/* flex */
.flex{position:relative;width:850px;min-height:300px;margin:40px auto;}
.flex a{background:#fff;display:block;width:100px;height:100px;border-radius:8px;position:absolute;background-repeat:no-repeat;background-position:center;border:3px solid white;cursor:pointer;text-align:left;text-shadow:1px 1px 20px #000;color:white;font-size:18px;font-weight:bold;text-indent:10px;line-height:30px;text-decoration:none;}
.flex .a{background-image:url(<%=ContextPath%>/fullScree2/images/6448917381_0b754e86fb_z.jpg);}
.flex .b{background-image:url(<%=ContextPath%>/fullScree2/images/7362866426_bf285ebd45.jpg);background-size:300px auto;}
.flex .c{background-image:url(<%=ContextPath%>/fullScree2/images/7322604950_348c535903.jpg);}
.flex .d{background-image:url(<%=ContextPath%>/fullScree2/images/7419245080_bb752ed1d6.jpg);}
.flex .e{background-image:url(<%=ContextPath%>/fullScree2/images/6468321069_3375be3073_z.jpg);background-size:auto 280px;}
.flex .f{background-image:url(<%=ContextPath%>/fullScree2/images/7342556872_46cddaf9b0.jpg);background-size:auto 280px;}
.flex .g{background-image:url(<%=ContextPath%>/fullScree2/images/7322604950_348c535903.jpg);background-size:auto 200px;}
.flex .h{background-image:url(<%=ContextPath%>/fullScree2/images/7286717012_6e6b450243.jpg);}
.flex .i{background-image:url(<%=ContextPath%>/fullScree2/images/7452167788_a3f6aa3104.jpg);background-size:auto 200px;}
.flex .j{background-image:url(<%=ContextPath%>/fullScree2/images/6480022425_a8d419e663_z.jpg);background-size:auto 280px;}
.flex .k{background-image:url(<%=ContextPath%>/fullScree2/images/7269592732_c4b7918626.jpg);background-size:auto 280px;}
</style>
 <script src="<%=ContextPath%>/common/ligerui/jquery/jquery.min.js" type="text/javascript"></script> 
 <script src="<%=ContextPath%>/common/ligerui/jquery/jquery.flex.js" type="text/javascript"></script> 
<script type="text/javascript">
$(function(){
	$(".flex").flex();
});
</script>
</head>
<body>


<div class="flex">
	<a class="a" style="left:0px;top:0px;width:250px;height:125px;" width="350" height="275">A</a>
	<a class="b" style="left:260px;height:100px;top:0px;width:125px;" width="250" height="175">B</a>
	<a class="c" style="left:395px;height:250px;top:0px;width:75px;" width="125" height="350">C</a>
	<a class="d" style="left:480px;height:75px;top:0px;width:75px;" width="175" height="150">D</a>
	<a class="e" style="left:565px;height:125px;top:0px;width:200px;" width="200" height="250">E</a>
	<a class="f" style="left:480px;height:200px;top:85px;width:75px;" width="150" height="225">F</a>
	<a class="g" style="left:0px;height:100px;top:135px;width:75px;" width="225" height="150">G</a>
	<a class="h" style="left:260px;height:75px;top:110px;width:125px;" width="200" height="200">H</a>
	<a class="i" style="left:85px;height:140px;top:135px;width:165px;" width="250" height="140">I</a>
	<a class="j" style="left:565px;height:150px;top:135px;width:75px;" width="125" height="275">J</a>
	<a class="k" style="left:650px;height:75px;top:135px;width:75px;" width="75" height="200">K</a>
</div>

</body>
</html>