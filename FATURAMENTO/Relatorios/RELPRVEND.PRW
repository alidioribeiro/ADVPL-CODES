#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

//Alterado por : Bruno Freitas Pacheco - 10/07/2020
// Relatório Tabela de Precos De Vendas.
//Para se adequar ao novo modelo de relatorio para Excel
User Function RELPRVEND

Local oReport

Private cPerg := "NIPPON07"
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

oReport := TReport():New("RELPRVEND","Relatório Tabela de Precos de Vendas ",cPerg,{|oReport| ReportPrint(oReport)},"Tabela de Precos de Vendas")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Tabela de Precos de Vendas")

TRCell():New(oSection1,"ITEM"	        ,	  ,"ITEM"          ,,04	,.F.,)
TRCell():New(oSection1,"TAB"	        ,	  ,"TAB"	       ,,03	,.F.,)
TRCell():New(oSection1,"NOME_TAB"       ,	  ,"NOME_TAB"	   ,,30	,.F.,)
TRCell():New(oSection1,"CODIGO"         ,     ,"CODIGO"        ,,06	,.F.,)
TRCell():New(oSection1,"CLIENTE"	    ,	  ,"CLIENTE"	   ,,20	,.F.,)
TRCell():New(oSection1,"PRODUTO"	    ,	  ,"PRODUTO"	   ,,15	,.F.,)
TRCell():New(oSection1,"CODCLIENT"	    ,	  ,"CODCLIENT"     ,,20	,.F.,)
TRCell():New(oSection1,"DESCRICAO"	    ,	  ,"DESCRICAO"	   ,,50	,.F.,)
TRCell():New(oSection1,"PRI_UN"	        ,	  ,"PRI_UN"	       ,,02	,.F.,)
TRCell():New(oSection1,"PRECO"	        ,	  ,"PRECO"	       ,,09	,.F.,)
TRCell():New(oSection1,"PGTO"	        ,	  ,"PGTO"	       ,,02	,.F.,)
TRCell():New(oSection1,"VIGENCIA"	    ,	  ,"VIGENCIA"	   ,,02	,.F.,)
TRCell():New(oSection1,"DTINICIO"	    ,	  ,"DTINICIO"      ,,02	,.F.,)
  

 
oSection1:Cell("ITEM"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("TAB"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("NOME_TAB"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("CODIGO"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("CLIENTE"       ):SetHeaderAlign("CENTER")
oSection1:Cell("PRODUTO"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("CODCLIENT"     ):SetHeaderAlign("CENTER")
oSection1:Cell("DESCRICAO"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("PRI_UN"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("PRECO"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("PGTO"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("VIGENCIA"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("DTINICIO"      ):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local aDados[13]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"ITEM"               ,"C",04,0})
AADD(aCampos, {"TAB"                ,"C",03,0})
AADD(aCampos, {"NOME_TAB"           ,"C",30,0})
AADD(aCampos, {"CODIGO"             ,"C",06,0})
AADD(aCampos, {"CLIENTE"            ,"C",20,0})
AADD(aCampos, {"PRODUTO"            ,"C",15,0})
AADD(aCampos, {"CODCLIENT"          ,"C",20,0})
AADD(aCampos, {"DESCRICAO"          ,"C",50,0})
AADD(aCampos, {"PRI_UN"             ,"C",02,0})
AADD(aCampos, {"PRECO"              ,"N",09,2})
AADD(aCampos, {"PGTO"               ,"C",50,0})
AADD(aCampos, {"VIGENCIA"           ,"D",08,0})
AADD(aCampos, {"DTINICIO"           ,"D",08,0})


oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"ITEM"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("ITEM"	            ):SetBlock( { || aDados[1 ]	})
oSection1:Cell("TAB"                ):SetBlock( { || aDados[2 ]	})
oSection1:Cell("NOME_TAB"           ):SetBlock( { || aDados[3 ]	})
oSection1:Cell("CODIGO"	            ):SetBlock( { || aDados[4 ]	})
oSection1:Cell("CLIENTE"		    ):SetBlock( { || aDados[5 ]	})
oSection1:Cell("PRODUTO"	        ):SetBlock( { || aDados[6 ]	})
oSection1:Cell("CODCLIENT"	        ):SetBlock( { || aDados[7]	})
oSection1:Cell("DESCRICAO"	        ):SetBlock( { || aDados[8]	})
oSection1:Cell("PRI_UN"	            ):SetBlock( { || aDados[9]	})
oSection1:Cell("PRECO"	            ):SetBlock( { || aDados[10]	})
oSection1:Cell("PGTO"	            ):SetBlock( { || aDados[11]	})
oSection1:Cell("VIGENCIA"	        ):SetBlock( { || aDados[12]	})
oSection1:Cell("DTINICIO"	        ):SetBlock( { || aDados[13]	})

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Tabela de Precos de Vendas"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ] := TRX->ITEM
	aDados[2 ] := TRX->TAB
	aDados[3 ] := TRX->NOME_TAB
	aDados[4 ] := TRX->CODIGO
	aDados[5 ] := TRX->CLIENTE
	aDados[6 ] := TRX->PRODUTO
	aDados[7 ] := TRX->CODCLIENT
	aDados[8 ] := TRX->DESCRICAO
	aDados[9 ] := TRX->PRI_UN
	aDados[10] := TRX->PRECO
	aDados[11] := TRX->PGTO
	aDados[12] := TRX->VIGENCIA
	aDados[13] := TRX->DTINICIO



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

cQuery:="SELECT DA1_ITEM ITEM,DA0_CODTAB TAB ,DA0_DESCRI NOME_TAB,A1_COD CODIGO,A1_NREDUZ CLIENTE, DA1_CODPRO PRODUTO,B1_CODNBB CODCLIENT,B1_DESC DESCRICAO,B1_UM PRI_UN,"
cQuery+="       DA1_PRCVEN PRECO, E4_COND PGTO,DA1_DATVIG VIGENCIA,DA0_DATDE DTINICIO "
cQuery+="FROM DA0010 A,DA1010 B, SB1010 C,SA1010 D,SE4010 E "
cQuery+="WHERE DA1_DATVIG<>'' "
cQuery+="   AND A.D_E_L_E_T_<> '*'AND B.D_E_L_E_T_<>'*' "
cQuery+="   AND C.D_E_L_E_T_<>'*' AND D.D_E_L_E_T_<>'*' "
cQuery+="   AND E.D_E_L_E_T_<>'*' "
cQuery+="	AND DA0_CODTAB= DA1_CODTAB "
cQuery+="	AND DA1_CODPRO= B1_COD "
cQuery+="	AND DA0_CODTAB= A1_TABELA "
cQuery+="	AND DA0_CONDPG= E4_CODIGO "
cQuery+="	AND B1_FILIAL NOT IN('02')"
cQuery+="	AND DA1_FILIAL NOT IN('02')"
cQuery+="	AND DA0_DATATE='' " 
cQuery+="   AND DA0_CODTAB BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+="   AND A1_COD     BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery+="ORDER BY 1,3 "

TCQUERY cQuery New Alias "TMP" 

DbSElectArea("TMP")                                                      
DbGotop()                        		

While !TMP->(Eof())      
	RecLock("TRX",.T.)
		TRX->ITEM         := TMP->ITEM
		TRX->TAB          := TMP->TAB
		TRX->NOME_TAB     := TMP->NOME_TAB
		TRX->CODIGO       := TMP->CODIGO
		TRX->CLIENTE      := TMP->CLIENTE
		TRX->PRODUTO      := TMP->PRODUTO
		TRX->CODCLIENT    := TMP->CODCLIENT
		TRX->DESCRICAO    := TMP->DESCRICAO
		TRX->PRI_UN       := TMP->PRI_UN
		TRX->PRECO        := TMP->PRECO
		TRX->PGTO         := TMP->PGTO
		TRX->VIGENCIA     := stod(TMP->VIGENCIA)
		TRX->DTINICIO     := stod(TMP->DTINICIO)
	Msunlock()
   TMP->( DbsKip() )           
Enddo

TMP->(DbcloseArea())

Return
    