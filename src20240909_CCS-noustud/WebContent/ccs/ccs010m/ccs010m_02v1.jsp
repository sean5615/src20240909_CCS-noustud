<%@ page import="com.nou.aut.AUTICFM, com.acer.util.*" %>
<%@ page import="com.nou.UtilityX" %>
<%@ page import="com.nou.sys.dao.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../include/pages/checkUser.jsp"%>
<%@include file="../../include/pages/query.jsp"%>
<%@ include file="../../include/pages/query1_2_0_2.jsp" %>
<%
	/**  */
	session.setAttribute("CCS010M_10_SELECT", "NOU#SELECT CENTER_CODE AS SELECT_VALUE, CENTER_NAME AS SELECT_TEXT FROM SYST002 WHERE CENTER_CODE <> '00' ORDER BY SELECT_VALUE, SELECT_TEXT ");

	
	/** 最高學歷 */
	String	ASYS	 	=	(String)session.getAttribute("ASYS");
	if("1".equals(ASYS)){
		session.setAttribute("CCS010M_1_01_SELECT", "NOU#SELECT '' AS SELECT_VALUE, '請選擇' AS SELECT_TEXT, 0 AS O FROM DUAL UNION SELECT TO_CHAR(CODE) AS SELECT_VALUE, TO_CHAR(CODE_NAME) AS SELECT_TEXT, 1 AS O FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('1','2','3','4') ORDER BY O, SELECT_VALUE, SELECT_TEXT ");
	}else if("2".equals(ASYS)){
		session.setAttribute("CCS010M_1_01_SELECT", "NOU#SELECT '' AS SELECT_VALUE, '請選擇' AS SELECT_TEXT, 0 AS O FROM DUAL UNION SELECT TO_CHAR(CODE) AS SELECT_VALUE, TO_CHAR(CODE_NAME) AS SELECT_TEXT, 1 AS O FROM SYST001 WHERE KIND='[KIND]' AND CODE IN ('1','2','3','4') ORDER BY O, SELECT_VALUE, SELECT_TEXT ");
	}
%>
<%
	String	USER_ID		=	(String)session.getAttribute("USER_ID");
	String	ID_TYPE		=	(String)session.getAttribute("ID_TYPE");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>data</title>
