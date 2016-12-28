EXAMPLE_loop_over_all_SAP_screens(){
	;	Normal SAP connection example
	;	SAP Application
	;	-- Connection 1 (system XXX)
	;	------Session 1 (screen 1)
	;	------Session 2 (screen 2)
	;	------Session 3 (screen 3)
	;	------Session 4 (screen 4)
	;	------Session 5 (screen 5)
	;	------Session 6 (screen 6)
	;	-- Connection 2 (system XXX)
	;	------Session 1 (screen 1)
	;	------Session 2 (screen 2)
	;	------Session 3 (screen 3)
	
	Application := getSAPApplication()	;Get the current active SAP application.
	Connections := Application.Children.Count	;Count all the connections (SAP gui windows)
	i := true
	Loop, %Connections%{	;Loop over all the connections
		connection_loop := A_Index
		cur_connection := floor(connection_loop - 1) ;current connection - 1
		Sessions := application.Connections(%cur_connection%).Sessions.Count ;count all sessions
		Loop, %Sessions%{
			sessions_loop := A_Index
			cur_sessions_loop := floor(sessions_loop - 1) ; currenct session - 1
			iconify_Current_Transation := application.Connections(cur_connection).Sessions(cur_sessions_loop).findById("wnd[0]")
			iconify_Current_Transation.iconify ; Get the window and minimize it (all the screens)
			Current_Transaction := application.Connections(cur_connection).Sessions(cur_sessions_loop)
			var_transaction := Current_Transaction.Info.Transaction ;Get the transaction of the open session
			if(Current_Transaction.Info.Transaction = "SESSION_MANAGER"){ ; If the current transaction is SESSION_MANAGER
				if(i = true){ ; We found a screen
					iconify_Current_Transation.maximize ;maximize the screen
					sleep 200
					iconify_Current_Transation.SetFocus ; focus it after it has been maximized, it can now be used!
					i := false
				}
			}
		}
	}
	if(i = true){
		MsgBox, 16, "All screens are busy"
		return false
	} else {
		return true
	}
}
getSAPsessionActive(){
	If	!IsObject(_oSAP)
	{
		_oSAP := ComObjGet("SAPGUI").GetScriptingEngine  ; Get the Already Running Instance 
		Session := _oSAP.ActiveSession 
		return Session
	} else {
		return false
	}
	
}
getSAPApplication(){
	If	!IsObject(_oSAP)
	{
		_oSAP := ComObjGet("SAPGUI").GetScriptingEngine  ; Get the Already Running Instance 
		Session := _oSAP
		return Session
	} else {
		return false
	}
}