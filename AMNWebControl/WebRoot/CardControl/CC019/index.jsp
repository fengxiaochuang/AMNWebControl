<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="/include/sysfinal.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="<%=ContextPath%>/common/ligerui/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
    <script src="<%=ContextPath%>/common/ligerui/jquery/jquery-1.5.2.min.js" type="text/javascript"></script> 
	<script src="<%=ContextPath%>/common/ligerui/ligerUI/js/ligerui.all.js"></script>
	<script src="<%=ContextPath%>/common/ligerui/json2.js" type="text/javascript"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.validate.min.js" type="text/javascript"></script> 
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/messages_cn.js" type="text/javascript"></script> 
	<script type="text/javascript" src="<%=ContextPath%>/common/common.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/CardControl/CC019/cc019.js"></script>

		<style type="text/css">
           body{ font-size:12px;}
        .l-table-edit {}
        .l-table-edit-td{ padding:4px;}
        .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}
  
		    body,html{height:100%;}
	    body{ padding:0px; margin:0;   overflow:hidden;}  
	    .l-link{ display:block; height:16px; line-height:16px; padding-left:10px; text-decoration:underline; color:#333;}
	    .l-link2{text-decoration:underline; color:white; margin-left:2px;margin-right:2px;}
	    .l-link3{text-decoration:underline;  margin-left:2px;margin-right:2px;}
	    .l-layout-top{background:#102A49; color:White;}
	    .l-layout-bottom{ background:#E5EDEF; text-align:center;}
		 #dv_scroll{position:absolute;height:98%;overflow:hidden;width:298px;}
    </style>
</head>
<body >
<div class="l-loading" style="display:block" id="pageloading"></div> 
	 
  	 <div id="bc006layout" style="width:100%; margin:0 auto; margin-top:4px; "> 
	  			 		<div position="left"   id="lsPanel" title="连锁结构"> 
		  			 		<div style="width: 270px; height: 650; overflow-y:auto;overflow-x:hidden;">
		  			 		 	<ul id="companyTree" style="margin-top:3px;">
		  			 		 	</ul>
		  			 		 </div>
	  			 		</div>
				        <div position="center"   id="designPanel"  style="width:100%;"> 
					           <div id="searchbar" style="width:100%">
			    				手机号码：<input id="phone" name="curMaster.phone" type="text" />
			    				&nbsp;&nbsp;
			    				姓名：
			    				<input id="name" readonly="true">
			    				<input id="btnOK" type="button" value="查询" onclick="loadPhone()" />
			    				&nbsp;&nbsp;&nbsp;&nbsp;
			    				<input id="btnPOST" type="button" value="保存" onclick="post()" />
								</div>
								<div id="commoninfodivsecond" style="margin:0; padding:0"></div>
				        </div>
				        <div position="right">
									<table width="300px" style="font-size:12px;line-height:30px">
										<tr>
											<td>总可退金额:</td>
											<td><input name="sumAmt" id="sumAmt" size="10" value="0"/></td>
										</tr>
										<tr>
											<td>扣成本:</td>
											<td><input name="curMaster.cost" id="cost" size="10" onchange="cost(this)"/></td>
										</tr>
										<tr>
											<td>现金方式:</td>
											<td>
												<select name="curMaster.cashpaycode" style="width:95px;" id="cashpaycode">
													<option value="1">现金</option>
													<option value="6">银行卡</option>
												</select>
											</td>
										</tr>
										<tr>
											<td>金额:</td>
											<td><input name="curMaster.cashamt" id="cashamt" size="10"
														onchange="cash(this)"/></td>
										</tr>
										<tr>
											<td>退储值:</td>
											<td><input name="curMaster.storedamt" id="storedamt" readonly="true"
												size="10"
												onchange="changeStoreAmt(this)">
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<input id="isold" type="checkbox" onclick="checkCard(this)"/>退回原卡内
											</td>
										</tr>
										<tr>
											<td>
												卡号:
											</td>
											<td>
												<input name="curMaster.cardno" id="cardno" size="10" onchange="validateCscardno()"/>
											</td>
										</tr>
										<tr>
											<td>
												确认卡号:
											</td>
											<td>
												<input id="cardnoagen" size="10" />
											</td>
										</tr>
										<tr>
											<td colspan="2"><div id="yearcard" style="margin:0; padding:0"></div></td>
										</tr>
									</table>
								</div>
							</div>
				    	</div> 

	
  <div style="display:none;">
  <!-- g data total ttt -->
</div>
 
</body>
</html>
	<script language="JavaScript">
  	 	var contextURL="<%=request.getContextPath()%>";
  	
	</script>