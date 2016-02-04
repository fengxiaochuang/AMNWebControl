var masterGrid=null;//学校课程信息表
var detialGrid=null;//职位表
var scc002layout=null;
var curpagestate=3; // 1 add 2 modify 3 browse
//var useSourceDate=[{ choose: 0, text: '美容' }, { choose: 1, text: '美发'}];//类别
var staffPostionData=null;//工作岗位
var positionSet = new Array();

var useSourceDate=parent.gainCommonInfoByCodeByUse("KCLX",0,1);//类别
var useSubjectDate=[{ years:'2011', text: '2011' }, { years: '2012', text: '2012'},{ years:'2013', text: '2013' }, { years: '2014', text: '2014'},
                    { years:'2015', text: '2015' }, { years: '2016', text: '2016'},{ years:'2017', text: '2017' }, { years: '2018', text: '2018'},
                    { years:'2019', text: '2019' }, { years: '2020', text: '2020'}];//类别
//初始化属性
$(function (){
   try{  
	   
	   for(var i = 0; i < useSourceDate.length; i++){
		   $("#type").append("<option value='"+useSourceDate[i].bparentcodekey+"'>"+useSourceDate[i].parentcodevalue+"</option>");
       }
	 //  $("#type").append("<option value='0'>美容</option><option value='1'>美发</option>");//查询条件
	  
	   	
	   	var schoolList = JSON.parse($("#schoolSet").text());//获取合作学校
	    for(var i = 0; i < schoolList.length; i++){
			   $("#schoolName").append("<option value='"+schoolList[i].name+"'>"+schoolList[i].name+"</option>");
	    }
	   	
	   	
	   	staffPostionData=parent.gainCommonInfoByCodeByUse("GZGW",0,1);//工作岗位
	   	$.each(staffPostionData, function(i, common){
	   		positionSet.push({credit_no:0, postion:common.bparentcodekey, score:0});
	   	});
   		//布局
        scc002layout= $("#scc002layout").ligerLayout({ rightWidth: 600,  allowBottomResize: false, allowLeftResize: false,isRightCollapse:true });
   		var height = $(".l-layout-center").height()-30;
   		masterGrid=$("#masterGrid").ligerGrid({
            columns: [
            {display: '', name: 'id', hide:true, isAllowHide:false},
            {display:'类别', name:'type', width:180, align:'center',
            	editor: {type: 'select', data: useSourceDate, valueField: 'bparentcodekey', textField:'parentcodevalue'},
                render: function (item){
                	for(var i = 0; i < useSourceDate.length; i++){
                        if (useSourceDate[i].bparentcodekey == item.type){
                        	return useSourceDate[i].parentcodevalue;
                        }
                    }
                	return item.type;
                }
            },
            {display:'课程编号', name:'no', width:180, align:'center'},
            {display:'课程名称', name:'name', width:260, align:'center', editor:{type:'text'}},
            {display:'课程归属学校', name:'school_no', width:180, align:'center',cssClass:'columnsCss',
            	editor: {type: 'select', data: schoolList, valueField:'no', textField:'name'},//autocomplete:true 
            	render: function (item){
                    for(var i = 0; i < schoolList.length; i++){
                        if (schoolList[i]['no'] == item.school_no)
                            return schoolList[i]['name'];
                    }
                    return item.school_no;
             }},
             {display:'课程学分', name:'score', width:180, align:'center', editor:{type:'text'}},
             {display:'年份', name:'year', width:120, align:'center'
             	, editor:{type:'select',data: useSubjectDate, valueField:'years', textField:'text'}
                  ,render: function (item){
                 	 for(var i = 0; i < useSubjectDate.length; i++){
                          if (useSubjectDate[i].years == item.year){
                          	return useSubjectDate[i]['text'];
                          }
                      }
                 	 return item.year;
                  }
              }
            ],  pageSize:20, 
            data:{Rows: null,Total:0},      
            width: '1150',
            height:height,
            checkbox: true, //显示选中按钮
            clickToEdit: true,   enabledEdit: true,  
            rownumbers: false,usePager: false,
            onSelectRow : function (data, rowindex, rowobj){
            	/*if(checkNull(data.no)!=""){
	            	var params={no: data.no};
	       			var requestUrl ="scc002/loadScore.action"; 
					var responseMethod="loadDetialData";		
					sendRequestForParams_p(requestUrl,responseMethod,params);
            	}*/
            }	   
   		});
   		$("#masterGrid .l-grid-body-inner").css('width', 800);
   		/*detialGrid=$("#detialGrid").ligerGrid({
            columns: [
            {display: '', name: 'credit_no', hide:true, isAllowHide:false},
            {display: '职位', name: 'postion', width:220, align: 'left',
	        	render: function (item){
	          		for(var i=0;i<staffPostionData.length;i++){
						if(staffPostionData[i].bparentcodekey==item.postion){	
							return staffPostionData[i].parentcodevalue;								
					    }
					}
	                return item.position;
	            }},
            {display: '学分', name: 'score', width:220, align: 'left', editor:{type:'text'}}
            ],  pageSize:20, 
            data:{Rows: null,Total:0},      
            width: '440',
            height:height,
            clickToEdit: true,   enabledEdit: true,  checkbox:false,
            rownumbers: false,usePager: false
        });*/
    /*   $("#detialGrid .l-grid-body-inner").css('width', 440).css('height', height-50);*/
       $("#searchButton").ligerButton({
    	   	text: '查询', width: 100,
    	   	click: function (){
    	   		var requestUrl ="scc002/query.action";
	        	var params="name="+$("#subjectName").val()+"&type="+$("#type").val()+"&school_no="+$("#schoolName").val()
	        	
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
				addNewRow();
				/*detialGrid.options.data=$.extend(true, {}, {Rows: positionSet,Total: positionSet.length});
				detialGrid.loadData(true);*/
			 }
       });
       $("#editBtn").ligerButton({
       		 text: '编辑', width: 100,
       		 click: function (){
       			if(curpagestate!=3){
        		 	$.ligerDialog.warn("请保存当前信息或刷新本界面后在进行编辑操作!");
        		 	return ;
        		}
				curpagestate=2;
       		 }
       });
       $("#saveBtn").ligerButton({
       		 text: '保存', width: 100,
       		 click: function (){
       			var creditJson="";
       			if(curpagestate==3){
        		 	$.ligerDialog.warn("未保存数据,无需保存!");
        		 	return;
        		}else if(curpagestate==2){
        			if(masterGrid.getCheckedRows().length>1 ){
        				$.ligerDialog.warn("不能批量操作!");
            		 	return;
        			} 
           			if(masterGrid.getCheckedRows().length==0){
        				$.ligerDialog.warn("请选择编辑的行(复选框)!");
            		 	return;
        			} 
        			
        			creditJson =JSON.stringify(masterGrid.getSelectedRow());
        		}else{
        			creditJson = JSON.stringify(masterGrid.getAdded());
        		}
       			$("#pageloading").show();
       			
       			if(creditJson==""){
       				$.ligerDialog.warn("请重新操作!");
       				$("#pageloading").hide();
       				return;
       			}
       			//creditJson=creditJson.substr(1,(creditJson.length)-2);
       			var jsonObj = eval('(' + creditJson + ')');
       			var idValue="";
       			var nameValue="";
       			var school_noValue="";
       			var scoreValue="";
       			var typeValue="";
       			var noValue="";
       			var yearValue="";
       			for(var p in jsonObj){
       				if(p=='id'){
       					idValue=jsonObj[p];
       				}
       				if(p=='name'){
       					nameValue=jsonObj[p];
       				}
       				if(p=='school_no'){
       					school_noValue=jsonObj[p];
       				}
       				if(p=='score'){
       					scoreValue=jsonObj[p];
       					if(scoreValue=='' || scoreValue == null){
       						$.ligerDialog.warn("请输入学分!");
       						$("#pageloading").hide();
                		 	return;
       					}
       				}
       				if(p=='type'){
       					typeValue=jsonObj[p];
       				}
       				if(p=='no'){
       					noValue=jsonObj[p];
       				}
       				if(p=='year'){
       					yearValue=jsonObj[p];
       				}
       		    }
//       			var idValue=creditJson.id;
//       			var nameValue=creditJson.name;
//       			var school_noValue=creditJson.school_no;
//       			var scoreValue=creditJson.score;
//       			var typeValue=creditJson.type;
//       			var noValue=creditJson.no;
       			var params="";
       			if(curpagestate==2){
       				params="id="+ idValue+"&no="+ noValue+"&name="+ nameValue+"&school_no="+school_noValue+"&score="+scoreValue+"&type="+typeValue+"&year="+yearValue;
       			}else{
       				nameValue=masterGrid.getAdded()[0].name;
       				school_noValue=masterGrid.getAdded()[0].school_no;
       				scoreValue=masterGrid.getAdded()[0].score;
       				typeValue=masterGrid.getAdded()[0].type;
       				yearValue=masterGrid.getAdded()[0].year;
       				if(scoreValue=='' || scoreValue == null){
   						$.ligerDialog.warn("请输入学分!");
   						$("#pageloading").hide();
            		 	return;
   					}
           			params="name="+ nameValue+"&school_no="+school_noValue+"&score="+scoreValue+"&type="+typeValue+"&year="+yearValue;
       			}
       			
       			
       			
       		//	var params="no="+ creditJson ;
       			var requestUrl ="scc002/post.action"; 
				var responseMethod="postMessage";		
				sendRequestForParams_p(requestUrl,responseMethod,params);
       		 }
       });
       $("#pageloading").hide();
       loadData();
	}catch(e){alert(e.message);}
});

