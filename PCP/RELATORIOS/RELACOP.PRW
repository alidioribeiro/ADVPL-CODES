#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

//Alterado por : Márcio Macedo - 09/06/2020
//Para se adequar ao novo modelo de relatorio para Excel
User Function RelAcOP

Local oReport

Private cPerg := "NIPPON02"
Private oTable as object

oReport := ReportDef()
oReport:PrintDialog()

if !Empty(oTable)
   oTable:Delete()
Endif

Return

***********************************************************************************************************************

Static Function ReportDef()
Local oReport
Local oSection1

Private cAlias as char

oReport := TReport():New("RelAcOP","Relatório Acompanhamento de OP",cPerg,{|oReport| ReportPrint(oReport)},"Acompanhamento de OP")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Relatório de Acompanhamento de OP")

TRCell():New(oSection1,"OP"			   ,	  ,"OP"		    ,,11		,.F.,)
TRCell():New(oSection1,"PRODUTO"	   ,	  ,"PRODUTO"	,,15	,.F.,)
TRCell():New(oSection1,"DESCRICAO"     ,	  ,"DESCRICAO"	,,50	,.F.,)
TRCell():New(oSection1,"CC"			   ,	  ,"CC"		  	,,09	,.F.,)
TRCell():New(oSection1,"QTDOP"	       ,	  ,"QTDOP"		,,14	,.F.,)
TRCell():New(oSection1,"PRODUZIDO"	   ,	  ,"PRODUZIDO"	,,14	,.F.,)
TRCell():New(oSection1,"PERDA_LIB"	   ,	  ,"PERDA_LIB"	,,14	,.F.,)
TRCell():New(oSection1,"PERDA_APR"	   ,	  ,"PERDA_APR" 	,,14	,.F.,)

oSection1:Cell("OP"		  	):SetHeaderAlign("CENTER")
oSection1:Cell("PRODUTO"	):SetHeaderAlign("CENTER")
oSection1:Cell("DESCRICAO"	):SetHeaderAlign("CENTER")
oSection1:Cell("CC"			):SetHeaderAlign("CENTER")
oSection1:Cell("QTDOP"		):SetHeaderAlign("CENTER")
oSection1:Cell("PRODUZIDO"	):SetHeaderAlign("CENTER")
oSection1:Cell("PERDA_LIB"	):SetHeaderAlign("CENTER")
oSection1:Cell("PERDA_APR"	):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local aDados[11]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"OP"        ,"C",11,0})
AADD(aCampos, {"PRODUTO"   ,"C",15,0})
AADD(aCampos, {"DESCRICAO" ,"C",50,0})
AADD(aCampos, {"CC"        ,"C",09,0})
AADD(aCampos, {"QTDOP"     ,"N",14,2})
AADD(aCampos, {"PRODUZIDO" ,"N",14,2})
AADD(aCampos, {"PERDA_LIB" ,"N",14,2})
AADD(aCampos, {"PERDA_APR" ,"N",14,4})

oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"OP"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("OP"	        ):SetBlock( { || aDados[1 ]	})
oSection1:Cell("PRODUTO"    ):SetBlock( { || aDados[2 ]	})
oSection1:Cell("DESCRICAO"  ):SetBlock( { || aDados[3 ]	})
oSection1:Cell("CC"			):SetBlock( { || aDados[4 ]	})
oSection1:Cell("QTDOP"		):SetBlock( { || aDados[5 ]	})
oSection1:Cell("PRODUZIDO"	):SetBlock( { || aDados[6 ]	})
oSection1:Cell("PERDA_LIB"	):SetBlock( { || aDados[7 ]	})
oSection1:Cell("PERDA_APR"	):SetBlock( { || aDados[8 ]	})

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Relatório de Acompanhamento de OP"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ] := TRX->OP
	aDados[2 ] := TRX->PRODUTO
	aDados[3 ] := TRX->DESCRICAO
	aDados[4 ] := TRX->CC
	aDados[5 ] := TRX->QTDOP
	aDados[6 ] := TRX->PRODUZIDO
	aDados[7 ] := TRX->PERDA_LIB
	aDados[8 ] := TRX->PERDA_APR

	oSection1:PrintLine()

	TRX->(DbSelectArea(TRX))		
	TRX->(DbSkip())

EndDo

oSection1:Finish()  

TRX->(DbSelectArea(TRX))
TRX->(dbCloseArea())

Return

***********************************************************************************************************************

//Faz o processament e criacao da tabela para impressao
Static Function PesqReg()
Local cQuery:=""

cQuery:= " SELECT C2_FILIAL, C2_CC,(C2_NUM+C2_ITEM+C2_SEQUEN) OP , C2_PRODUTO, B1_DESC,  SUM(C2_QUANT) QTD_PRODUCAO, "
cQuery+=" 	ISNULL((SELECT SUM(D3_QUANT) QTD_PRODUZIDA "
cQuery+=" 		FROM SD3010 (NOLOCK) "
cQuery+=" 		WHERE D_E_L_E_T_ <> '*' "
cQuery+=" 		AND D3_CF = 'PR0' "
cQuery+=" 		AND D3_ESTORNO ='' "
cQuery+=" 		AND D3_OP = (C2_NUM+C2_ITEM+C2_SEQUEN) "
cQuery+=" 		AND D3_COD = C2_PRODUTO "
cQuery+=" 		GROUP BY D3_FILIAL, D3_OP, D3_COD "
cQuery+=" 	),0) QTD_PRODUZIDA, "
cQuery+=" 	ISNULL((SELECT SUM(ZZ6_QUANT) QTD_PENDENTE "
cQuery+=" 		FROM ZZ6010 (NOLOCK) "
cQuery+=" 		WHERE D_E_L_E_T_ <> '*' "
cQuery+=" 		AND ZZ6_OP = (C2_NUM+C2_ITEM+C2_SEQUEN) "
cQuery+=" 		AND ZZ6_PRODUT = C2_PRODUTO "
cQuery+=" 		AND ZZ6_STATUS = '' "
cQuery+=" 		GROUP BY ZZ6_FILIAL, ZZ6_OP, ZZ6_PRODUT "
cQuery+=" 	),0) QTD_PENDENTE, "
cQuery+=" 	ISNULL((SELECT SUM(BC_QUANT) QTD_PERDA "
cQuery+=" 		FROM SBC010 (NOLOCK) "
cQuery+=" 		WHERE D_E_L_E_T_ <> '*' "
cQuery+=" 		AND BC_OP = (C2_NUM+C2_ITEM+C2_SEQUEN) "
cQuery+=" 		AND BC_PRODUTO = C2_PRODUTO "
cQuery+=" 		GROUP BY BC_FILIAL, BC_OP, BC_PRODUTO "
cQuery+=" 	 ),0) QTD_PERDA "
cQuery+=" FROM SC2010 A (NOLOCK), SB1010 B (NOLOCK) "
cQuery+=" WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
cQuery+=" AND C2_FILIAL = B1_FILIAL "
cQuery+=" AND C2_PRODUTO = B1_COD "
cQuery+=" AND C2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' "
cQuery+=" AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+=" GROUP BY C2_FILIAL, C2_CC, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, B1_DESC "
cQuery+=" ORDER BY C2_NUM "

TCQUERY cQuery New Alias "TMP" 

DbSElectArea("TMP")                                                      
DbGotop()                        		

While !TMP->(Eof())      
	RecLock("TRX",.T.)
		TRX->OP        := TMP->OP
		TRX->PRODUTO   := TMP->C2_PRODUTO
		TRX->DESCRICAO := TMP->B1_DESC
		TRX->CC        := TMP->C2_CC
		TRX->QTDOP     := TMP->QTD_PRODUCAO
		TRX->PRODUZIDO := TMP->QTD_PRODUZIDA
		TRX->PERDA_LIB := TMP->QTD_PENDENTE
		TRX->PERDA_APR := TMP->QTD_PERDA
	Msunlock()
   TMP->( DbsKip() )           
Enddo

TMP->(DbcloseArea())

Return
    