<script language="javascript">
<!--
	
	/** 初始設定頁面資訊 */
	var	currPage		=	"<%=request.getRequestURI()%>";
	var	printPage		=	"/ccs/ccs010m/_01p1";	//列印頁面
	var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
	var	_privateMessageTime	=	-1;				//訊息顯示時間(不自訂為 -1)
	var	controlPage		=	"_01c2";	//控制頁面
	var	queryObj		=	new queryObj();			//查詢元件
	
	/** 網頁初始化 */
	function page_init()
	{
		page_init_start_2();
	
		/** === 初始欄位設定 === */
		/** 初始編輯欄位 */	
		Form.iniFormSet('EDIT', 'STNO', 'S', 10, 'N', 'M',  9, 'A');
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'D', 1);
		Form.iniFormSet('EDIT', 'NAME', 'S', 10, 'M',  10, 'A', 'R', 1);
		Form.iniFormSet('EDIT', 'TEL', 'S', 20, 'M',  17, 'A', 'R', 1);
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'S', 5, 'M',  5, 'A', 'R', 1);
		Form.iniFormSet('EDIT', 'CRRSADDR', 'S', 50, 'M',  50, 'A', 'R', 1);	
	
		/** ================ */
	
		/** === 設定檢核條件 === */
		/** 編輯欄位 */
		Form.iniFormSet('EDIT', 'STNO', 'AA', 'chkForm', '學號');
		Form.iniFormSet('EDIT', 'NAME', 'AA', 'chkForm', '姓名');
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '中心');
		Form.iniFormSet('EDIT', 'TEL', 'AA', 'chkForm', '電話');
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'AA', 'chkForm', '郵遞區號');
		Form.iniFormSet('EDIT', 'CRRSADDR', 'AA', 'chkForm', '地址');
		Form.iniFormSet('EDIT', 'HEDU_TYPE', 'AA', 'chkForm', '最高學歷');
	
		/** ================ */
	
		page_init_end_2();
	}
	
	/** 新增功能時呼叫 */
	function doAdd(CENTER_CODE)
	{
		doAdd_start();
	
		
		Form.setInput('EDIT', 'CENTER_CODE_TEMP',CENTER_CODE);
		
		/** 清除唯讀項目(KEY)*/
		Form.iniFormSet('EDIT', 'ASYS', 'R', 0);
		Form.iniFormSet('EDIT', 'AYEAR', 'R', 0);
		Form.iniFormSet('EDIT', 'SMS', 'R', 0);	
		Form.iniFormSet('EDIT', 'APP_TYPE', 'R', 0);
	
		if ("<%=ID_TYPE%>" == "1")	
		{		
			Form.iniFormSet('EDIT', 'STNO', 'R', 1, 'V', '<%=USER_ID%>');
			Form.iniFormSet('EDIT', 'findD', 'D', 1);
			Form.iniFormSet('EDIT', 'CLS_BTN', 'D', 1);
		}
		else
		{
			Form.iniFormSet('EDIT', 'STNO', 'R', 0);
		}
	
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
		
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'STNO', 'FC');
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 停止處理 */
		queryObj.endProcess ("新增狀態完成");
	
		findData();
	}
	
	/** 修改功能時呼叫 */
	function doModify()
	{
		/** 設定修改模式 */
		editMode		=	"UPD";
		EditStatus.innerHTML	=	"修改";
	
		/** 清除唯讀項目(KEY)*/
		Form.iniFormSet('EDIT', 'ASYS', 'R', 1);
		Form.iniFormSet('EDIT', 'AYEAR', 'R', 1);
		Form.iniFormSet('EDIT', 'SMS', 'R', 1);
		Form.iniFormSet('EDIT', 'STNO', 'R', 1);
		Form.iniFormSet('EDIT', 'APP_TYPE', 'R', 1);
	
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'R', 1);
	
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 設定 Focus */
		Form.iniFormSet('EDIT', 'PAYABLE_AMT', 'FC');
	}
	
	/** 找尋基本資料時呼叫 */
	function doModify2()
	{
		/** 設定修改模式 */
		editMode		=	"ADD";
		EditStatus.innerHTML	=	"新增";
	
		/** 清除唯讀項目(KEY)*/
	
		/** 初始化 Form 顏色 */
		Form.iniFormColor();
	
		/** 設定 Focus */
		//Form.iniFormSet('EDIT', 'PAYABLE_AMT', 'FC');
	}
	
	/** 存檔功能時呼叫 */
	function doSave()
	{	
		doSave_start();
		
		/** 判斷新增無權限不處理 */
		if (editMode == "NONE")
			return;
		if (Form.getInput('EDIT', 'CENTER_CODE_TEMP') != ''&&Form.getInput('EDIT', 'CENTER_CODE_TEMP')!=Form.getInput('EDIT', 'CENTER_CODE')){
			alert('此學生不為此中心學生');
		}
		/** === 自定檢查 === */
		/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
		//if (Form.getInput("EDIT", "SYS_CD") == "")
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
			if (<%=AUTICFM.securityCheck (session, "EXP")%>)
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
	
	function findData()
	{
		var kvalue = "STNO|" + document.forms["EDIT"].STNO.value + "|ASYS|" + document.forms["EDIT"].ASYS.value;
		doEdit_findData(kvalue);
	}
	
	function doEdit_findData()
	{
		/** 開啟新增 Frame */
		top.showView();
		/** 呼叫修改 */
		top.viewFrame.doEdit_2_findData(arguments);
	}
	
	function doEdit_2_findData(arguments)
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
		{
			if (ajaxData == null){
				alert('該學制無此學號');
				Message.hideProcess();
				return;
			}
			/** 塞資料到畫面 */
			for (column in ajaxData.data[0])
			{
				if (ajaxData.data.length==0){
					alert('該學制無此學號');
					Message.hideProcess();
					return;
				}			
				if(ajaxData.data[0].ENROLL_STATUS!='2'){
					alert("該學號不在藉");
					Message.hideProcess();
					return;
				}
				if(ajaxData.data[0].STTYPE=='2'){
					alert("選修生不得申請採認");
					Message.hideProcess();
					return;
				}
				Form.iniFormSet("EDIT",	column, "KV", ajaxData.data[0][column]);
				/** 修正若有開窗自動帶出 */
				try
				{
					$(_i("EDIT", column)).trigger("onblur");
				}
				catch(ex)
				{}
			}
	
			/** 設定為修改模式 */
			doModify2();
	
			/** 停止處理 */
			Message.hideProcess();
		}
		sendFormData("EDIT", controlPage, "FINDE_DATA_MODE", callBack);
	}
