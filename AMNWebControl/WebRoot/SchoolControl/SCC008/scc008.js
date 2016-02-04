var dataGrid=null;	//合作学校列表
var familyGrid=null;	//课程列表
var scc001layout=null;
var curpagestate=3; // 1 add 2 modify 3 browse
var curpageHomestate=3; // 1 add 2 modify 3 browse
var strCurSupperId = "";
//初始化属性
$(function(){
   try{  
	   var companyinfo=parent.complinkInfo[0].children;
	   for(var i=0;i<companyinfo.length;i++){
		   var flag1=companyinfo[i].children;
		   
		   for(var i=0;i<flag1.length;i++){
			   var flag2=flag1[i].children;
			   
			   for(var i=0;i<flag2.length;i++){
				   var flag3=flag2[i];
				  
				   var expectcompanySelect=$("#expectcompany").append("<option value='"+flag3.text+"'>"+flag3.text+"</option>");
				 
				   
			   } 
		   } 
	   }

		 //布局
	    dataLayout= $("#dataLayout").ligerLayout({ allowBottomResize: false, allowLeftResize: false });
        height = $(".l-layout-center").height();
        /*	 centerWidth = dataLayout.centerWidth;*/
       
      	$("#admissiontimeSearch").ligerDateEditor({ labelWidth: 100,format: "yyyy-MM-dd", labelAlign: 'left',width:'100' });
      	$("#admissiontime").ligerDateEditor({ labelWidth: 160,format:"yyyy-MM-dd", labelAlign: 'left',width:'160' });
      
   		//表格
        	dataGrid=$("#dataGrid").ligerGrid({
            columns: [
            {display:'姓名', name:'name', width:150, align:'center' },
            {display:'年龄', name:'age', width:150, align:'center' },
            {display:'民族', name:'nation', width:150, align:'center' }
            ],
            pageSize:30,data: null,
            width: 600,
            height:800,
            rownumbers:true, usePager:true,
            onSelectRow : function (data, rowindex, rowobj){
            	loadFamilyInfoData(data, rowindex, rowobj);
            }
        });
       
        familyGrid=$("#familyGrid").ligerGrid({
            columns: [
            { display: '家庭成员姓名', 	name: 'name', width:100, align: 'center',editor:{type:'text'}},
            { display: '关系', 	name: 'relationship', width:100, align: 'center' ,editor:{type:'text'}},
            { display: '工作性质', name: 'workproperty', width:100, align: 'center',editor:{type:'text'}},
            { display: '家庭地址',  name: 'address', width:225, align: 'center',editor:{type:'text'}},
            { display: '联系电话',  name: 'contactphone', width:100, align: 'center',editor:{type:'text'}}
            ],  pageSize:20, 
            width: '900',
            height:'600',
            checkbox: true, //显示选中按钮
            clickToEdit: true,   enabledEdit: true,
            rownumbers: false,usePager: false,
            onSelectRow : function (data, rowindex, rowobj){
                //curDetialRecord=data;
            } , onRClickToSelect:true,
            toolbar: { items:
            	[
            	    { text: '增加', id:'add',click: addItemclick, icon: 'add' },
            	    { line: true },
	                { text: '编辑',  id:'update', click: updateItemclick, icon: 'modify' },
            	    { line: true },
	                { text: '保存',  id:'save',click:saveItemclick,icon: 'ok' }
                ]
            }
          
        });
        
        $("#searchButton").ligerButton({
             text: '查询', width: 60,
	         click: function (){
	        	    var name=$("#nameSearch").val();
		        	var admissiontime=$("#admissiontimeSearch").val();
		        	var graduationtype=$("#graduationtypeSearch").val();
		        	
		        	var params="studentinfo.name="+name+"&studentinfo.admissiontimeString="+admissiontime+"&studentinfo.graduationtype="+graduationtype;
		        	var requestUrl ="scc008/seach.action"; 
		        	var responseMethod="loadDataSet";		
		        	sendRequestForParams_p(requestUrl,responseMethod, params);
	         }
         });
       	 $("#addBtn").ligerButton({
			 text: '新增', width: 100,
			 click: function (){
				if(curpagestate!=3){
        		 	$.ligerDialog.warn("请保存当前信息或刷新本界面后在进行新增操作!");
        		 	return ;
        		}
				curpagestate=1;
				strCurSupperId="";
				$('#dataTable input,#dataTable textarea').val("").attr("readonly",false);
				$("#name").focus();
			 }
		 });
       	 $("#editBtn").ligerButton({
       		 text: '编辑', width: 100,
       		 click: function (){
       			if(curpagestate!=3 || checkNull(strCurSupperId) == ""){
        		 	$.ligerDialog.warn("请保存当前信息或刷新本界面后在进行编辑操作!");
        		 	return ;
        		}
       			curpagestate=2;
       			$('#dataTable input,#dataTable textarea').attr("readonly",false);
       			$("#name").focus();
       		 }
       	 });
        
         $("#saveBtn").ligerButton({
       		 text: '保存', width: 100,
       		 click: function (){
       			if(curpagestate==3){
        		 	$.ligerDialog.warn("未保存数据,无需保存!");
        		 	return;
        		}
        		
       			var id=$("#id").val();
       			var name=$("#name").val();
       			if(name==''){
       			 	$.ligerDialog.warn("姓名不能为空!");
       			 	return;
       			}
       			var age=$("#age").val();
       			if(age=='' || isNaN(age)){
       			 	$.ligerDialog.warn("请输入正确的年龄!");
       			 	return;
       			}
       			var nation=$("#nation").val();
       			if(nation==''){
       			 	$.ligerDialog.warn("请输入民族!");
       			 	return;
       			}
       			var nativeplace=$("#nativeplace").val();
       			if(nativeplace==''){
       			 	$.ligerDialog.warn("请输入籍贯!");
       			 	return;
       			}
       			var educationlevels=$("#educationlevels").val();
       			var sex="";
       			if($("#manSex").attr("checked")==true){
       				sex="1";
       			}else if($("#womanSex").attr("checked")==true){
       				sex="2";
       			}
       			
       			var idcardnumber=$("#idcardnumber").val();
       			if(idcardnumber==''){
       			 	$.ligerDialog.warn("请输入身份证号!");
       			 	return;
       			}
       			
       			var idcardaddress=$("#idcardaddress").val();
       			if(idcardaddress==''){
       			 	$.ligerDialog.warn("请输入身份证地址!");
       			 	return;
       			}
       			var phone=$("#phone").val();
       			if(phone==''){
       			 	$.ligerDialog.warn("请输入手机!");
       			 	return;
       			}
       			var studysubject="";
       			if($("#studysubject1").attr("checked")==true){
       				studysubject="1";
       			}
       			if($("#studysubject2").attr("checked")==true){
       				studysubject="2";
       			}
       			if($("#studysubject2").attr("checked")==true && $("#studysubject1").attr("checked")==true){
       				studysubject="1,2";
       			}
       			if(studysubject==''){
       			 	$.ligerDialog.warn("请输入学习科目!");
       			 	return;
       			}
       			
       			var homephone=$("#homephone").val();
       			if(homephone==''){
       			 	$.ligerDialog.warn("请输入家庭电话!");
       			 	return;
       			}
       			var admissiontime=$("#admissiontime").val();
       			if(admissiontime==''){
       			 	$.ligerDialog.warn("请输入入学时间!");
       			 	return;
       			}
       			var comeschoolway=$("#comeschoolway").val();
       			if(comeschoolway==''){
       			 	$.ligerDialog.warn("请输入来校途径!");
       			 	return;
       			}
       			var expectcompany=$("#expectcompany").val();
       			if(expectcompany==''){
       			 	$.ligerDialog.warn("请输入期望店!");
       			 	return;
       			}
       			var graduationtype=$("#graduationtype").val();

       			var remark=$("#remark").val();
       			
       			var params="studentinfo.id="+id+"&studentinfo.name="+name+"&studentinfo.age="+age+"&studentinfo.nation="+nation;
       			params=params+"&studentinfo.nativeplace="+nativeplace+"&studentinfo.educationlevels="+educationlevels+"&studentinfo.sex="+sex;
       			params=params+"&studentinfo.idcardnumber="+idcardnumber+"&studentinfo.idcardaddress="+idcardaddress+"&studentinfo.phone="+phone;
       			params=params+"&studentinfo.studysubject="+studysubject+"&studentinfo.homephone="+homephone+"&studentinfo.admissiontimeString="+admissiontime;
       			params=params+"&studentinfo.comeschoolway="+comeschoolway+"&studentinfo.expectcompany="+expectcompany+"&studentinfo.graduationtype="+graduationtype;
       			params=params+"&studentinfo.remark="+remark;
       			
       			//params="studentinfo.id=5&studentinfo.name=545&studentinfo.age=54&studentinfo.nation=54&studentinfo.nativeplace=4565&studentinfo.educationlevels=1&studentinfo.sex=1&studentinfo.idcardnumbe=546&studentinfo.idcardaddress=546&studentinfo.phone=546&studentinfo.studysubject=2&studentinfo.homephone=54&studentinfo.admissiontime=2016-01-06"
    	     	var requestUrl ="scc008/addStudent.action"; 
				var responseMethod="addStudentMethod";		
				sendRequestForParams_p(requestUrl,responseMethod,params);
       		 }
       	 });
        $("#pageloading").hide();
        loadData();
	}catch(e){alert(e.message);}
});


