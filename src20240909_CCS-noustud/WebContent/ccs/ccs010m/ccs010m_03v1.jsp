<%@ page import="com.nou.aut.AUTICFM, com.acer.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../include/pages/checkUser.jsp" %>
<%@ include file="../../include/pages/query.jsp" %>
<%@ include file="../../include/pages/query1_2_0_2.jsp" %>
<%
	String	ID_TYPE		=	(String)session.getAttribute("ID_TYPE");
	String	dep_code	=	(String)session.getAttribute("dep_code");

	String 	LINK		=	"";

	if (ID_TYPE.equals("1"))
	{
		LINK = "../../stu/stu003m/stu003m_.jsp";
	}
	else
	{
		LINK = "../../stu/stu002m/stu002m_.jsp";
	}
	
	String	ASYS	=	com.acer.util.Utility.checkNull(request.getParameter("ASYS"), "");
	String	AYEAR	=	com.acer.util.Utility.checkNull(request.getParameter("AYEAR"), "");
	String	SMS		=	com.acer.util.Utility.checkNull(request.getParameter("SMS"), "");
	String	STNO	=	com.acer.util.Utility.checkNull(request.getParameter("STNO"), "");
	String	APP_SEQ	=	com.acer.util.Utility.checkNull(request.getParameter("APP_SEQ"), "");
	String	HEDU_TYPE	=	com.acer.util.Utility.checkNull(request.getParameter("HEDU_TYPE"), "");
	String	IS_CONFIRM	=	com.acer.util.Utility.checkNull(request.getParameter("IS_CONFIRM"), "");

	String 	keyValue	=	"STNO|" + STNO + "|APP_SEQ|" + APP_SEQ + "|stno|" + STNO;
	
	 /** 科目名稱，科目代碼03 */	
	session.setAttribute("CCS010M_1_02_BLUR", "NOU#SELECT c.CRSNO, c.CRS_NAME, c.CRD FROM  COUT002 c WHERE c.CRSNO='[CRSNO]' ");	
	session.setAttribute("CCS010M_1_02_WINDOW", "NOU#SELECT c.CRSNO, c.CRS_NAME, c.CRD FROM  COUT002 c WHERE 1=1 ");			
	 /** 本校原修讀科目開窗 */
	session.setAttribute("CCS010M_1_03_BLUR_1", "NOU#SELECT '' as CRSNO, '' as CRS_NAME, '' as CRD  FROM DUAL WHERE 1 = 2 ");
	session.setAttribute("CCS010M_1_03_BLUR_2", "NOU#SELECT CRSNO, CRS_NAME, CRD FROM COUT002 WHERE CRSNO='[CRSNO]' ");
	session.setAttribute("CCS010M_1_03_WINDOW", "NOU#select crsno, crs_name, crd from cout002 where crs_name = [CRS_NAME]");		 
	
	/** 學校類別 */	
	if("1".equals(ASYS)){
		session.setAttribute("CCS010M_1_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('1','2','3','4') ORDER BY SELECT_VALUE, SELECT_TEXT ");
	}else if("2".equals(ASYS)){
		session.setAttribute("CCS010M_1_01_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('1','2','3','4') ORDER BY SELECT_VALUE, SELECT_TEXT ");
	}
	/** 最高學歷 */		
	session.setAttribute("CCS010M_1_04_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('" + HEDU_TYPE + "') ORDER BY SELECT_VALUE, SELECT_TEXT ");	
	

	
	String CONTENT = "";
	String MESSAGE_CONTENT = "";
	java.util.Vector dataVt = com.acer.util.DBUtil.getSQLData("ccst003_.jsp", "NOU", "SELECT * FROM CCST015 WHERE CCS_TYPE ='2' ");
	com.acer.db.VtResultSet rs = new com.acer.db.VtResultSet(dataVt);
	if(rs.next()) {
		CONTENT = rs.getString("CONTENT");
		MESSAGE_CONTENT = rs.getString("MESSAGE_CONTENT");
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>list</title>
    <script language="javascript">
<!--
	
			
	
	/** 初始設定頁面資訊 */
	var	printPage1	=	"/ccs/ccs101r/_01p1";	//列印頁面
	var	printPage2	=	"/ccs/ccs102r/_01p1";	//列印頁面
	var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
	var	lockColumnCount		=	-1;				//鎖定欄位數
	var	listShow		=	true;				//是否一進入顯示資料
	var	_privateMessageTime	=	-1;				//訊息顯示時間(不自訂為 -1)
	var	pageRangeSize		=	10;				//畫面一次顯示幾頁資料
	var	controlPage		=	"_03c2";	//控制頁面
	var	checkObj		=	new checkObj();			//核選元件
	var	queryObj		=	new queryObj();			//查詢元件
	var	importSelect		=	false;				//匯入選取欄位功能
	var	noPermissAry		=	new Array();			//沒有權限的陣列
	var	checkFlag		=	"ADD";
	var OLD_CRSNO = ''; // 先前所輸入的科目代碼
	
	/** 網頁初始化 */
	function page_init()
	{
		page_init_start();
		
		/** 權限檢核 */
		securityCheck();
	
		/** === 初始欄位設定 === */
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		/** 初始查詢欄位 */
		Form.iniFormSet('QUERY', 'STNO', 'S', 10, 'N', 'M',  9, 'A');
		Form.iniFormSet('QUERY', 'NAME', 'S', 10, 'M',  10, 'A');
		Form.iniFormSet('QUERY', 'IDNO', 'S', 10, 'M',  10, 'A', 'I', 'U');
		Form.iniFormSet('QUERY', 'CENTER_NAME', 'M',  20, 'A', 'S', 20);
		Form.iniFormSet('QUERY', 'TEL', 'S', 20, 'M',  17, 'A');
		Form.iniFormSet('QUERY', 'APP_SEQ', 'S', 10, 'M',  8, 'A');
		Form.iniFormSet('QUERY', 'CRRSADDR_ZIP', 'S', 5, 'M',  5, 'A');
		Form.iniFormSet('QUERY', 'CRRSADDR', 'S', 50, 'M',  50, 'A');	
		Form.iniFormSet('QUERY', 'HEDU_TYPE', 'D', 1);	
		
	
		/** 初始編輯欄位 */
		Form.iniFormSet('EDIT', 'PRIORITY', 'M',  3, 'A', 'S', 6, 'F', 3, 'N1', 'R', 1);	
		
		Form.iniFormSet('EDIT', 'CRSNO', 'M',  6, 'A', 'S', 6, 'R', 1);
		Form.iniFormSet('EDIT', 'CRS_NAME', 'M',  60, 'A', 'S', 20, 'R', 1);	
		Form.iniFormSet('EDIT', 'CRD', 'M',  3, 'A', 'S', 3, 'R', 1);	
		Form.iniFormSet('EDIT', 'CRSNO_UNIV', 'M',  6, 'A', 'S', 6, 'R', 1);
		Form.iniFormSet('EDIT', 'CRS_NAME_UNIV', 'M',  60, 'A', 'S', 20, 'R', 1);
		Form.iniFormSet('EDIT', 'CRD_UNIV', 'M',  3, 'A', 'S', 3, 'R', 1, 'R', 1);
		Form.iniFormSet('EDIT', 'GRADE_OLD', 'M',  3, 'A', 'S', 3, 'F', 3, 'N', 'R', 1);
	
		/** ================ */
	
		/** === 設定檢核條件 === */
		/** 查詢欄位 */
		//Form.iniFormSet('QUERY', 'STNO', 'AA', 'chkForm', '學號');
	
		/** 編輯欄位 */
		Form.iniFormSet('EDIT', 'PRIORITY', 'AA', 'chkForm', '優先順序');
		
		Form.iniFormSet('EDIT', 'SCHOOL_TYPE', 'AA', 'chkForm', '學校種類');
		Form.iniFormSet('EDIT', 'CRSNO', 'AA', 'chkForm', '採驗科目');
		Form.iniFormSet('EDIT', 'CRD', 'AA', 'chkForm', '學分數');
		Form.iniFormSet('EDIT', 'CRSNO_UNIV', 'AA', 'chkForm', '本校原修讀科目');
		Form.iniFormSet('EDIT', 'CRD_UNIV', 'AA', 'chkForm', '本校原修讀學分數');
		Form.iniFormSet('EDIT', 'GRADE_OLD', 'AA', 'chkForm', '原修讀年級');
		Form.iniFormSet('EDIT', 'SMS_OLD', 'AA', 'chkForm', '原修讀學期');
		//Form.iniFormSet('EDIT', 'GRAD_TYPE', 'AA', 'chkForm', 'GRAD_TYPE');
	
		/** ================ */
	
		page_init_end();
	
		top.showView();
	
		//doAdd();	
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
					<td width=20>&nbsp;</td>\
					<td resize='on' nowrap>優先順序</td>\
					<td resize='on' nowrap>採認科目代碼</td>\
					<td resize='on' nowrap>採認科目名稱</td>\
					<td resize='on' nowrap>學分數</td>\
					<td resize='on' nowrap>本校原修讀科目名稱</td>\
					<td resize='on' nowrap>本校原修讀學分數</td>\
					<td resize='on' nowrap>原修讀學年</td>\
					<td resize='on' nowrap>原修讀學期</td>\
					<td resize='on' nowrap>畢/肄業</td>\
				</tr>"
		);
	
		if (stat == "init" && !listShow)
		{
			/** 初始化及不顯示資料只秀表頭 */
			document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "");
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
	
				for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
				{
					keyValue	=	"APP_SEQ|" + ajaxData.data[i].APP_SEQ + 
									"|PRIORITY|" + ajaxData.data[i].PRIORITY + 
									"|CRSNO|" + ajaxData.data[i].CRSNO + 
									"|AYEAR|" + ajaxData.data[i].AYEAR + 
									"|SMS|" + ajaxData.data[i].SMS + 
									"|STNO|" + ajaxData.data[i].STNO;
	
					/** 判斷權限 */
					if (chkSecure("DEL"))
						delStr	=	"onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><div class=list_btn><a href=\"javascript:void(0)\">&nbsp;&nbsp;&nbsp;&nbsp;刪&nbsp;&nbsp;&nbsp;&nbsp;</a></div>";
					else
						delStr	=	"><div class=list_btn_disable>&nbsp;&nbsp;&nbsp;&nbsp;刪&nbsp;&nbsp;&nbsp;&nbsp;</div>";
	
					if (chkSecure("UPD"))
						editStr	=	"onkeypress=\"doEdit('" + keyValue + "');\"onclick=\"doEdit('" + keyValue + "');\"><div class=list_btn><a href=\"javascript:void(0)\">&nbsp;&nbsp;&nbsp;&nbsp;編&nbsp;&nbsp;&nbsp;&nbsp;</a></div>";
					else
						editStr	=	"><div class=list_btn_disable>&nbsp;&nbsp;&nbsp;&nbsp;編&nbsp;&nbsp;&nbsp;&nbsp;</div>";
	
					gridObj.gridHtml.append
					(
						"<tr class=\"listColor0" + ((gridObj.rowCount % 2) + 1) + "\">\
							<td align=center><input type=checkbox name='chkBox' value=\"" + keyValue + "\"></td>\
							<td align=center " + editStr + "</td>\
							<td>" + ajaxData.data[i].PRIORITY + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRSNO + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRS_NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRD + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRSNO_UNIV_NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].CRD_UNIV + "&nbsp;</td>\
							<td>" + ajaxData.data[i].GRADE_OLD + "&nbsp;</td>\
							<td>" + getSMSOldName(ajaxData.data[i].SMS_OLD) + "&nbsp;</td>\
							<td>" + ajaxData.data[i].GRAD_TYPE_C + "&nbsp;</td>\
						</tr>"
					);
	
					exportBuff.append
					(
						ajaxData.data[i].PRIORITY + "," + 
						ajaxData.data[i].CRSNO + "," + 
						ajaxData.data[i].CRS_NAME + "," + 
						ajaxData.data[i].CRD + "," + 
						ajaxData.data[i].CRS_NAME_OTHER + "," + 
						ajaxData.data[i].CRD_OTHER + "," + 
						ajaxData.data[i].SCHOOL_TYPE_C + "," + 
						ajaxData.data[i].GRADE_OLD + "," + 
						ajaxData.data[i].SMS_OLD + "," + 
						ajaxData.data[i].GRAD_TYPE_C + "\r\n"
					);
				}
				gridObj.gridHtml.append ("<tr></tr>");
	
				/** 無符合資料 */
				if (ajaxData.data.length == 0)
				{
					gridObj.gridHtml.append ("<tr><td colspan='15'><font color=red><b>　　　請選擇帶出採認科目!!</b></font></td></tr>");
					
					Form.iniFormSet("EDIT", "SEND_BTN", "D", 1)					
					//_i('EDIT','SEND_BTN').disabled = true;
					
					document.getElementById("PRT_BTN1").style.display = 'none';
					document.getElementById("PRT_BTN2").style.display = 'none';
					
					//_i('EDIT','PRT_BTN1').style.display = "none";
					//_i('EDIT','PRT_BTN2').style.display = "none";				
				}
				else
				{
					/**學生才開放送出*/
					if ("<%=ID_TYPE%>" == "1")
					{					
						document.getElementById("PRT_BTN1").style.display = 'none';
						document.getElementById("PRT_BTN2").style.display = 'none';
						
						//_i('EDIT','PRT_BTN1').style.display = "none";
						//_i('EDIT','PRT_BTN2').style.display = "none";					
					}
					else
					{					
						document.getElementById("PRT_BTN1").style.display = '';
						document.getElementById("PRT_BTN2").style.display = '';
						
						//_i('EDIT','PRT_BTN1').style.display = "";
						//_i('EDIT','PRT_BTN2').style.display = "";					
					}
					Form.iniFormSet("EDIT", "SEND_BTN", "D", 0)
					Form.iniFormColor();		
				}		
				iniGrid_end(ajaxData, gridObj);
			}
			sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);		
		}
	}
	
	/** 處理匯出動作 */
	function doExport(type)
	{
		var	header		=	"PRIORITY, CRSNO, 科目中文名稱, CRD, CRS_NAME_OTHER, CRD_OTHER, SCHOOL_TYPE, GRADE_OLD, SMS_OLD, GRAD_TYPE\r\n";
		
		/** 處理匯入功能 匯出種類, 標題, 一次幾筆, 程式名稱, 寬度, 高度 */
		processExport(type, header, 4, 'ccs010m_1', 500, 200);
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
	
	function resetColumn() {
		//Form.setInput("EDIT", "CRSNO", "");
		//Form.setInput("EDIT", "CRS_NAME", "");
		//Form.setInput("EDIT", "CRD", "");
		Form.setInput("EDIT", "CRSNO_UNIV", "");
		Form.setInput("EDIT", "CRS_NAME_UNIV", "");
		Form.setInput("EDIT", "CRD_UNIV", "");
	}
	
	/** 新增功能時呼叫 */
	function doAdd()
	{
		doAdd_start();
	
		Form.iniFormSet('EDIT','GRAD_TYPE','KV','1');
	
		/** 清除唯讀項目(KEY)*/
		// Form.iniFormSet('EDIT', 'APP_SEQ', 'R', 0);
		// Form.iniFormSet('EDIT', 'CRSNO', 'R', 0);
		// Form.iniFormSet('EDIT', 'AYEAR', 'R', 0);
		// Form.iniFormSet('EDIT', 'SMS', 'R', 0);
		// Form.iniFormSet('EDIT', 'STNO', 'R', 0);
	
		// _i('EDIT','IMG').style.display = '';
		checkFlag = "ADD";
	
		Message.showProcess();		
		
		var	callBack	=	function (ajaxData)
		{
			if (ajaxData == null)
				return;
	
			if (StrUtil.fillZero(ajaxData.data[0].PRIORITY, 3) == "000")
			{
				Form.setInput('EDIT', 'PRIORITY', '001');
			}
			else
			{
				Form.setInput('EDIT', 'PRIORITY', StrUtil.fillZero(ajaxData.data[0].PRIORITY, 3));
			}
			
			Form.iniFormSet('EDIT', 'PRIORITY', 'R', 1);
	
			Message.hideProcess();		
		}
		sendFormData("QUERY", controlPage, "GET_MAX_PRIORITY_MODE", callBack, "nosync");	
	
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'PRIORITY', 'FC');
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 停止處理 */
		queryObj.endProcess ("新增狀態完成");
	
	}
	
	/** 修改功能時呼叫 */
	function doModify()
	{
		/** 設定修改模式 */
		editMode		=	"UPD";
		EditStatus.innerHTML	=	"修改";
	
		/** 清除唯讀項目(KEY)*/
		Form.iniFormSet('EDIT', 'APP_SEQ', 'R', 1);
		Form.iniFormSet('EDIT', 'CRSNO', 'R', 1);
		Form.iniFormSet('EDIT', 'AYEAR', 'R', 1);
		Form.iniFormSet('EDIT', 'SMS', 'R', 1);
		Form.iniFormSet('EDIT', 'STNO', 'R', 1);
	
		Form.iniFormSet('EDIT', 'PRIORITY', 'R', 1);
	
		_i('EDIT','IMG').style.display = 'none';
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'PRIORITY', 'FC');		
	}
	
	/** 存檔功能時呼叫 */
	function doSave()
	{
		doSave_start();
	
		/** 判斷新增無權限不處理 */
		if (editMode == "NONE")
			return;
	
		/** === 自定檢查 === */
		/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
		//if (Form.getInput("QUERY", "SYS_CD") == "")
		//	Form.errAppend("系統編號不可空白!!");
		/** ================ */
	
		doSave_end();
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
	function doEdit()
	{
		/** 開啟新增 Frame */
		top.showView();
		/** 呼叫修改 */
		top.viewFrame.doEdit_2(arguments);
	
		checkFlag = "EDIT";
	}
	
	/** 處理列印動作 */
	function doPrint1(printForm)
	{
		/** 取消 onsubmit 功能防止重複送出 */
		//event.returnValue	=	false;
	
		/** 開始處理 */
		Message.showProcess();
	
		/** 檢核設定欄位*/
		Form.startChkForm("PRINT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	
		Form.doSubmit("PRINT", printPage1 + "?PRINTFORM=" + printForm, "post", "Print");	
	
		printWin.focus();
	
		/** 停止處理 */
		Message.hideProcess();
	}
	
	/** 處理列印動作 */
	function doPrint2(printForm)
	{
		/** 取消 onsubmit 功能防止重複送出 */
		//event.returnValue	=	false;
	
		/** 開始處理 */
		Message.showProcess();
	
		/** 檢核設定欄位*/
		Form.startChkForm("PRINT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	
		Form.doSubmit("PRINT", printPage2 + "?PRINTFORM=" + printForm, "post", "Print");	
	
		printWin.focus();
	
		/** 停止處理 */
		Message.hideProcess();
	}
	
	/** 存檔功能時呼叫結束 */
	function doSave_end()
	{
		/** 檢核設定欄位*/
		Form.startChkForm("EDIT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		/** = 送出表單 = */
		/** 設定狀態 */
		var	actionMode	=	"";
		if (editMode == "ADD")
			actionMode	=	"ADD_MODE";
		else
			actionMode	=	"EDIT_MODE";
	
		/** 傳送至後端存檔 */
		var	callBack	=	function (ajaxData)
		{
			if (ajaxData == null)
				return;
	
			/** 資料新增成功訊息 */
			if (editMode == "ADD")
			{
				/** 設定為新增模式 */
				doAdd();
				Message.openSuccess("A01");
			}
			/** 資料修改成功訊息 */
			else
			{
				//Message.openSuccess("A02", function (){top.hideView();});
				doAdd();
				Message.openSuccess("A02");
				/** nono mark 2006/11/16 */
				//top.mainFrame.iniGrid();
			}
			
			/** 重設 Grid 2006/11/16 nono add, 2007/01/07 調整判斷方式 */
			if (chkHasQuery())
			{
				iniGrid();
			}
		}
		sendFormData("EDIT", controlPage, actionMode, callBack)
	}
	
	function doSend()
	{
		/** 開始處理 */
		Message.showProcess();
	
		if (!Message.showConfirm(Form.getInput("QUERY", "MESSAGE_CONTENT")))
		{
			Message.hideProcess();
			return;
		}		
		
		var	callBack	=	function (ajaxData)
		{
			if (ajaxData == null)
				return;
	 
			/** 停止處理 */
			Message.hideProcess();
		
			doBack();
			//by poto給一個參數 讓學生在列印的時候 不會跳回編輯頁面
			top.mainFrame.iniGrid("Y");			
		}
		sendFormData("SEND", controlPage, "SEND_MODE", callBack);
	}
	
	// 科目開窗所要做的事情
	function executeCrsno(){	
		// 依照所選擇的科目帶出相關資料
		Form.blurData("CCS010M_1_02_BLUR", "CRSNO", _i("EDIT", "CRSNO").value, ["CRSNO", "CRS_NAME", "CRD"], [_i("EDIT", "CRS_NAME"), _i("EDIT", "CRS_NAME"), _i("EDIT", "CRD")], true);
		
		// 當所輸入的科目與之前不同時才進行清空
		if(_i("EDIT", "CRSNO").value!=crsno)
			cleanCrsnoUniv();
			
		var crsno=_i("EDIT", "CRSNO").value;
	}
	
	function getPassCrs(type) {
		if(document.getElementById('SCHOOL_TYPE').value == '') {
			alert('尚未選擇學校類別');
			return;
		} else if(document.getElementById('CRSNO_ID').value == '') {
			alert('尚未選擇採認科目');
			return;
		}
	
		_i("EDIT", "CRSNO_TYPE").value = type;
		var	callBack	=	function (ajaxData)
		{
			// 如點選原修科目開窗
			if(type=='WINDOW')
				Form.openPhraseWindow("CCS010M_1_03_WINDOW", null, null, "科目代號, 科目名稱, 學分,學年,學期,畢業", [_i("EDIT", "CRSNO_UNIV"), _i("EDIT", "CRS_NAME_UNIV"), _i("EDIT", "CRD_UNIV"), _i("EDIT", "GRADE_OLD"), _i("EDIT", "SMS_OLD"),_i("EDIT", "GRAD_TYPE_1")]);
			else if(type=='BLUR'){
				// 僅有一筆時,則自動帶出資料
				if(ajaxData.data.length==1){
					_i("EDIT", "CRSNO_UNIV").value=ajaxData.data[i].CRSNO_UNIV;
					_i("EDIT", "CRS_NAME_UNIV").value=ajaxData.data[i].CRS_NAME_UNIV;
					_i("EDIT", "CRD_UNIV").value=ajaxData.data[i].CRD_UNIV;
					_i("EDIT", "GRADE_OLD").value=ajaxData.data[i].GRADE_OLD;
					_i("EDIT", "SMS_OLD").value=ajaxData.data[i].SMS_OLD;
					_i("EDIT", "GRAD_TYPE_1").value=ajaxData.data[i].GRAD_TYPE_1;
				}
				// 無資料則清空相關資料
				else if(ajaxData.data.length==0){
					_i("EDIT", "CRSNO_UNIV").value='';
					_i("EDIT", "CRS_NAME_UNIV").value='';
					_i("EDIT", "CRD_UNIV").value='';
					_i("EDIT", "GRADE_OLD").value='';
					_i("EDIT", "SMS_OLD").value='';
					_i("EDIT", "GRAD_TYPE_1").value='';
				}
				// 如有多筆資料則開窗
				else if(ajaxData.data.length>1){
					Form.openPhraseWindow("CCS010M_1_03_WINDOW", null, null, "科目代號, 科目名稱, 學分,學年,學期,畢業", [_i("EDIT", "CRSNO_UNIV"), _i("EDIT", "CRS_NAME_UNIV"), _i("EDIT", "CRD_UNIV"), _i("EDIT", "GRADE_OLD"), _i("EDIT", "SMS_OLD"),_i("EDIT", "GRAD_TYPE_1")]);
				}
			}		
		}
		sendFormData("EDIT", controlPage, "GETPASSCRS_MODE", callBack);
	}
	
	function getGRAD_TYPE() {
		var GRAD_TYPE_1 = Form.getInput("EDIT", "GRAD_TYPE_1");
		Form.setInput("EDIT", "GRAD_TYPE",GRAD_TYPE_1);
	}
	
	function getCrsno() {
	
		if(document.getElementById('SCHOOL_TYPE').value == '') {
			alert('尚未選擇學校類別');
			return;
		} 
		/** 開始處理 */
		Message.showProcess();	
		var	callBack	=	function (ajaxData)
		{
			if (ajaxData == null){
				return;
			}			
			Form.openPhraseWindow("CCS010M_1_02_WINDOW", null, null, "科目代號, 科目名稱, 學分", [_i("EDIT", "CRSNO"), _i("EDIT", "CRS_NAME"), _i("EDIT", "CRD")]);	
			cleanCrsnoUniv();
			iniGrid();
			
			var crsno = _i("EDIT", "CRSNO").value;
		}
		sendFormData("EDIT", controlPage, "GETCRSNO_MODE", callBack);
	}
	
	function cleanCrsnoUniv() {	
		document.getElementById('CRSNO_UNIV_ID').value = '';		
		document.getElementById('CRS_NAME_UNIV').value = '';	
		document.getElementById('CRD_UNIV_ID').value = '';		
	}
	
	function getSMSOldName(SMS_OLD)
	{
		if (SMS_OLD != null ||SMS_OLD != "")
		{
			if (SMS_OLD == "1")
			{
				return "上下學期";
			}
			else if (SMS_OLD == "2")
			{
				return "上學期";
			}
			else if (SMS_OLD == "3")
			{
				return "下學期";
			}		
			else if (SMS_OLD == "4")
			{
				return "暑修";
			}	
			else
			{
				return "對應不到!";
			}
		}
	}
	
	function doSetCrsnoWin()
	{
		if ( _i('EDIT','CRSNO').value != '' )
		{
			var	callBack	=	function (ajaxData)
			{
				if (ajaxData == null)
					return;		
	
				if (ajaxData.data.length > 0)
				{
					var CRSNO = "";
					
					for (var i = 0; i < ajaxData.data.length; i++)
					{
						/**撈出資料有包含採認科目*/
						if (ajaxData.data[i].CRSNO == Form.getInput('EDIT', 'CRSNO') )
						{
							CRSNO = Form.getInput('EDIT', 'CRSNO');
						}
						/**撈出資料沒包含採認科目,選第一筆*/
						else
						{
							CRSNO = ajaxData.data[0].CRSNO;
						}
					}
	
					if ( checkFlag != "EDIT")
					{
						/**自動帶出科目*/
						_i("EDIT", "CRSNO_UNIV").value = CRSNO;
						_i("EDIT", "CRSNO_UNIV").fireEvent("onblur");
					}								
				}
				else
				{
					if ( checkFlag != "EDIT")
					{
						_i('EDIT','CRSNO_UNIV').value='';
						_i('EDIT','CRS_NAME_UNIV').value='';
						_i('EDIT','CRD_UNIV').value='';
					}
				}
			}
			/** 送出表單 */
			sendFormData("EDIT", controlPage, "SET_CRSNO_MODE", callBack, "nosync");
		}	
	}
	
	/**
	按下編輯時呼叫
	@param	args[0]	單數參數, 變數名稱 (KEY)
	@param	args[1]	雙數參數, 變數值 (KEY)
	*/
	function doEdit_2(arguments)
	{
		/** 開始處理 */
		Message.showProcess();
	
		var	editAry	=	arguments[0].split("|");
	
		for (i = 0; i < editAry.length; i += 2)
		{
			Form.setInput("EDIT", editAry[i], editAry[i + 1]);
		}
	
		/** 送到後端處理 */
		var	callBack	=	function (ajaxData)
		//alert(callBack);
		{
			if (ajaxData == null)
				return;
				
			/** 塞資料到畫面 */
			for (column in ajaxData.data[0])
			{
				Form.iniFormSet("EDIT",	column, "KV", ajaxData.data[0][column]);
				
				/** 修正若有開窗自動帶出 */
				try
				{	
					/**檔掉*/
				//	if (column != 'CRSNO_UNIV')
					//	_i("EDIT", column).fireEvent("onblur");
				}
				catch(ex)
				{}
			}
	
			/** 設定為修改模式 */
			doModify();
	
			/** 停止處理 */
			Message.hideProcess();
		}
		sendFormData("EDIT", controlPage, "EDIT_QUERY_MODE", callBack);
	}
	
	function doHiddenEdit()
	{
		document.getElementById('EDIT_SPAN').style.display = "none";
		document.getElementById('QUERY_TABLE_SPAN').style.display = "none";
		document.getElementById('hidden').style.display = "none";
		document.getElementById('show').style.display = "";	
	}
	
	function doShowEdit()
	{
		document.getElementById('EDIT_SPAN').style.display = "";
		document.getElementById('QUERY_TABLE_SPAN').style.display = "";
		document.getElementById('hidden').style.display = "";
		document.getElementById('show').style.display = "none";	
	}
	
	/** 編輯畫面清除功能 */
	function doClear(mode)
	{
		var PRIORITY_TMP = Form.getInput('EDIT', 'PRIORITY');
		
		/** 設定清除功能 */
		if (editMode == "ADD")
			document.forms["EDIT"].reset();
		else
			Form.clear();
		iniMasterKeyColumn();
	
		Form.setInput('EDIT', 'PRIORITY', PRIORITY_TMP)
	}
	
	
	
	function doOpenCrsno()
	{
		var key = 	"STNO|" + Form.getInput("QUERY", "STNO") + 
					"|IDNO|" + Form.getInput("QUERY", "IDNO")+ 
					"|SCHOOL_TYPE|" + Form.getInput("EDIT", "SCHOOL_TYPE")+ 
					"|APP_SEQ|" + Form.getInput("QUERY", "APP_SEQ")+ 
					"|HEDU_TYPE|" + Form.getInput("QUERY", "HEDU_TYPE")+
					"|NOW_AYEAR|" + Form.getInput("QUERY", "AYEAR")+
					"|NOW_SMS|" + Form.getInput("QUERY", "SMS")+
					"";	
					
		doOpen(key,800,600,'../../ccs/ccs110m/ccs110m_.jsp');
		iniGrid();
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
	<input type=hidden name="CENTER_CODE">
	<input type=hidden name="AYEAR">
	<input type=hidden name="SMS">
	<input type=hidden name="MESSAGE_CONTENT" value="<%=MESSAGE_CONTENT%>">	
	<input type=hidden name="IS_CONFIRM" value="<%=IS_CONFIRM%>">
	
    <table class="boxSearch" cellSpacing="0" cellPadding="5" width="100%" align="center">
		<span id='QUERY_TABLE_SPAN'>
		<tr>
			<td align='right'>中心別：</td>
			<td><input type=text name='CENTER_NAME'></td>	
			<td align='right'>申請序號：</td>
			<td colspan><input type=text name='APP_SEQ'></td>	
			<td align='right'>最高學歷：</td>
			<td colspan>
				<select name="HEDU_TYPE">								
					<script>Form.getSelectFromPhrase("CCS010M_1_04_SELECT", "KIND", "HEDU_TYPE");</script>
				</select>
			</td>						
		</tr>
		<tr>
			<td align='right'>學號：</td>
			<td><input type=text name='STNO'></td>	
			<td align='right'>姓名：</td>
			<td colspan="3"><input type=text name='NAME'><input style="display:none" type=text name='IDNO'></td>					
		</tr>
		<tr>
			<td align='right'>聯絡電話：</td>
			<td><input type=text name='TEL'></td>	
			<td align='right'>通訊地址：</td>
			<td colspan=3>
				<input type=text name='CRRSADDR_ZIP'>
				<input type=text name='CRRSADDR'>
			</td>							
		</tr>
		</span>
		<tr>
			
			<td colspan="6" align="right">
	        	<div class="btnarea">		 
	        		<!-- 從右到左 -->	       	        		
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doOpen('"+keyValue+"',1280,1024,'"+LINK+"');", "修改學生基本資料", false, false, true, "STU_BTN") %>
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doBack();", "回查詢頁", false, false, true, "") %>
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doShowEdit();", "▼", false, false, true, "show", "display:none") %>
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doHiddenEdit();", "▲", false, false, true, "hidden") %>	  	        		       		       	       
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

<span id='EDIT_SPAN'>
<!-- 定義編輯的 Form 起始 -->
<form name="EDIT" method="post"  style="margin:5,0,0,0;">
	<input type=hidden name="control_type">
	<input type=hidden name="ROWSTAMP">
	<input type=hidden name="ASYS">
	<input type=hidden name="APP_SEQ">
	<input type=hidden name="AYEAR">
	<input type=hidden name="SMS">
	<input type=hidden name="STNO">
	<input type=hidden name="IDNO">
	<input type=hidden name="HEDU_TYPE" value="<%=HEDU_TYPE %>">
	<input type=hidden name="IS_CONFIRM" value="<%=IS_CONFIRM%>">
	<input type=hidden name="CRSNO_TYPE"><!-- 原修科目的相關資料的方式--BLUR/WINDOW -->
	
	<!-- 編輯全畫面起始 -->
	<TABLE id="EDIT_DIV" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
		
		<tr>
			
			<td width="100%" valign="top" bgcolor="#FFFFFF">
				<!-- 按鈕畫面起始 -->
				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
					<tr class=listHeader align=center>
						<td align=left>申請採認- <span id='EditStatus'>新增</span></td>
						<td align=right>
							<div id="edit_btn">
								<%=ButtonUtil.GetButton("javascript:void(0);", "doOpenCrsno();", "帶出採認科目", false, false, false, "OPEN_WIN_BTN") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doPrint1();", "列印申請表", false, false, false, "PRT_BTN1") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doPrint2();", "列印學系申請表", false, false, false, "PRT_BTN2", "display:none") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doSend();", "確認送出", false, false, false, "SEND_BTN") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doAdd();", "新  增", false, false, false, "ADD_BTN", "display:none") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doClear();", "清  除", false, false, false, "", "display:none") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doSave();", "存  檔", false, false, false, "SAVE_BTN", "display:none") %>			
							</div>
						</td>
					</tr>
				</table>
				<!-- 按鈕畫面結束 -->

				<!-- 編輯畫面起始 -->
				<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格" style='display:none'>
					<tr>
						<td align='right' class='dataHeader'>優先順序<font color=red>＊</font>：</td>
						<td colspan='3' class='dataColor00'><input type=text name='PRIORITY'></td>	
						<td align='right' class='dataHeader'>學校類別<font color=red>＊</font>：</td>
						<td colspan='3'>
							<select name="SCHOOL_TYPE" onchange="resetColumn()" disabled>		
								<option value=''>請選擇</option>						
								<script>Form.getSelectFromPhrase("CCS010M_1_01_SELECT", "KIND", "HEDU_TYPE");</script>
							</select>
						</td>							
					</tr>
					<tr>
						<td align='right' class='dataHeader'>採認科目<font color=red>＊</font>：</td>
						<td colspan='7' class='dataColor00'>												
							<input type='text' Column='CRSNO' name='CRSNO' id='CRSNO_ID' onblur='executeCrsno();' readonly >
							<img id='IMG' src='/images/select.gif' alt='開窗選取' style='cursor:hand' onkeypress='getCrsno();' onclick='getCrsno();' >
							<input type=text Column='CRS_NAME' name='CRS_NAME' readonly>							
							&nbsp;&nbsp;學分數：&nbsp;&nbsp;
							<input type=text Column='CRD' name='CRD' readonly>
						</td>				
					</tr>
					<tr>
						<td align='right' class='dataHeader'>本校原修讀科目<font color=red>＊</font>：</td>
						<td colspan='7' class='dataColor00'>														
							<input type='text' Column='CRSNO_UNIV' name='CRSNO_UNIV' id='CRSNO_UNIV_ID' readonly>
							<img id='IMG1' src='/images/select.gif' alt='開窗選取' style='cursor:hand' onkeypress="getPassCrs('WINDOW');" onclick="getPassCrs('WINDOW');">
							<input type=text Column='CRS_NAME_UNIV' name='CRS_NAME_UNIV' id='CRS_NAME_UNIV_ID' readonly>	
							&nbsp;&nbsp;學分數：&nbsp;&nbsp;
							<input type=text Column='CRD_UNIV' name='CRD_UNIV' id='CRD_UNIV_ID'>																																																				
						</td>	
						</td>				
					</tr>
					<tr>
						<td align='right' class='dataHeader'>原修讀學年<font color=red>＊</font>：</td>
						<td class='dataColor00'><input type=text name='GRADE_OLD'  Column='GRADE_OLD' readonly></td>
						<td align='right' class='dataHeader'>原修讀學期<font color=red>＊</font>：</td>
						<td class='dataColor00'>
							<select name='SMS_OLD' Column='SMS_OLD' disabled>
								<option value=''>請選擇</option>
								<option value='1'>上下學期</option>
								<option value='2'>上學期</option>
								<option value='3'>下學期</option>
								<option value='4'>暑修</option>
							</select>
						</td>
						<td align='right' class='dataHeader'>畢/肄業<font color=red>＊</font>：</td>
						<td class='dataColor00' colspan="3">		
							<input type=hidden name='GRAD_TYPE_1' Column='GRAD_TYPE_1'onchange='getGRAD_TYPE()'   >畢業												
							<input type=radio name='GRAD_TYPE' value="1" checked  readonly>畢業												
							<input type=radio name='GRAD_TYPE' value="0" readonly>肄業
						</td>
											
					</tr>
				</table>
				<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格" >
					<tr>
						<td align='right' class='dataHeader'>注意事項：</td>
						<td colspan='7' class='dataColor00'>
							<font color=red>
								<!--※如電話、通訊地址、email有誤，請點選"修改學生基本資料"<BR>
								※登錄完畢後，請列印申請表，至指導中心辦理繳費.....<BR>
								※如需繳費，請...<BR>
								※抵免、採認、申覆注意事項請淑儀提供
								-->
							<%=CONTENT%>		
							</font>
						</td>
					</tr>				
				</table>
				<!-- 編輯畫面結束 -->
			</td>
			
		</tr>
		
	</table>
	<!-- 編輯全畫面結束 -->
</form>
<!-- 定義編輯的 Form 結束 -->
</span>
<form name="RESULT" method="post" id="RESULT">
	<input type="hidden" name="control_type" value="" />
	<input type=hidden keyColumn="Y" name="APP_SEQ">
	<input type=hidden keyColumn="Y" name="CRSNO">
	<input type=hidden keyColumn="Y" name="AYEAR">
	<input type=hidden keyColumn="Y" name="SMS">
	<input type=hidden keyColumn="Y" name="STNO">
	<input type=hidden keyColumn="Y" name="PRIORITY">
	
	<input type=hidden name="IS_CONFIRM" value="<%=IS_CONFIRM%>">



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
					<%=ButtonUtil.GetButton("javascript:void(0);", "doDelete('multi');", "刪    除", false, false, false, "DEL_BTN") %>
					<%=ButtonUtil.GetButton("javascript:void(0);", "doOpen('"+keyValue+"',800,600,'../../ccs/ccs010m/ccs010m_04.jsp');", "調整優先順序", false, false, false, "ORDER_BTN") %>					    				   
				</td>
				<td align='right' valign='bottom'>
					<jsp:include page="../../include/pages/page.jsp" />					
				</td>
		    </tr>
		</table>
		<!----------------------結果列表------------------------------------------------------>
		<table class="box2" rules="all" id="grid-scroll" width="100%" align="center"></table>		    		
	    </td>
	</tr>
    </table>    
</form>
<form name="PRINT" method="post">
	<input type=hidden name="AYEAR" value="<%=AYEAR%>">
	<input type=hidden name="SMS" value="<%=SMS%>">
	<input type=hidden name="STNO" value="<%=STNO%>">
	<input type=hidden name="APP_SEQ" value="<%=APP_SEQ%>">
	<input type=hidden name="APP_TYPE" value="2">
	<input type=hidden name="CALLER" value="CCS003M">
</form>

<form name="SEND" method="post" ID="SEND">
	<input type=hidden name="control_type">
	<input type=hidden name="AYEAR" value="<%=AYEAR%>">
	<input type=hidden name="SMS" value="<%=SMS%>">
	<input type=hidden name="STNO" value="<%=STNO%>">
	<input type=hidden name="ASYS" value="<%=ASYS%>">
	<input type=hidden name="APP_TYPE" value="2">
</form>

</div>


</body>
</html>
<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.addEventListener("load", page_init);    
</script>