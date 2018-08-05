<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include flush="true" page="../navigation/uwNavigation.jsp"></jsp:include>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>自主组网</title>
	<!-- Bootstrap core CSS -->
    <link href="resource/css/bootstrap.min.css" rel="stylesheet">
    <link href="resource/css/tuoputu.css" rel="stylesheet">
    <link href="resource/css/nodeInfo.css" rel="stylesheet">
    <link href="resource/css/jquery-confirm.css" rel="stylesheet">
    <script src="resource/js/echarts.js"></script>
    <!--  <script src="http://cdn.bootcss.com/jquery/1.11.1/jquery.min.js"></script>-->
    <script src="resource/js/jquery.min.js"></script>
    <script src="resource/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="resource/js/tuopu.js"></script>
    <script type="text/javascript" src="resource/js/jquery-confirm.js"></script>
    <script type="text/javascript">
   		var nodeListByType;
   		var nodeList;
   		var flag = false;
   		var flag1 = false;
		$(function(){
            setTimeout(function(){
          		myChart.hideLoading();
             },1500);
            setInterval(function(){
            	if (flag == true) {
            		startChart();
            	}
            },2000);
            setInterval(function(){
            	if (flag1 == true) {
            		startChart1();
            	}
            },1000);
			if(window.location.pathname=="/WSN/fileUpload.wsn"){
				showDownloadDialog();
			};
			getNodeListByType(1,10);
			getNodeList(1,15);
			for(var j=0;j<nodeList.length;j++){
				if(nodeList[j].download==true){
					$("#burnProtocol").attr("disabled",false);
				}
				if(nodeList[j].burner==true){
					$("#nodeReset").attr("disabled",false);
			    	$("#topological").attr("disabled",false);
				}
			}
			if($("#burnerFinished").val()=='true'){
				$.dialog({
	        	    title: '正在组网...',
	        	    content: "<div class='progress'><div class='progress-bar progress-bar-info progress-bar-striped active' role='progressbar' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width: 100%''><span class='sr-only'>100% Complete</span></div></div>",
	        	});
				waitForNetworkingFinished();
			}
			
		});    
    
      	function startOrStop() {
      		if ($("#startOrStop").text()=="开始绘图") {
          		$("#startOrStop").text("暂停绘图");
          		flag = true;
      		}
      		else if ($("#startOrStop").text()=="暂停绘图") {
          		$("#startOrStop").text("开始绘图");
          		flag = false;
      		}
      	}
      	
      	function startOrStop1() {
      		if ($("#startOrStop1").text()=="开始绘图") {
          		$("#startOrStop1").text("暂停绘图");
          		flag1 = true;
      		}
      		else if ($("#startOrStop1").text()=="暂停绘图") {
          		$("#startOrStop1").text("开始绘图");
          		flag1 = false;
      		}
      	}
      	
      	function startChart() {
      		$.ajax({
      			url:'getNetUwData.json',
      			type:'post',
      			cache:false,
      			dataType:'json',
      			async:false,
      			success:function(data) {
      				var uwDataList = data.uwDataList;
      				var netData   = [];
      				for (var i=0; i<uwDataList.length; i++) {
      					if (uwDataList[i].dataType == 'N') {
      						netData.push(uwDataList[i].point);
      					}
      				}
      	  		  	myChart.setOption({
      				  	series: [
      				  		{name: 'NET',data: netData}
      				    ],
      		    	    xAxis: {
      		    	        min: 0,
      		    	        max: data.max
      		    	    },
      		    	    dataZoom: [
      		    	        {
      		    	            type: 'slider',
      		    	            xAxisIndex: [0],
      		    	            startValue: data.startValue,
      		    	            endValue: data.endValue
      		    	        }
      		    	    ],
      			    });
      			}
      		});
      	}
      	
      	function startChart1() {
      		$.ajax({
      			url:'getUwTopology.json',
      			type:'post',
      			cache:false,
      			dataType:'json',
      			async:false,
      			success:function(data) {
      				var nodeList = data.nodeList;
      				for (var i=0; i<nodeList.length; i++) {
      					if (nodeList[i].nodeId != 'null') {
          					nodeData.push({
          		      			name: nodeList[i].nodeType + nodeList[i].nodeId,
          		      			id: nodeList[i].nodeId,
          		      			symbolSize: 30
          		      		});
      					};
      					if (nodeList[i].parentId != 'null') {
          					edges.push({
          		      			source: nodeList[i].nodeId,
								target: nodeList[i].parentId
          		      		});
      					};
      				};
      	      		myChart1.setOption({
      	      	        series: [{
      	      	        	label: {
      	      	                normal: {
      	      	                    show: true
      	      	                }
      	      	            },
      	      	            roam: 'move',
      	      	            data: nodeData,
      	      	            edges: edges
      	      	        }]
      	      		});
      			}
      		});
      	}
      	
   		//获取组网信息
	    function getNodeList(page,pageSize){
	    	 $.ajax( { 
				    url:'getNodeList.json',// 跳转到 controller 
				    type:'post', 
				    cache:false, 
				    dataType:'json', 
				    async: false,
				    success:function(data) { 
				    	//curPage = page;
				    	//curPageSize = pageSize;
				    	 nodeList = data.nodeList
				    	var html = "";
				    	var sumPage=0;
				    	var paginationHtml="";
				    	var next = page+1;
				    	var previous = page-1;
				    	var order=0;
				    	for(var i=(page-1)*pageSize;i<nodeList.length&&i<page*pageSize;i++){
				    		order = i+1;
				    		html +="<tr><td>"+order+"</td><td>"+nodeList[i].nodeId+"</td><td>"+nodeList[i].parentId+"</td>";
				    		//根据不同的节点类型显示不同的颜色
				    		if(nodeList[i].nodeType=="gatewayNode"){
				    			html+= "<td><span class='reda'>"+nodeList[i].nodeType+"</span></td>";
				    		}else if(nodeList[i].nodeType=="clusterHeadNode"){
				    			html+= "<td><span class='bluea'>"+nodeList[i].nodeType+"</span></td>";
				    		}else if(nodeList[i].nodeType=="attackNode"){
				    			html+= "<td><span class='reda'>"+nodeList[i].nodeType+"</span></td>";
				    		}else{
				    			html+= "<td>"+nodeList[i].nodeType+"</td>";
				    		}
				    	}
				    	$("#nodeList").html(html);
				    	if(nodeList.length%pageSize==0){
				    		sumPage = Math.floor(nodeList.length/pageSize);
				    	}else{
				    		sumPage = Math.floor(nodeList.length/pageSize)+1;
				    	}
				    	if(page==1){
				    		if(previous<=0){
				    			paginationHtml+="<li class='disabled'><a href='#'>"+"<<"+"</a></li>";
				    		}else{
				    			paginationHtml+="<li class='disabled'><a href='#' onclick='getNodeList("+previous+","+pageSize+")'>"+"<<"+"</a></li>";
				    		}
				    	}else{
				    		paginationHtml+="<li><a href='#' onclick='getNodeList("+previous+","+pageSize+")'>"+"<<"+"</a></li>";
				    	}
				    	for(var j=1;j<=sumPage;j++){
				    		if(j==page){
				    			paginationHtml+="<li class='active'><a href='#' onclick='getNodeList("+j+","+pageSize+")'>"+j+"</a></li>";
				    		}else{
				    			paginationHtml+="<li><a href='#' onclick='getNodeList("+j+","+pageSize+")'>"+j+"</a></li>";
				    		}
				    	}
				    	if(page==sumPage){
				    		if(next>sumPage){
				    			paginationHtml+="<li class='disabled'><a href='#'>"+">>"+"</a></li>";
				    		}else{
				    			paginationHtml+="<li class='disabled'><a href='#' onclick='getNodeList("+next+","+pageSize+")'>"+">>"+"</a></li>";
				    		}
				    	}else{
				    		paginationHtml+="<li><a href='#' onclick='getNodeList("+next+","+pageSize+")'>"+">>"+"</a></li>";
				    	}
				    	$("#pagination_net").html(paginationHtml);
				    	
				    }, 
				    error : function() { 
				    	 $.alert({
		                      title: 'Oh no',
		                      type: 'red',
		                      content: '系统异常'
		                  });  
				     } 
				});
   		}
  
	    //根据类型获取列表
	    function getNodeListByType(page,pageSize){
	    	$.ajax( { 
			    url:'getNodeListByType.json',// 跳转到 controller 
			    type:'post', 
			    cache:false, 
			    data:{
			    	nodeType:$("#nodeType").val()
			    },
			    dataType:'json', 
			    async: false,
			    success:function(data) {
			    	//$("#downloadList").html("");
			    	nodeListByType = data.nodeList;
			    	var html = "";
			    	var sumPage=0;
			    	var paginationHtml="";
			    	var next = page+1;
			    	var previous = page-1;
			    	var order=0;
			    	for(var i=(page-1)*pageSize;i<nodeListByType.length&&i<page*pageSize;i++){
			    		order = i+1;
			    		html +="<tr><td>"+order+"</td><td>"+nodeListByType[i].nodeId+"</td>";
			    		//根据是否下载协议显示不同颜色
			    		if(nodeListByType[i].download==false){
			    			html+= "<td><span class='reda'>"+nodeListByType[i].download+"</span></td>";
			    		}else{
			    			html+= "<td>"+nodeListByType[i].download+"</td>";
			    		}
			    		
			    		//根据是否烧录协议显示不同颜色
			    		if(nodeListByType[i].burner==false){
			    			html+= "<td><span class='reda'>"+nodeListByType[i].burner+"</span></td>";
			    		}else{
			    			html+= "<td>"+nodeListByType[i].burner+"</td>";
			    		}
			    		
			    	}
			    	$("#downloadList").html(html);
			    	if(nodeListByType.length%pageSize==0){
			    		sumPage = Math.floor(nodeListByType.length/pageSize);
			    	}else{
			    		sumPage = Math.floor(nodeListByType.length/pageSize)+1;
			    	}
			    	if(page==1){
			    		if(previous<=0){
			    			paginationHtml+="<li class='disabled'><a href='#'>"+"<<"+"</a></li>";
			    		}else{
			    			paginationHtml+="<li class='disabled'><a href='#' onclick='getNodeListByType("+previous+","+pageSize+")'>"+"<<"+"</a></li>";
			    		}
			    	}else{
			    		paginationHtml+="<li><a href='#' onclick='getNodeListByType("+previous+","+pageSize+")'>"+"<<"+"</a></li>";
			    	}
			    	for(var j=1;j<=sumPage;j++){
			    		if(j==page){
			    			paginationHtml+="<li class='active'><a href='#' onclick='getNodeListByType("+j+","+pageSize+")'>"+j+"</a></li>";
			    		}else{
			    			paginationHtml+="<li><a href='#' onclick='getNodeListByType("+j+","+pageSize+")'>"+j+"</a></li>";
			    		}
			    	}
			    	if(page==sumPage){
			    		if(next>sumPage){
			    			paginationHtml+="<li class='disabled'><a href='#'>"+">>"+"</a></li>";
			    		}else{
			    			paginationHtml+="<li class='disabled'><a href='#' onclick='getNodeListByType("+next+","+pageSize+")'>"+">>"+"</a></li>";
			    		}
			    	}else{
			    		paginationHtml+="<li><a href='#' onclick='getNodeListByType("+next+","+pageSize+")'>"+">>"+"</a></li>";
			    	}
			    	$("#pagination").html(paginationHtml);
			    }, 
			    error : function() { 
			    	 $.alert({
	                      title: 'Oh no',
	                      type: 'red',
	                      content: '系统异常'
	                  });  
			     }
    	 });
	    }
	    //刷新列表一
	    function refreshList1(){
	    	getNodeListByType(1,10);
	    }
	    //刷新列表二
	    function refreshList2(){
	    	getNodeList(1,15);
	    }
	    //点击协议下载按钮
	   function sub(){
		   if($("#InputFile").val()==""){
			   $("#warning").text("请选择协议文件！");
			   return;
		   }
		   var down=false;
			for(var j=0;j<nodeListByType.length;j++){
				if(nodeListByType[j].download==true){
					down = true;
					break;
				}
			}
			if(down==true){
				$.confirm({
				    title: '注意!',
				    content: '节点已下载协议，是否重新下载',
				    animation: 'zoom',
		            animationClose: 'top',
				    buttons: {
				        	确定: function () {
				        	$.ajax( { 
							    url:'reDownloadProtocol.json',// 跳转到 controller 
							    type:'post', 
							    cache:false, 
							    data:{
							    	nodeType:$("#nodeType").val()
							    },
							    dataType:'json', 
							    async: false,
							    success:function(data) {
							    	var type = $("#nodeType").val();
							    	$("#input_node_type").val(type);
							    	$("#selectProtocol").submit();
							    }, 
							    error : function() { 
							    	 $.alert({
					                      title: 'Oh no',
					                      type: 'red',
					                      content: '系统异常'
					                  });  
							     }
				    	 	});	
				        },
				                        取消: function () {
				            return;
				        }
				    }
				});
			}else{
				var type = $("#nodeType").val();
		    	$("#input_node_type").val(type);
		    	$("#selectProtocol").submit();
			}
		   
	    	
	    }
	   //打开协议下载提示窗口
	   var num=0;
	   function showDownloadDialog(){
           $.dialog({
        	    title: "正在下载协议...",
        	    content: "<div class='progress'><div class='progress-bar progress-bar-info progress-bar-striped active' role='progressbar' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width: 100%''><span class='sr-only'>100% Complete</span></div></div>",
        	});
		   refresh(num);
	   }
	   //定时刷新列表
	   function refresh(i){
			if(i<50){
				getNodeListByType(1,10);
				num = num +1;
				var down=true;
				for(var j=0;j<nodeListByType.length;j++){
					if(nodeListByType[j].download==false){
						down = false;
						break;
					}
				}
				if(down==false){
					setTimeout('refresh('+num+')',2000);
				}else{
					num = 0;
					window.location.href="networking.wsn?downloadNodeType="+$("#nodeType").val();
				}
				
			}else{
				num = 0;
				window.location.href="networking.wsn?downloadNodeType="+$("#nodeType").val();
			}
		   
		} 
	    //刷新烧录信息列表
		function refresh_burner(i){
			if(i<60){
				getNodeListByType(1,10);
				num = num +1;
				var down=true;
				for(var j=0;j<nodeList.length;j++){
					if(nodeList[j].burner==false){
						down = false;
						break;
					}
				}
				if(down==false){
					setTimeout('refresh_burner('+num+')',2000);
				}else{
					num = 0;
					window.location.href="networking.wsn?burnerFinished=true";
				}
				
			}else{
				num = 0;
				window.location.href="networking.wsn?burnerFinished=true";
				
			}		
		}
	    //让网关节点对应的socket接受组网结束标志
	    function waitForNetworkingFinished(){
	    	$.ajax( { 
			    url:'waitForNetworkingFinished.json',// 跳转到 controller 
			    type:'post', 
			    data:{
			    	orderType:'waitingForNetworkingFinished'
			    },
			    cache:false, 
			    dataType:'json', 
			    async: false,
			    success:function(data) {
			    	num = 0;
			    	refresh_net(num);
			    }, 
			    error : function() { 
			    	 $.alert({
	                      title: 'Oh no',
	                      type: 'red',
	                      content: '系统异常'
	                  });  
			     }
    	 	});	
	    }
	    
	    
	    
		//刷新组网情况信息列表
		var flag = false;
		function refresh_net(i){
			if(i<140){
				num = num+1;
				getNetWorkingFlag();
				if(flag == true || flag=="true"){
					$.ajax( { 
					    url:'getNodeParentId.json',// 跳转到 controller 
					    type:'post', 
					    data:{
					    	orderType:'networkingInformation'
					    },
					    cache:false, 
					    dataType:'json', 
					    async: false,
					    success:function(data) {
					    	setTimeout('fresh()',2000);
					    }, 
					    error : function(){ 
					    	 $.alert({
			                      title: 'Oh no',
			                      type: 'red',
			                      content: '系统异常'
			                  });  
					     }
		    	 	});	
					num = 0;
				}else{
					setTimeout('refresh_net('+num+')',1000);
				}
			}else{
		    	 $.alert({
	                     title: 'Oh no',
	                     type: 'red',
	                     content: '组网失败！'
	             });  
				num = 0;
			}
		}
	    //刷新页面
	    function fresh(){
	    	window.location.href="networking.wsn";
	    }
		
	    //获取组网是否完成标志
	    function getNetWorkingFlag(){
	    	$.ajax( { 
			    url:'getNetWorkingFlag.json',// 跳转到 controller 
			    type:'post', 
			    cache:false, 
			    dataType:'json', 
			    async: false,
			    success:function(data) {
			    	//alert(data.netWorkingFlag);
					flag = data.netWorkingFlag;
			    }, 
			    error : function(){ 
			    	 $.alert({
	                      title: 'Oh no',
	                      type: 'red',
	                      content: '系统异常'
	                  });  
			     }
    	 	});	
	    }
	    
	   //协议烧录
	   function burn_protocol(){
		   $.ajax( { 
			    url:'burnProtocol.json',// 跳转到 controller 
			    type:'post', 
			    cache:false, 
			    data:{
			    	orderType:'burnProtocol'
			    },
			    dataType:'json', 
			    async: false,
			    success:function(data) {
			    	$.dialog({
		        	    title: '正在烧录协议...',
		        	    content: "<div class='progress'><div class='progress-bar progress-bar-info progress-bar-striped active' role='progressbar' aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width: 100%''><span class='sr-only'>100% Complete</span></div></div>",
		        	});
			    	num=0;
			    	getNodeList(1,15);  //此处调用该函数是为了获取最新的nodeList
			    	refresh_burner(num);
			    },
			    error : function() { 
			    	 $.alert({
	                      title: 'Oh no',
	                      type: 'red',
	                      content: '系统异常'
	                  });  
			     }
   	 	 });
	  }
	   //节点复位
	  function node_reset(){
		  $.ajax( { 
			    url:'nodeReset.json',// 跳转到 controller 
			    type:'post', 
			    cache:false, 
			    data:{
			    	orderType:'nodeReset'
			    },
			    dataType:'json', 
			    async: false,
			    success:function(data) {
			    	$("#nodeReset").attr("disabled",true);
			    	$("#topological").attr("disabled",true);
			    	//$("#burnProtocol").attr("disabled",true);
			    },
			    error : function() { 
			    	 $.alert({
	                      title: 'Oh no',
	                      type: 'red',
	                      content: '系统异常'
	                  });  
			     }
 	 	 });
	   }  
    </script>
   