function saveItemclick(){
   if(curpageHomestate==3){
	 	$.ligerDialog.warn("未保存数据,无需保存!");
	 	return;
	}
	var params="";
	 if(curpageHomestate==1){    //新增
	      var name=familyGrid.getAdded()[0].name;
	      if(name==''){
  		 	$.ligerDialog.warn("家庭成员姓名不能为空！");
  		 	return;
  		  }
	      var relationship=familyGrid.getAdded()[0].relationship;
	      if(relationship==''){
	  		 	$.ligerDialog.warn("请填写关系！");
	  		 	return;
	  	  }
	      var workproperty=familyGrid.getAdded()[0].workproperty;
	      if(workproperty==''){
	  		 	$.ligerDialog.warn("请填写工作性质！");
	  		 	return;
	  	  }
	      var address=familyGrid.getAdded()[0].address;
	      if(address==''){
	  		 	$.ligerDialog.warn("请填写家庭地址！");
	  		 	return;
	  	  }
	      var contactphone=familyGrid.getAdded()[0].contactphone;
	      if(contactphone==''){
	  		 	$.ligerDialog.warn("请填写联系电话！");
	  		 	return;
	  	  }
	      var stuid=dataGrid.getSelected().id 
	      params="studentfamily.name="+name+"&studentfamily.relationship="+relationship+"&studentfamily.workproperty="+workproperty+"&studentfamily.address="+address+"&studentfamily.contactphone="+contactphone+"&studentfamily.stuid="+stuid;
	 }
    if(curpageHomestate==2){   //修改
    	if(familyGrid.getCheckedRows().length>1){
    		$.ligerDialog.warn("不能批量操作!");
		 	return;
    	}
    	if(familyGrid.getCheckedRows().length == 0){
    		$.ligerDialog.warn("请选择要修改的复选框!");
		 	return;
    	}
    	  var id=familyGrid.getSelected().id;
    	  var name=familyGrid.getSelected().name;
    	  if(name==''){
  		 	$.ligerDialog.warn("家庭成员姓名不能为空！");
  		 	return;
  		  }
	      var relationship=familyGrid.getSelected().relationship;
	      if(relationship==''){
	  		 	$.ligerDialog.warn("请填写关系！");
	  		 	return;
	  	  }
	      var workproperty=familyGrid.getSelected().workproperty;
	      if(workproperty==''){
	  		 	$.ligerDialog.warn("请填写工作性质！");
	  		 	return;
	  	  }
	      var address=familyGrid.getSelected().address;
	      if(address==''){
	  		 	$.ligerDialog.warn("请填写家庭地址！");
	  		 	return;
	  	  }
	      var contactphone=familyGrid.getSelected().contactphone;
	      if(contactphone==''){
	  		 	$.ligerDialog.warn("请填写联系电话！");
	  		 	return;
	  	  }
	      var stuid=dataGrid.getSelected().id 
	      params="studentfamily.id="+id+"&studentfamily.name="+name+"&studentfamily.relationship="+relationship+"&studentfamily.workproperty="+workproperty+"&studentfamily.address="+address+"&studentfamily.contactphone="+contactphone+"&studentfamily.stuid="+stuid;
	 }
 	var requestUrl ="scc008/addStudentFamily.action"; 
	var responseMethod="addStudentFamilyInfoMethod";		
	sendRequestForParams_p(requestUrl,responseMethod,params);
}


