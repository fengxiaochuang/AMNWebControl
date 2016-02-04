<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@include file="/include/sysfinal.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
  
    <link href="<%=ContextPath%>/common/ligerui/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
     <link href="<%=ContextPath%>/common/ligerui/ligerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" /> 
    
    <script src="<%=ContextPath%>/common/ligerui/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>
   	<script src="<%=ContextPath%>/common/ligerui/jquery/jquery.tablescroll.js" type="text/javascript"></script>
   	<script src="<%=ContextPath%>/common/ligerui/ligerUI/js/ligerui.all.js"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="<%=ContextPath%>/common/ligerui/jquery-validation/jquery.validate.min.js" type="text/javascript"></script> 
    <script src="<%=ContextPath%>/common/ligerui/jquery-validation/messages_cn.js" type="text/javascript"></script> 
 	<script src="<%=ContextPath%>/common/ligerui/json2.js" type="text/javascript"></script> 	
 	<script type="text/javascript" src="<%=ContextPath%>/common/amnreport.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/common/common.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/common/mindsearchitem.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/common/pinyin.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/common/standprint.js"></script>
	<script type="text/javascript" src="<%=ContextPath%>/SchoolControl/SCC008/scc008.js"></script>
	<script language="vbscript">
			function toAsc(str)
			toAsc = hex(asc(str))
			end function
	</script>
	
	<style type="text/css">
           body{ font-size:12px;}
        .l-table-edit {}
        .l-table-edit-td{ padding:4px;}
        .l-button-submit,.l-button-test{width:80px; float:left; margin-left:10px; padding-bottom:2px;}
        .l-verify-tip{ left:230px; top:120px;}
        .scr_con {position:relative;width:298px; height:98%;border:solid 1px #ddd;margin:0px auto;font-size:12px;}
        #dv_scroll{position:absolute;height:98%;overflow:hidden;width:298px;}
		#dv_scroll .Scroller-Container{width:100%;}
		#dv_scroll_bar {position:absolute;right:0;bottom:30px;width:14px;height:150px;border-left:1px solid #B5B5B5;}
		#dv_scroll_bar .Scrollbar-Track{position:absolute;left:0;top:5px;width:14px;height:150px;}
		/* tablescroll */
		.tablescroll{font:12px normal Tahoma, Geneva, "Helvetica Neue", Helvetica, Arial, sans-serif;background-color:#fff;}
		.tablescroll td,.tablescroll_wrapper,.tablescroll_head,.tablescroll_foot{border:1px solid #ccc;}
		.tablescroll td{padding:5px;}
		.tablescroll_wrapper{border-left:0;}
		.tablescroll_head{font-size:12px;font-weight:bold;background-color:#eee;border-left:0;border-top:0;margin-bottom:3px;}
		.tablescroll thead td{border-right:0;border-bottom:0;}
		.tablescroll tbody td{border-right:0;border-bottom:0;}
		.tablescroll tbody tr.first td{border-top:0;}
		.tablescroll_foot{font-weight:bold;background-color:#eee;border-left:0;border-top:0;margin-top:3px;}
		.tablescroll tfoot td{border-right:0;border-bottom:0;}
    </style>

</head>
<body>
	<div class="l-loading" style="display:block;height:100%;" id="pageloading"></div> 
	 <div id="scc001layout" style="width:100%;margin:0 auto; margin-top:0px;  "> 
	    <div position="center"   id="designPanel"  style="width:100%;"> 
	    	<form name="dataForm" method="post"  id="dataForm">
				<table width="100%" border="0" cellspacing="1" cellpadding="0" style="font-size:12px;line-height:35px;">
				<tr>
				<td width="600" valign="top">
				<table id="showTable" width="600"  border="0" cellspacing="1" cellpadding="0" style="font-size:12px;line-height:25px;" >
					<tr> 
				            <td  align="left">
				                <label>姓名:</label><input id="nameSearch" style="width:80px;"/>
				             </td>
				             <td><label>入学时间:</label> </td>
				             <td align="left">
				                  <input id="admissiontimeSearch" name="admissiontimeSearch" type="text" size="10" />
				             </td>
				              <td  align="left">
				                <label>就业情况:</label> 
				                <select name="graduationtypeSearch" id="graduationtypeSearch">
				                    <option value="">请选择</option>
						 	         <option value="1">毕业</option>
						 	         <option value="2">肄业</option>
						 	    </select>
				             </td>
						     <td><div id="searchButton"></div></td>
					</tr>
				</table>
				<div id="dataGrid" style="margin:0; padding:0;"></div>
				</td>
				<td  valign="top">
					<table width="100%" border="0" cellspacing="1" cellpadding="0" style="font-size:12px;line-height:35px;">
					<tr height="200">
							<td valign="top">
							<div style="width:900;float:left; clear:both; border:1px solid #ccc; overflow:auto;font-size:12px;margin-bottom: 5px;">
									<table id="dataTable" width="100%" border="0" cellspacing="1" cellpadding="0" style="font-size:12px;line-height:28px;" >
										 <tr>	
											<td>&nbsp;&nbsp;</td>
											<td colspan="6">
												<div id="saveBtn" style="float: right;margin-right: 100px;"></div>
												<div id="editBtn" style="float: right;margin-right: 50px;"></div>
												<div id="addBtn" style="float: right;margin-right: 50px;"></div>
											</td>
										</tr> 
										 <tr>	
											<td align="right" style="width:100">姓名:<input name="id" type="hidden" id="id" /></td>
											<td style="width:200" align="left">  <input name="name" type="text" id="name" /></td>
											<td align="right" style="width:80">年龄:</td>
											<td style="width:200" align="left"><input name="age" type="text" id="age" /></td>
											<td align="right" style="width:80">民族:</td>
											<td style="width:200" align="left"><input name="nation" type="text" id="nation" /></td>
											<td rowspan="4" style="width:200"><img src="" alt="头像" style="width:200px;height:100px;"/></td>
										</tr>
										<tr>	
											<td style="width:100" align="right">籍贯:</td>
											<td style="width:200" align="left"><input name="nativeplace" type="text" id="nativeplace" /></td>
											<td style="width:80" align="right">文化程度:</td>
											<td style="width:200" align="left">
											    <select name="educationlevels" id="educationlevels">
							                        <option value="1"> 初中及以下</option>
							                        <option value="2"> 高中</option>
							                        <option value="3" selected="selected"> 大专</option>
							                        <option value="4">本科</option>
							                        <option value="5">硕士</option>
							                    </select>
											</td>
											<td style="width:100" align="right">性别:</td>
											<td style="width:200" align="left">
											     <input  type="radio" value="1" name="sex" id="manSex"/> <label >男</label>
											     <input  type="radio" value="2" name="sex" id="womanSex"/><label >女</label>
											</td>
										</tr>
										<tr>	
											<td style="width:130"  align="right">身份证号码:</td>
											<td  colspan="2" align="left" ><input style="width:200" name="idcardnumber" type="text" id="idcardnumber" /></td>
											
										    <td style="width:80" align="right">身份证地址:</td>
											<td colspan="2" align="left"><input name="idcardaddress" type="text" id="idcardaddress" /></td>
										</tr>
										<tr>	
											<td style="width:100"  align="right">手机:</td>
											<td   align="left"><input name="phone" type="text" id="phone" /></td>
											<td style="width:80"  align="right">家庭电话:</td>
											<td colspan="2"><input name="homephone" type="text" id="homephone" /></td>
										</tr>
										<tr>	
											<td style="width:100" align="right">学习科目: </td>
										    <td >
										         <input  type="checkbox" name="studysubject" id="studysubject1"/><label >烫染</label>
                                                 <input  type="checkbox"  name="studysubject" id="studysubject2"/><label >美容</label>
                                            </td>
											<td align="right">来校途径:</td>
											<td><input name="age" type="text" id="comeschoolway" name="comeschoolway"/></td>
											<!-- <td >毕业实习期望店:</td>
											<td ><input name="age" type="text" id="age" /></td> -->
										</tr>
										<tr>
										    <td style="width:100" align="right">实习期望店: </td>
										    <td >  
                                              <!--   <input name="expectcompany " type="text" id="expectcompany" /> -->
                                                <select name="expectcompany " id="expectcompany">
                                                     <option value="">--请选择--</option>
                                                </select>
                                            </td>
                                            <td align="right">入学时间: </td>
										    <td >  
                                                <input name="admissiontime" type="text" id="admissiontime" />
                                            </td>
                                              <td align="right">就业状况: </td>
										    <td >  
                                                <select name="graduationtype" id="graduationtype">
                                                     <option value="">--请选择--</option>
                                                     <option value="1">毕业</option>
                                                     <option value="2">肄业</option>
                                                </select>
                                            </td>
										</tr>
										<tr>	
										   <td style="width:100" align="right">备注:</td>
											<td colspan="6">
											     <textarea rows="2" style="margin: 0px; width: 664px; height: 56px;" cols="40" id="remark" name="remark"></textarea>
											</td>
										</tr> 
										
										
									</table>
								</div>
							</td>
					</tr>
					<tr >
							<td valign="top">
							<div id="familyGrid" style="margin:0; padding:0"></div>
							</td>
					</tr>
					</table>
				</td>
				</tr>
				</table>
			</form>
			<input type="hidden" id="needPost" name="needPost" value="1"/>
	    </div>
	 </div>
  <div style="display:none;">
  <!-- g data total ttt -->
</div>

</body>
</html>
	<script language="JavaScript">
  	 	var contextURL="<%=request.getContextPath()%>"; 
  		document.write("<div id=\"keysList\" style=\"z-index:2;width:350px;position:absolute;display:none;background:#FFFFFF;border: 2px solid #a4a6a1;font-size:13px;cursor: default;\" onblur> </div>");
        document.write("<style>.sman_selectedStyle{background-Color:#102681;color:#FFFFFF}</style>");
	</script>