</head>
<body>
	<!-- 隐藏的变量 -->
	<input type="hidden" id="burnerFinished" value=${burnerFinished}>
	<input type="hidden" id="downloadNodeType" value=${downloadNodeType}>


	  <!-- Main jumbotron for a primary marketing message or call to action -->
	
    <div class="jumbotron">
      <div id='networking'>
      <div class="container">
      	<div class="row">
        	<div class="col-md-6">
        		<h3>组网准备</h3>
				<form role="form" id="selectProtocol" action="fileUpload.wsn" method="post" enctype="multipart/form-data">
				  <div class="form-group">
				       <label for="nodeType">节点类型</label>
				       
				       <c:choose>
			          		<c:when test="${nodeType=='commonNode'}">
			          			<select class="form-control" id="nodeType" onChange="getNodeListByType(1,10)">
								    <option >commonNode</option>
								    <option>clusterHeadNode</option>
								    <option>gatewayNode</option>
								    <option>attackNode</option>
							    </select>
			          	 	</c:when>
			          	 	<c:when test="${nodeType==null}">
				          	 	<select class="form-control" id="nodeType" onChange="getNodeListByType(1,10)">
									  <option >commonNode</option>
									  <option>clusterHeadNode</option>
									  <option>gatewayNode</option>
									  <option>attackNode</option>
								</select>
			          	 	</c:when>
			          	 	<c:when test="${nodeType=='clusterHeadNode'}">
				          	 	<select class="form-control" id="nodeType" onChange="getNodeListByType(1,10)">
									  <option >commonNode</option>
									  <option selected>clusterHeadNode</option>
									  <option>gatewayNode</option>
									  <option>attackNode</option>
								</select>
			          	 	</c:when>
			          	 	<c:when test="${nodeType=='gatewayNode'}">
				          	 	<select class="form-control" id="nodeType" onChange="getNodeListByType(1,10)">
									  <option >commonNode</option>
									  <option >clusterHeadNode</option>
									  <option selected>gatewayNode</option>
									  <option>attackNode</option>
								</select>
			          	 	</c:when>
			          		<c:otherwise>
			          			 <select class="form-control" id="nodeType" onChange="getNodeListByType(1,10)">
									  <option >commonNode</option>
									  <option >clusterHeadNode</option>
									  <option >gatewayNode</option>
									  <option selected>attackNode</option>
								</select>
			          		</c:otherwise>
			          	</c:choose>
				  </div>
				   <div class="form-group">
				     <input type="hidden" name="nodeType" id="input_node_type">
				  </div>
				 
				  <div class="form-group">
				    <label for="InputFile">选择协议文件</label>
				    <input type="file" id="InputFile" name = "file"><span style="color:red;" id="warning"></span>
				  </div>
				  <button type="button" class="btn btn-primary" onclick="sub()">协议下载</button>
				  <button type="button" class="btn btn-warning" disabled="disabled" id="burnProtocol" onclick="burn_protocol()">协议烧录</button>
			      <button type="button" class="btn btn-danger" disabled="disabled" id="nodeReset" onclick="node_reset()">节点复位</button>
			      <a type="button" class="btn btn-success" href="#container" onclick="show()" id="topological">拓扑图</a>
				</form>
				<br><br>
				<div class="pull-right">
          			<button type="button" class="btn btn-success btn-sm" onclick="refreshList1()">刷新</button>
          		</div>
				<table class="table table-hover table-striped">
		        	<thead>
		              <tr>
		                <th>序号</th>
		                <th>节点id</th>
		                <th>是否下载协议</th>
		                <th>是否烧录协议</th>
		              </tr>
		            </thead>
		            <tbody id="downloadList">
		            </tbody>
				</table>
			 	<div class="pull-right">
					<nav>
					  <ul class="pagination" id="pagination">
					  </ul>
					</nav>
				</div>
				       		
        	</div>
        	<div class="col-md-6">
          		<h3>网络拓扑信息</h3>
          		<div class="pull-right">
          			<button type="button" class="btn btn-success btn-sm" onclick="refreshList2()">刷新</button>
          		</div>
          		<table class="table table-bordered table-hover table-striped">
		        	<thead>
		              <tr>
		                <th>序号</th>
		                <th>节点id</th>
		                <th>父节点id</th>
		                <th>节点类型</th>
		              </tr>
		            </thead>
		            <tbody id="nodeList">
		            </tbody>
				</table>
		 		<div class="pull-right">
					<nav>
					  <ul class="pagination" id="pagination_net">
					  </ul>
					</nav>
				</div>
       	 </div>
      </div>
     </div>
    </div>
    </div>
    
    <div class="container theme-showcase" role="main">
	  <div class="pull-right">
	    <button type="button" class="btn btn-primary btn-sm" onclick="startOrStop()" id="startOrStop">开始绘图</button>
	  </div>
	</div>
    <div id="chart" style="width:1900px;height:650px;"></div>
    <script type="text/javascript">
      var myChart = echarts.init(document.getElementById('chart'));
      myChart.setOption({
    	    xAxis: {
    	    	name: '时间',
    	        min: 0,
    	        max: 60,
    	        interval: 10,
    	        type: 'value',
    	        axisLine: {onZero : false},
    	        splitLine: {show: false}
    	    },
    	    yAxis: {
    	    	name: '节点',
    	    	nameLocation: 'start',
    	    	inverse: true,
    	        min: 0,
    	        max: 100,
    	        interval: 1,
    	        type: 'value',
    	        axisLine: {onZero : false}
    	    },
    	    legend: {
    	    	data: [
    	    		{
	    	    	    name: 'NET',
	    	    	    icon: 'rect',
	    	    	    textStyle: {color: 'black'}
    	    		}
    	    	],
    	    	left: 'center'
    	    },
    	    tooltip : {
    	        showDelay : 0,
    	        formatter : function (params) {
    	        	return '时间：' + params.value[0] + 's<br/>' + '节点id：' + params.value[1] + '<br/>'
    	        	+ '数据类型：' + params.seriesName;
    	        },
    	        axisPointer:{
    	            show: true,
    	            type: 'cross',
    	            lineStyle: {
    	                type: 'dashed',
    	                width: 1
    	            }
    	        }
    	    },
    	    dataZoom: [
    	        {
    	            type: 'slider',
    	            show: true,
    	            zoomLock: true,
    	            showDetail: false,
    	            xAxisIndex: [0],
    	            startValue: 0,
    	            endValue: 60
    	        },
    	        {
    	            type: 'slider',
    	            show: true,
    	            zoomLock: true,
    	            showDetail: false,
    	            left: '120',
    	            yAxisIndex: [0],
    	            start: 0,
    	            end: 10
    	        }
    	    ],
    	    series: [
    	    	{
	    	        name: 'NET',
	    	        type: 'scatter',
	    	        symbol: 'rect',
	    	        symbolSize: [30,10],
	    	        symbolOffset: ['-50%',0],
	    	        itemStyle: {
	    	        	normal: {
	    	        		color: 'black'
	    	        	}
	    	        },
	    	        label: {
	    	        	normal: {
	    	        		show: true,
	    	        		position: 'top',
	    	        		color: 'black',
	    	    	        formatter : function (params) {
	    	    	        	return params.value[2] + '→' + params.value[3] + '\n' + params.seriesName;
	    	    	        },
	    	        	}
	    	        },
	    	        data: []
    	    	}
    	    ]
    	});
      myChart.showLoading();
    </script>
    
    
    <div  align="center">
        <h2>拓扑图展示</h2>
    </div> 
    <div class="container theme-showcase" role="main">
	  <div class="pull-right">
	    <button type="button" class="btn btn-primary btn-sm" onclick="startOrStop1()" id="startOrStop1">开始绘图</button>
	  </div>
	</div>
    <div id="chart1" style="width:1900px;height:900px;"></div>
    <script type="text/javascript">
      var myChart1 = echarts.init(document.getElementById('chart1'));
      var buoyData = [{
    	    fixed: true,
    	    x: myChart1.getWidth() / 2,
    	    y: myChart1.getHeight() / 2,
    	    symbolSize: 50,
    	    id: '0'
    	}];
      var gatewayData = [];
      var commonData = [];
      var nodeData = [];
      var edges = [];
      myChart1.setOption({
    	    series: [{
    	    	name: 'buoy',
    	        type: 'graph',
    	        layout: 'force',
    	        animation: false,
    	        //draggable: true,
    	        data: nodeData,
    	        force: {
    	            repulsion: 500,
    	            edgeLength: 100
    	        }
    	    }]
    	});
      //myChart1.showLoading();
    </script>
</body>
</html>