function addStudentFamilyInfoMethod(request){
 	try{
        var responsetext = eval("(" + request.responseText + ")");
        var strMessage=responsetext.strMessage;
        if(responsetext.sysStatus==1){	        		 
        	 $.ligerDialog.success(strMessage);
        	 curpageHomestate=3;
        }else{
        	$.ligerDialog.error(strMessage);
        }
        loadData();
    }catch(e){
    	$.ligerDialog.error(e.message);
	}
}


function updateItemclick(){
	if(curpageHomestate!=3 ){
	 	$.ligerDialog.warn("请保存当前信息或刷新本界面后在进行编辑操作!");
	 	return ;
	}
	curpageHomestate=2;
}

function addItemclick(){
    if(curpageHomestate!=3){
	 	$.ligerDialog.warn("请保存当前信息或刷新本界面后在进行新增操作!");
	 	return ;
	}
	curpageHomestate=1;
	
	 var row = familyGrid.getSelectedRow();
	  var newAdd= familyGrid.addRow({ }, row, false);
	  familyGrid.select(newAdd);
}



function addStudentMethod(request){
 	try{
        var responsetext = eval("(" + request.responseText + ")");
        var strMessage=responsetext.strMessage;
        if(responsetext.sysStatus==1){	        		 
        	 $.ligerDialog.success(strMessage);
        	 curpagestate=3;
        }else{
        	$.ligerDialog.error(strMessage);
        }
        loadData();
    }catch(e){
    	$.ligerDialog.error(e.message);
	}
}