-->
</script>
</head>

<body>
	<form id="EDIT" name="EDIT" method="POST" >
		<input type=hidden name="control_type">
	    <input type=hidden name="ROWSTAMP">
		<input type=hidden name="ASYS">
		<input type=hidden name="AYEAR">
		<input type=hidden name="SMS">
		<input type=hidden name="APP_TYPE">
		<input type=hidden name="STTYPE">
		<input type=hidden name="ENROLL_STATUS">
		<input type=hidden name="CENTER_CODE_TEMP">
		
		<div class="title">【編輯畫面】- <span id='EditStatus'>新增</span></div>

		<div align='center'>
			<%
				//showMsg((String) request.getAttribute("message"), out);
			%>
		</div>		
		<!----------------------單筆資料開始------------------------------------------------------>
		<table class="box1" cellSpacing="0" cellPadding="0" border="0" width="100%">
			<tr>
				<td>
					<table id="box2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
	                    <tr>
							<td align='right' class='dataHeader'>學號：</td>
							<td class='dataColor00'>
								<input type=text name='STNO'>
								<input type=button class="btn" id='findD' value='帶出基本資料' onkeypress='findData();'onclick='findData();'>
							</td>
							<td align='right' class='dataHeader'>姓名：</td>
							<td class='dataColor00'><input type=text name='NAME'></td>		
						</tr>
						<tr>						
							<td align='right' class='dataHeader'>中心別：</td>
							<td class='dataColor00'>
								<select name='CENTER_CODE'>
									<option value=''>請選擇</option>
									<script>Form.getSelectFromPhrase("CCS010M_10_SELECT", "", "");</script>
								</select>							
							</td>
							<td align='right' class='dataHeader'>最高學歷：</td>
							<td class='dataColor00'>
								<select name='HEDU_TYPE'>
									<script>Form.getSelectFromPhrase("CCS010M_1_01_SELECT", "KIND", "HEDU_TYPE");</script>
								</select>
								<font color=red>請選取最高學歷，確認後請按存檔按鈕</font>	
							</td>						
						</tr>
						<tr>
							<td align='right' class='dataHeader'>聯絡電話：</td>
							<td class='dataColor00'><input type=text name='TEL'></td>
							<td align='right' class='dataHeader'>通訊地址：</td>
							<td class='dataColor00' colspan=3>
								<input type=text name='CRRSADDR_ZIP'>
								<input type=text name='CRRSADDR'>
							</td>					
						</tr>	
	                </table>
				
									
					</span>
				</td>					
       		</tr>
						
			<tr>
				<td >
					<table cellSpacing="1" cellPadding="2" align="center" border="0" width="100%" >
						<tr>
							<td height="35">																
								<%=ButtonUtil.GetButton("javascript:void(0);", "doBack();", "回查詢頁", false, false, false, "") %>													
								<%=ButtonUtil.GetButton("javascript:void(0);", "doClear();", "清  除", false, false, false, "CLS_BTN") %>
								<%=ButtonUtil.GetButton("javascript:void(0);", "doSave();", "存  檔", false, false, false, "SAVE_BTN") %>																																																							
							</td>							
						</tr>
					</table>
				</td>
			</tr>					
		</table>
		<!----------------------單筆資料結束------------------------------------------------------>
		<!----------------------工具列開始------------------------------------------------------>

		<!----------------------工具列結束------------------------------------------------------>		
	</form>	
</body>
</html>
<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.addEventListener("load", page_init);    
</script>