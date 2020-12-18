#INclude "Protheus.ch"
User Function UPDFV

_cdFile := "G:\TOTVS\UPDFV.INI"
_cdArquivo := _cdFile

If Empty(_cdArquivo)
	Return
EndIf


If !File(_cdArquivo)
Alert("Arquivo: " + _cdArquivo + " Nao Encontrado")
Return
EndIf

nHdl := FT_FUse(_cdArquivo)
FT_FGOTOP()
While !FT_FEOF()
	_cdFunc := FT_FREADLN()
	IF !FindFunction(_cdFunc)
		If Left(_cdFunc,2) != "u_"
			_cdFunc := "u_"+_cdFunc
			_lExecuta := FindFunction(_cdFunc)
		EndIf
	Else
		_lExecuta := .T.
	EndIf
	iF _lExecuta
		conout("Executanto : " + _cdFunc)
		WaitRun("G:\TOTVS\Protheus11\Bin_COMP\SmartClient\SmartClient.exe -e=CP -M -Q -c=TCP -P="+_cdFunc, 1 )
	EndIf
	FT_FSKIP()
	
EndDo
Alert( 'Concluido' )
REturn Nil