function loadData(){   //打开页面加载后台数据
	var requestUrl ="scc008/load.action"; 
	var responseMethod="loadDataSet";		
	sendRequestForParams_p(requestUrl,responseMethod, null);
}

function loadDataSet(request){
	var responsetext = eval("(" + request.responseText + ")");
	var list = responsetext.studentinfoList;
	if(list != null && list.length>0){
		dataGrid.options.data=$.extend(true, {}, {Rows: list,Total: list.length});
		dataGrid.loadData(true);   
		dataGrid.select(0);
	}else{
		dataGrid.options.data=$.extend(true, {},{Rows: null,Total:0});
		dataGrid.loadData(true);
   }
}

function loadFamilyInfoData(data, rowindex, rowobj){
	if(checkNull(data.id)!=""){
		strCurSupperId = data.id;
		$("#id").val(checkNull(data.id));
		$("#name").val(checkNull(data.name));
		$("#age").val(checkNull(data.age));
		$("#nation").val(checkNull(data.nation));
		$("#nativeplace").val(checkNull(data.nativeplace));
		$("#educationlevels").val(checkNull(data.educationlevels));
		
		
		if(data.sex==1){
			$("#manSex").attr("checked",true);
		}else if(data.sex==2){
			$("#womanSex").attr("checked",true);
		}else{
			$("#manSex").attr("checked",false);
			$("#womanSex").attr("checked",false);
		}
		
		$("#idcardnumber").val(checkNull(data.idcardnumber));
		
		$("#idcardaddress").val(checkNull(data.idcardaddress));
		$("#phone").val(checkNull(data.phone));
		
		
		$("#studysubject1").attr("checked","");
		$("#studysubject2").attr("checked","");
		if(data.studysubject==1){
			$("#studysubject1").attr("checked","checked");
		}
		if(data.studysubject==2){
			$("#studysubject2").attr("checked","checked");
		}
		if(data.studysubject=="1,2"){
			$("#studysubject1").attr("checked","checked");
			$("#studysubject2").attr("checked","checked");
		}
		

		//$("#studysubject").val(checkNull(data.studysubject));
		
		$("#homephone").val(checkNull(data.homephone));
		$("#admissiontime").val(checkNull(data.admissiontime.substring(0,10)));
		$("#comeschoolway").val(checkNull(data.comeschoolway));
		$("#expectcompany").val(checkNull(data.expectcompany));
		$("#graduationtype").val(checkNull(data.graduationtype));
		
		$("#remark").val(checkNull(data.remark));
	}
	
	var requestUrl ="scc008/loadFamilInfo.action";
	var params = {"studentinfo.id":data.id};	
	var responseMethod="loadFamilInfo";		
	sendRequestForParams_p(requestUrl,responseMethod, params);
	
	
}

function loadFamilInfo(request){
	var responsetext = eval("(" + request.responseText + ")");
	var list = responsetext.studentfamilyinfo;
	familyGrid.options.data=$.extend(true, {}, {Rows: list,Total: list.length});
	familyGrid.loadData(true);   
	//familyGrid.select(0);          	
}
