<%@ page import="com.nou.aut.AUTICFM, com.acer.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../include/pages/checkUser.jsp" %>
<%@ include file="../../include/pages/query.jsp" %>
<%@ include file="../../include/pages/query1_1_0_2.jsp" %>
<%
	/** 學校類別 */	
	String	ASYS = (String)session.getAttribute("ASYS");
	if("1".equals(ASYS)){
		session.setAttribute("CCS110M_1_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('5','6','7','8','10','11') ORDER BY TO_NUMBER(SELECT_VALUE), SELECT_TEXT ");
	}else if("2".equals(ASYS)){
		session.setAttribute("CCS110M_1_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('6','7','8','10','11') ORDER BY TO_NUMBER(SELECT_VALUE), SELECT_TEXT ");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>list</title>
    <script language="javascript">
<!--
	
		
	
	/** 初始設定頁面資訊 */
	var	printPage		=	"/ccs/ccs110m/_01p1";	//列印頁面
	var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
	var	lockColumnCount		=	-1;				//鎖定欄位數
	var	listShow		=	true;				//是否一進入顯示資料
	var	_privateMessageTime	=	-1;				//訊息顯示時間(不自訂為 -1)
	var	pageRangeSize		=	10;				//畫面一次顯示幾頁資料
	var	controlPage		=	"_01c2";	//控制頁面
	var	checkObj		=	new checkObj();			//核選元件
	var	queryObj		=	new queryObj();			//查詢元件
	var	importSelect		=	false;				//匯入選取欄位功能
	var	noPermissAry		=	new Array();			//沒有權限的陣列
	
	/** 網頁初始化 */
	function page_init(loadTime)
	{
		if (loadTime != "second")
			page_init_start();
	
		editMode	=	"NONE";
		/** 權限檢核 */
		securityCheck();
		
		/** === 初始欄位設定 === */
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		Form.iniFormSet('QUERY', 'STNO', 'D', 1,'S',9);	
		Form.iniFormSet("RESULT", "SAVE_BTN", "D", 1);
		
		if (loadTime != "second"){
			page_init_end();
		}	
		
	}
	
	/**
	初始化 Grid 內容
	@param	stat	呼叫狀態(init -> 網頁初始化)
	*/
	function iniGrid(stat)
	{
		var	gridObj	=	new Grid();

		iniGrid_start(gridObj)
	
		/** 設定表頭 */
		gridObj.heaherHTML.append
		(
			"<tr class=listHeader align=center>\
					<td width=20>&nbsp;</td>\
					<td resize='on' nowrap>學制</td>\
					<td resize='on' nowrap>學號</td>\
					<td resize='on' nowrap>姓名</td>\
					<td resize='on' nowrap>學年期</td>\
					<td resize='on' nowrap>科目代號</td>\
					<td resize='on' nowrap>科目名稱</td>\
					<td resize='on' nowrap>學分數</td>\
				</tr>"
		);
	
		if (stat == "init" && !listShow)
		{
			/** 初始化及不顯示資料只秀表頭 */
			document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
			Message.hideProcess();
		}
		else
		{
			/** 頁次區間同步 */
			Form.setInput ("QUERY", "pageSize",	Form.getInput("RESULT", "_scrollSize"));
			Form.setInput ("QUERY", "pageNo",	Form.getInput("RESULT", "_goToPage"));
	
			/** 處理連線取資料 */
			var	callBack	=	function (ajaxData)
			{
				if (ajaxData == null)
					return;
	
				/** 設定表身 */
				var	keyValue	=	"";
				var	editStr		=	"";
				var	delStr		=	"";
				var	exportBuff	=	new StringBuffer();
				var style = "";	
				for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
				{
					keyValue	=	"ASYS|" + ajaxData.data[i].ASYS + 
									"|NOW_AYEAR|" + Form.getInput("QUERY", "NOW_AYEAR") +
									"|NOW_SMS|" + Form.getInput("QUERY", "NOW_SMS") + 
									"|NOW_STNO|" + Form.getInput("QUERY", "STNO") + 
									"|APP_SEQ|" + Form.getInput("QUERY", "APP_SEQ") + 
									"|HEDU_TYPE|" +  Form.getInput("QUERY", "HEDU_TYPE") + 
									"|AYEAR|" + ajaxData.data[i].AYEAR +
									"|SMS|" + ajaxData.data[i].SMS + 
									"|STNO|" + ajaxData.data[i].STNO + 								
									"|CRSNO|" + ajaxData.data[i].CRSNO + 								
									"|CRD|" + ajaxData.data[i].CRD + 
									"|CRSNO_UNIV|" + ajaxData.data[i].CRSNO_UNIV + 								
									"|CRD_UNIV|" + ajaxData.data[i].CRD_UNIV +
									"|SCHOOL_TYPE|" + ajaxData.data[i].SCHOOL_TYPE + 
									"|GRADE_OLD|" + ajaxData.data[i].GRADE_OLD + 
									"|SMS_OLD|" + ajaxData.data[i].SMS_OLD + 
									"|GRAD_TYPE|" + ajaxData.data[i].GRAD_TYPE + 
									"|GRAD_GRADE|" + ajaxData.data[i].GRAD_GRADE + 
									"";						
					
					if( ajaxData.data[i].GEL_CHK =='N' ){
						style = "disabled";
					}else{
						style = "";
					}
					
					gridObj.gridHtml.append
					(
						"<tr class=\"listColor0" + ((gridObj.rowCount % 2) + 1) + "\" onmouseover='OMOver(this);' onmouseout='OMOut"+((gridObj.rowCount % 2) + 1)+"(this);'>\
							<td align=center><input type=checkbox name='chkBox' value=\"" + keyValue + "\"  "+style+" >&nbsp;</td>\
							<td>" + ajaxData.data[i].ASYS_NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].STNO + "&nbsp;</td>\
							<td>" + ajaxData.data[i].NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].AYEAR_NAME + ajaxData.data[i].SMS_NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRSNO + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRS_NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRD + "&nbsp;</td>\
						</tr>"
					);
	
					exportBuff.append
					(
						ajaxData.data[i].STNO + "," + 
						ajaxData.data[i].CRSNO + "\r\n"
					);
				}
				gridObj.gridHtml.append ("<tr></tr>");
	
				/** 無符合資料 */
				if (ajaxData.data.length == 0){
					gridObj.gridHtml.append ("<font color=red><b>　　　請選擇學校類別帶出資料後儲存!!</b></font>");
					Form.iniFormSet("RESULT", "SAVE_BTN", "D", 1);
				}else{
					Form.iniFormSet("RESULT", "SAVE_BTN", "D", 0);
				}			
				iniGrid_end(ajaxData, gridObj, keyValue);
			}
			sendFormData("QUERY", controlPage, "QUERY_MODE", callBack,false);		
		}
	}
	
	/** 處理匯出動作 */
	function doExport(type)
	{
		var	header		=	"SEQ, CRSNO, CLASS_CODE, STNO, BATCH_NO1, MARK1, KEYIN_USER_ID1, MARK2, KEYIN_USER_ID2, MARK3\r\n";
		
		/** 處理匯入功能 匯出種類, 標題, 一次幾筆, 程式名稱, 寬度, 高度 */
		processExport(type, header, 4, 'ccs110m_', 500, 200);
	}
	
	/** 查詢功能時呼叫 */
	function doQuery()
	{
		doQuery_start();
	
		/** === 自定檢查 === */
		/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
		//if (Form.getInput("QUERY", "SYS_CD") == "")
		//	Form.errAppend("系統編號不可空白!!");
		/** ================ */
	
		return doQuery_end();
	}
	
	/** 新增功能時呼叫 */
	function doAdd()
	{
		/** 開啟新增 Frame */
		top.showView();
	
		/** 呼叫新增 */
		top.viewFrame.doAdd();
	}
	
	/** ============================= 欲修正程式放置區 ======================================= */
	/** 設定功能權限 */
	function securityCheck()
	{
		try
		{
			/** 查詢 */
			if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
			{
				noPermissAry[noPermissAry.length]	=	"QRY";
				try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
			}
			/** 新增 */
			if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"ADD";
				editMode	=	"NONE";
				try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
			}
			/** 修改 */
			if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"UPD";
			}
			/** 新增及修改 */
			if (!chkSecure("ADD") && !chkSecure("UPD"))
			{
				try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
			}
			/** 刪除 */
			if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
			{
				noPermissAry[noPermissAry.length]	=	"DEL";
				try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
			}
			/** 匯出 */
			if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
			{
				noPermissAry[noPermissAry.length]	=	"EXP";
				try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
			}
			/** 列印 */
			if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
			{
				noPermissAry[noPermissAry.length]	=	"PRT";
				try{Form.iniFormSet("RESULT", "PRT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
			}
		}
		catch (ex)
		{
		}
	}
	
	/** 檢查權限 - 有權限/無權限(true/false) */
	function chkSecure(secureType)
	{
		if (noPermissAry.toString().indexOf(secureType) != -1)
			return false;
		else
			return true
	}
	/** ====================================================================================== */
	
	function doSave()
	{
		if (!confirm("確定採認?")){
			return;
		}
		/** 開始處理 */
		Message.showProcess();
	
		checkObj.setResultKey();
		
		/** 處理連線取資料 */
		var	callBack	=	function (ajaxData)
		{
			/** 結束處理 */
			Message.hideProcess();	
			
			if (ajaxData == null){
				return;	
			}	
			
			iniGrid();
			if(ajaxData.data[0].MSG!=null&&ajaxData.data[0].MSG!=''){
				alert(ajaxData.data[0].MSG);
			}else{
				Message.openSuccess(ajaxData.result);
			}
			back();
		}
		sendFormData("RESULT", controlPage, "SAVE", callBack);
	}
	
		/** 初始上層帶來的 Key 資料 */
	function iniMasterKeyColumn()
	{
		/** 非 Detail 頁面不處理 */
		if (typeof(keyObj) == "undefined")
			return;
		/** 塞值 */
		for (keyName in keyObj)
		{
			try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
			try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
			try {Form.iniFormSet("RESULT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
		}
		Form.iniFormColor();
	}
	
	//by poto
	function back(){ 	
		var obj = window.dialogArguments;	
		if(obj!=null){		
			window.close();
		}
	}
-->
    </script>
</head>

<body>
<span id="lblFunc" class="title"></span>
<jsp:include page="../../include/pages/title.jsp" />

<div align="center">
<%
		//showMsg((String)request.getAttribute("message"), out);
%>
</div>

<!----------------------查詢條件區開始------------------------------------------------------>
<div id="panelSearch" style="width: 100%;">

<form name="QUERY" method="post"  id="QUERY">	
	<input type="hidden" name="control_type" value="QUERY_MODE" />
	<input type="hidden" name="pageNo" value="1" />
	<input type="hidden" id="pageSize" name="pageSize" value="<%=StringUtils.defaultString((String)request.getParameter("pageSize"), "10") %>" />
	
	<input type=hidden name="EXPORT_FILE_NAME">
	<input type=hidden name="EXPORT_COLUMN_FILTER">
	<input type=hidden name="IDNO">
	<input type=hidden name="APP_SEQ">
	<input type=hidden name="HEDU_TYPE">
	<input type=hidden name="NOW_AYEAR">
	<input type=hidden name="NOW_SMS">	
	
    <table class="boxSearch" cellSpacing="0" cellPadding="5" width="100%" align="center">
	
		<tr>						
			<td align=right>學號：</td>
			<td align=left>
			    <input type=text name='STNO' value ="<%=session.getAttribute("STNO") %>">					
			</td>			
			<td align='right' class='tdgl1'>採認課程取得來源<font color=red>＊</font>：</td>
			<td colspan='3'>
				<select name="SCHOOL_TYPE" onchange="iniGrid();" >		
					<option value=''>請選擇</option>						
					<script>Form.getSelectFromPhrase("CCS110M_1_01_SELECT", "KIND", "HEDU_TYPE");</script>
				</select>
			</td>
		</tr>	
		<tr>
			
			<td colspan="4" align="right">
	        	<div class="btnarea">		 
	        		<!-- 從右到左 -->	       	        		
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doQuery();", "查  詢", false, false, true, "QUERY_BTN") %>
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doReset();", "清  除", false, false, true, "") %>	        		       		       	       
		        </div>
	        </td>
		</tr>		
    </table>	
</form>

</div>


<!----------------------查詢條件區結束------------------------------------------------------>
<div><img src="../../images/searchline.jpg" width="196" height="1" /></div>
<div style='line-height:10px'>&nbsp;</div>


<!----------------------結果列表區開始------------------------------------------------------>
<div id="panelList" style="width: 100%;">

<form name="RESULT" method="post" id="RESULT">
	<input type="hidden" name="control_type" value="" />
	<input type=hidden keyColumn="Y" name="NOW_AYEAR">
	<input type=hidden keyColumn="Y" name="NOW_SMS">		
	<input type=hidden keyColumn="Y" name="NOW_STNO">
	<input type=hidden keyColumn="Y" name="ASYS">
	<input type=hidden keyColumn="Y" name="AYEAR">
	<input type=hidden keyColumn="Y" name="SMS">	
	<input type=hidden keyColumn="Y" name="STNO">
	<input type=hidden keyColumn="Y" name="APP_SEQ">
	<input type=hidden keyColumn="Y" name="CRSNO">
	<input type=hidden keyColumn="Y" name="CRD">
	<input type=hidden keyColumn="Y" name="CRSNO_UNIV">
	<input type=hidden keyColumn="Y" name="CRD_UNIV">
	<input type=hidden keyColumn="Y" name="HEDU_TYPE">
	<input type=hidden keyColumn="Y" name="SCHOOL_TYPE">
	<input type=hidden keyColumn="Y" name="GRADE_OLD">
	<input type=hidden keyColumn="Y" name="SMS_OLD">
	<input type=hidden keyColumn="Y" name="GRAD_TYPE">
	<input type=hidden keyColumn="Y" name="GRAD_GRADE">


    <table cellspacing="0" cellpadding="0" border="0" width="100%">
	<!--<tr>
		<td width="10">&nbsp;</td>
	    <td height="30">
		注意事項<br>說明文字
	    </td>
	</tr>-->
    </table>
    <table class="box1" cellSpacing="0" cellPadding="0" border="0" width="100%" align="center">
	<tr>
	    <td colspan="3">
		<!----------------------工具列------------------------------------------------------>
		<table cellSpacing="0" cellPadding="0" border="0" width="100%" align="center">
		    <tr height="30">
				<td>		
					<%=ButtonUtil.GetButton("javascript:void(0);", "Form.setCheckBox(1, 'RESULT');", "全    選", false, false, false, "SELALL_BTN") %>
					<%=ButtonUtil.GetButton("javascript:void(0);", "Form.setCheckBox(0, 'RESULT');", "全 不 選", false, false, false, "SELNONE_BTN") %>
					<%=ButtonUtil.GetButton("javascript:void(0);", "doSave();", "儲  存", false, false, false, "SAVE_BTN") %>			    				   
				</td>
				<td align='right' valign='bottom'>
					<jsp:include page="../../include/pages/page.jsp" />					
				</td>
		    </tr>
		</table>
		<!----------------------結果列表------------------------------------------------------>
		<table class="box2" rules="all" id="grid-scroll" width="100%" align="center" />		    		
	    </td>
	</tr>
    </table>    
</form>

</div>


</body>
</html>
<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.addEventListener("load", page_init);    
</script>