function loadData(){
	var requestUrl ="scc002/load.action"; 
	var responseMethod="loadDataSet";		
	sendRequestForParams_p(requestUrl,responseMethod, null);
}

function loadDataSet(request){
	var responsetext = eval("(" + request.responseText + ")");
	var list = responsetext.listSet;
	if(list != null && list.length>0){
		masterGrid.options.data=$.extend(true, {}, {Rows: list,Total: list.length});
		masterGrid.loadData(true);   
		//masterGrid.select(0);          	
	}else{
		masterGrid.options.data=$.extend(true, {},{Rows: null,Total:0});
		masterGrid.loadData(true);
		addNewRow();
		curpagestate=1;
	}
}

/*保存的回调函数*/
function postMessage(request){
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
        curpagestate=3;
        $("#pageloading").hide();
    }catch(e){
    	$.ligerDialog.error(e.message);
	}
}

function addNewRow(){
    var row = masterGrid.getSelectedRow();
//    if(row==null){
//    	$.ligerDialog.warn("请选择添加行的位置(复选框)");
//    	return;
//    }
    
    //参数1:rowdata(非必填)    id\type\no\name\school_no\score
    //参数2:插入的位置 Row Data 
    //参数3:之前或者之后(非必填)
    masterGrid.addRow({ 
    	id:"",
    	type:"",
        no: "",
        name: "",
        school_no:"",
        score:""
    }, row, false);
} 

function loadDetialData(request){
	var responsetext = eval("(" + request.responseText + ")");
	var list = responsetext.scoreList;
	if(list != null && list.length>0){
		//detialGrid.options.data=$.extend(true, {}, {Rows: list,Total: list.length});
	//	detialGrid.loadData(true);   
	}else{
		//detialGrid.options.data=$.extend(true, {},{Rows: null,Total:0});
	//	detialGrid.loadData(true);
	}
}