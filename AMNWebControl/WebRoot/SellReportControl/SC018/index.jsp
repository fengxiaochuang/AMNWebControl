<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="/include/sysfinal.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>新门店运营分析</title>
    <link href="<%=ContextPath%>/common/ligerui/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <script src="<%=ContextPath%>/common/ligerui/jquery/jquery-1.5.2.min.js" type="text/javascript"></script> 
	<script src="<%=ContextPath%>/common/ligerui/ligerUI/js/ligerui.all.js"></script>
	<script src="<%=ContextPath%>/common/ligerui/json2.js" type="text/javascript"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.validate.min.js" type="text/javascript"></script> 
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/messages_cn.js" type="text/javascript"></script> 
	<script type="text/javascript" src="<%=ContextPath%>/common/common.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/common/amnreport.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/SellReportControl/SC018/sc018.js"></script>
	<style type="text/css">
       .l-table-edit-td{ padding:4px;}
       .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
       .l-verify-tip{ left:230px; top:120px;}
	    body,html{height:100%;}
    	body{ padding:0px; margin:0;overflow:hidden;font-size:12px;}  
    	.l-link{ display:block; height:16px; line-height:16px; padding-left:10px; text-decoration:underline; color:#333;}
    	.l-link2{text-decoration:underline; color:white; margin-left:2px;margin-right:2px;}
    	.l-link3{text-decoration:underline;  margin-left:2px;margin-right:2px;}
    	.l-layout-top{background:#102A49; color:White;}
    	.l-layout-bottom{ background:#E5EDEF; text-align:center;}
	 	#dv_scroll{position:absolute;height:98%;overflow:hidden;width:298px;}
   </style>
</head>
<body>
	<div class="l-loading" style="display:block" id="pageloading"></div> 
	<div id="sc018layout" style="width:100%; margin:0 auto; margin-top:4px;">
	  	<div position="center"   id="designPanel"  style="width:100%;"> 
	  		<table id="showTable"  border="0" cellspacing="1" cellpadding="0" style="font-size:12px;line-height:25px;">
				<tr>
				 	<td width="600"><div><%@include file="/common/search.frag"%></div></td>
				 	<td width="80">查询月份：</td>
				 	<td width="130"><input id="strDate" type="text" size="10" /></td>
				  	<td><div id="searchButton"></div></td>
				   	<td><div id="excelButton"></div></td>
				</tr>
				<tr><td style="border-bottom:1px #000000 dashed" colspan="6"></td></tr>
			</table>	
			<div id="commoninfodivTradeDate" style="margin:0; padding:0"></div>		
		</div>
	</div> 
  	<div style="display:none;"></div>
</body>
<script type="text/javascript">
 	var contextURL="<%=request.getContextPath()%>";
</script>
</html>