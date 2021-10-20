#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
SetCursorScheme( Scheme )               { ; By SKAN on D3AO/D3AO @ tiny.cc/setcursorscheme
Local
  Cursors := "Arrow,Help,AppStarting,Wait,Crosshair,IBeam,NWPen,No,SizeNS,"
           . "SizeWE,SizeNWSE,SizeNESW,SizeAll,UpArrow,Hand,Pin,Person"

  SchemePath2 := "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors"
  SchemePath1 := "HKCU\Control Panel\Cursors"
  SetRegView, 64

  If ( Scheme="Windows Default" )
  {
      RegWrite, REG_SZ,    %SchemePath1%,, Windows Default
      RegWrite, REG_DWORD, %SchemePath1%, Scheme Source, 2
      Loop, Parse, Cursors, CSV
      {
          RegRead, Val, %SchemePath2%\Default, %A_LoopField%
          If (! ErrorLevel )
          RegWrite, REG_EXPAND_SZ, %SchemePath1%, %A_LoopField%, %Val%
      }

      SetRegView, Default
      Return DllCall("SystemParametersInfo", "Int",0x57, "Int", 0, "Ptr", 0, "Int", 0)
  }

  SchemeSource := 2
  RegRead, Val, %SchemePath2%\Schemes, %Scheme%

  If ( ErrorLevel )
  {
      SchemeSource := 1
      RegRead, Val, %SchemePath1%\Schemes, %Scheme%
  }

  If ( ErrorLevel )
      SchemeSource := 0,    Scheme := ""

  Cur := StrSplit(Val, ",")
  RegWrite, REG_DWORD, %SchemePath1%, Scheme Source, %SchemeSource%
  RegWrite, REG_SZ, %SchemePath1%,, %Scheme%

  Loop, Parse, Cursors, CSV
  {
      RegRead, Val, %SchemePath2%\Default, %A_LoopField%
      If (! ErrorLevel )
          RegWrite, REG_EXPAND_SZ, %SchemePath1%, %A_LoopField%, % Cur[A_Index]
  }

  SetRegView, Default
Return DllCall("SystemParametersInfo", "Int",0x57, "Int", 0, "Ptr", 0, "Int", 0)
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GetCursorSchemes() {
Local Schemes := ""
  SetRegView, 64
  Loop, Reg
      , HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors\Schemes, V
   Schemes .= A_LoopRegName . "`n"
  Loop, Reg, HKCU\Control Panel\Cursors\Schemes, V
   Schemes .= A_LoopRegName . "`n"
  SetRegView, Default
Return RTrim(Schemes, "`n")
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -