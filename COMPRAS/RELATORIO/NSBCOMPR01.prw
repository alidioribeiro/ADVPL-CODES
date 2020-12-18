#include "Protheus.ch"

User Function NSBCOMPR01()

	If _GetTela() == 1     
     
     _cFile := Alltrim(mv_par03) + iIf( SUBSTR(mv_par03,1)='/','','/'  )  + 'NSBCOMPR01.CSV'
     _cTitulo := "Doc Entrada X CTE - " + " Periodo de: "+ALLTRIM(DTOC(mv_par01)+" a "+DTOC(mv_par02))
     
     
     
     MsgRun('Processando Dados, Aguarde...',,{|| u_TblToExcel(_GetQry(),_cFile,,_cTitulo ) } )
  EndIf

Return

Static Function _GetTela()

Local cTitulo:= ''
Local cDesc1 := ' Esta Rotina tem Por Objetivo Efetuar a Impressão'
Local cDesc2 := ' dos Docs de Entrada x CTE'
Local cDesc3 := ' '
Local aSay   := {}
Local aButton:= {}
Local _cPerg := PADR('NSBCOMPR01',Len(SX1->X1_GRUPO))

ValidPerg(_cPerg)
Pergunte(_cPerg,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

nOpc := 0

aAdd( aButton, { 5, .T., {|x| Pergunte(_cPerg)       }} )
aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

FormBatch( cTitulo, aSay, aButton )

Return nOpc

Static Function ValidPerg(cPerg)
   PutSX1(cPerg,"01","Data De? "  , "Data De? "  , "Data De? "  , "mv_ch1" , "D" , 08, 0, 0, "G","",""   ,"","","mv_par01")
   PutSX1(cPerg,"02","Data Ate? " , "Data Ate? " , "Data Ate? " , "mv_ch2" , "D" , 08, 0, 0, "G","",""   ,"","","mv_par02")
   PutSX1(cPerg,"03", Padr("Diretorio",29) + "?", "", "", "mv_ch3", "C", 99, 0, 0, "G", "", "  ", "", "", "mv_par03")
   PutSX1(cPerg,"04","Fornecedor de ? " , "Fornecedor de ? " , "Fornecedor de ? " , "mv_ch4" , "C" , 06, 0, 0, "G","",""   ,"","","mv_par04")
   PutSX1(cPerg,"05","Fornecedor ate ? " , "Fornecedor ate ? " , "Fornecedor ate ? " , "mv_ch5" , "C" , 06, 0, 0, "G","",""   ,"","","mv_par05")
Return Nil

Static Function _GetQry()
Local _cQry := ""
Local _cTbl := GetNextAlias()

_cQry += " SELECT F1_FILIAL, F1_EMISSAO, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, F1_ESPECIE, VALOR_NF, F8_NFDIFRE, F8_SEDIFRE, F8_DTDIGIT, F8_TRANSP, F8_LOJTRAN, NOME_TRANSP, VALOR_CTE, ESPECIE_CTE
_cQry += "	FROM (

_cQry += "		SELECT F1_FILIAL, F1_DOC, F1_EMISSAO,F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, F1_ESPECIE, F1_VALBRUT VALOR_NF FROM " + RetSqlName('SF1') + " SF1
_cQry += "		 LEFT JOIN " + RetSqlName('SA2') + " SA2 ON SA2.D_E_L_E_T_ = '' AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA
_cQry += "		 WHERE SF1.D_E_L_E_T_= ''
_cQry += "		 ) A
_cQry += "		 LEFT JOIN (
_cQry += "					SELECT  F8_FILIAL, F8_NFDIFRE, F8_SEDIFRE, F8_DTDIGIT, F8_TRANSP, F8_LOJTRAN, A2_NOME NOME_TRANSP, F8_NFORIG, F1_VALBRUT VALOR_CTE, F1_ESPECIE ESPECIE_CTE FROM " + RetSqlName('SF8') + " SF8
_cQry += "					LEFT JOIN " + RetSqlName('SA2') + " SA2A ON SA2A.D_E_L_E_T_ = '' AND A2_COD = F8_TRANSP AND A2_LOJA = F8_LOJTRAN
_cQry += "					INNER JOIN " + RetSqlName('SF1') + " SF1A ON SF1A.D_E_L_E_T_ = '' AND F1_DOC = F8_NFDIFRE AND F1_SERIE = F8_SEDIFRE 

_cQry += "					WHERE SF8.D_E_L_E_T_ =	''

_cQry += "					) B ON F8_NFORIG = F1_DOC 
	

_cQry += "		WHERE F1_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "'
_cQry += "		AND F1_FORNECE BETWEEN  '" + mv_par04 + "' And '" +  mv_par05 + "'"  
_cQry += "		AND F8_NFDIFRE IS NOT NULL

_cQry += "	GROUP BY F1_FILIAL, F1_EMISSAO, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, A2_NOME, F1_ESPECIE, VALOR_NF, F8_NFDIFRE, F8_SEDIFRE, F8_DTDIGIT, F8_TRANSP, F8_LOJTRAN, NOME_TRANSP, VALOR_CTE	, ESPECIE_CTE
_cQry += "	ORDER BY F1_EMISSAO

MEMOWRITE('NSBCOMPR01',_cQry)
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(_cQry)), _cTbl, .T., .F. )

u_AtuStruct(_cTbl)

Return _cTbl

User Function AtuStruct(_cTbl)
   Local _aStru  :=  (_cTbl)->(dbStruct())
   
   For nI := 1 To Len(_aStru)
	   If _ChkCpo( _aStru[nI][01] )
	     IF _aStru[nI][02] != SX3->X3_TIPO
	        tcSetField(_cTbl, _aStru[nI][01] , SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL )
	     EndIf
	   EndIf
   Next
Return Nil

Static Function _Convert(_xRec,_xcpo)
  Local _xRet := ''
  Local _ctype := valtype(_xRec)
  
  if _cType == 'N'
     _xRet := Transform(_xRec,"@E 999,999,999.99")
  elseIf _cType == 'D'
    _xRet := DTOC(_xRec)
  Else
    _xRet := _xRec
  EndIF
  
Return _xRet

User Function TblToExcel(_cTbl, _cFile,_aCab,_cTitulo)
Local _aStru  :=  (_cTbl)->(dbStruct())
Local _aCabec := {}
Local _aDados := {} 
Local _aLin   := {}

Default _aCab := {}
Default _cTitulo := ''

IF !(_cTbl)->(Eof())
   For nI := 1 To Len(_aStru)
      IF _ChkCpo(_aStru[nI][01])
           _cAdd := SX3->X3_TITULO
      Else 
           _cdCp := _aStru[nI][01]
           _nPos := aScan(_aCab,{|y| y[01] == _cdCp })
           _cAdd :=  iIF(_nPos > 0, _aCab[_nPos,02], StrTran(_aStru[nI][01],"_"," ") ) 
      EndIf
      aAdd(_aCabec,_cAdd)
   Next
	
	While !(_cTbl)->(Eof())
	   aEval(_aStru,{|x| aAdd(_aLin, _Convert( (_cTbl)->&(x[01]) , x[01] )     )  })
	   
	   aAdd(_aDados,_aLin)
	   _aLin := {}
	   (_cTbl)->(dbSkip())
	EndDo
		
	ToExcel( _aCabec , _aDados , _cFile,_cTitulo)
	
Else
   Aviso('Atenção','Periodo Informado sem Dados para a Filial',{'Ok'})
EndIf 

Return Nil

Static Function _ChkCpo(_cCpo)
Local _lRet := .F.
   
   SX3->(dbgoTop())
   SX3->(dbSetOrder(2))
   _lRet := SX3->(dbSeek(Alltrim(_cCpo)))
   
Return _lRet

Static Function ToExcel( aCabec,aDados , _cFile,_cTit)

IF File(_cFile)
	fErase( _cFile )
EndIf
nHdl := fCreate(_cFile)

fWrite(nHdl, _cTit + Chr(13)+Chr(10) )
//For _nI := 1 to Len(aCabec)
    _cCabec := ""
	aEval(aCabec,{|c| _cCabec += c + ";" })
	_cCabec := SubStr(_cCabec,1,len(_cCabec) - 1) + Chr(13)+Chr(10)
	fWrite(nHdl, _cCabec )
//Next

For nI := 1 to Len(aDados)
	_cLine := ""
	aEval(aDados[nI], {|x|  _cLine += x + ";" })
	_cLine := SubStr(_cLine,1,len(_cLine) - 1) + Chr(13)+Chr(10)
	fWrite(nHdl, _cLine )
Next
fClose(nHdl) 
RunExcel(_cFile)
Return

Static Function RunExcel(cwArq)
Local oExcelApp
Local aNome := {}

If ! ApOleClient( 'MsExcel' ) //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf
oExcelApp := MsExcel():New()  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cwArq)
oExcelApp:SetVisible(.T.)     // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()

Return