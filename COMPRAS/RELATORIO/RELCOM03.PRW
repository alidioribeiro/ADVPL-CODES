#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

//Alterado por : Bruno Freitas Pacheco - 22/06/2020
// Relatório Tabela de Precos.
//Para se adequar ao novo modelo de relatorio para Excel
User Function RELCOM03

Local oReport

Private cPerg := "NIPPON06"
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

oReport := TReport():New("RELCOM03","Relatório Tabela de Precos de Compras ",cPerg,{|oReport| ReportPrint(oReport)},"Tabela de Precos de Compras")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Tabela de Precos de Compras")

TRCell():New(oSection1,"TAB"	        ,	  ,"TAB"           ,,11	,.F.,)
TRCell():New(oSection1,"PRODUTO"	    ,	  ,"PRODUTO"	   ,,15	,.F.,)
TRCell():New(oSection1,"DESCRICAO"      ,	  ,"DESCRICAO"	   ,,50	,.F.,)
TRCell():New(oSection1,"DESCRI_TAB"     ,     ,"DESCRI_TAB"    ,,30	,.F.,)
TRCell():New(oSection1,"FORNECEDOR"	    ,	  ,"FORNECEDOR"	   ,,06	,.F.,)
TRCell():New(oSection1,"NOME"	        ,	  ,"NOME"	       ,,40	,.F.,)
TRCell():New(oSection1,"PGTO"	        ,	  ,"PGTO"	       ,,15	,.F.,)
TRCell():New(oSection1,"MOEDA"	        ,	  ,"MOEDA"	       ,,02	,.F.,)
TRCell():New(oSection1,"PRI_UNID"	    ,	  ,"PRI_UNID"	   ,,02	,.F.,)
TRCell():New(oSection1,"SEG_UNI"	    ,	  ,"SEG_UNI"	   ,,02	,.F.,)
TRCell():New(oSection1,"PRECO"	        ,	  ,"PRECO"	       ,,14	,.F.,)
TRCell():New(oSection1,"VIGENCIA"	    ,	  ,"VIGENCIA"	   ,,08	,.F.,)


 
oSection1:Cell("TAB"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("PRODUTO"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("DESCRICAO"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("DESCRI_TAB"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("FORNECEDOR"    ):SetHeaderAlign("CENTER")
oSection1:Cell("NOME"		   ):SetHeaderAlign("CENTER")
oSection1:Cell("PGTO"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("MOEDA"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("PRI_UNID"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("SEG_UNI"	   ):SetHeaderAlign("CENTER")
oSection1:Cell("PRECO"	       ):SetHeaderAlign("CENTER")
oSection1:Cell("VIGENCIA"	   ):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local aDados[12]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"TAB"                ,"C",03,0})
AADD(aCampos, {"PRODUTO"            ,"C",15,0})
AADD(aCampos, {"DESCRICAO"          ,"C",50,0})
AADD(aCampos, {"DESCRI_TAB"         ,"C",30,0})
AADD(aCampos, {"FORNECEDOR"         ,"C",06,0})
AADD(aCampos, {"NOME"               ,"C",40,0})
AADD(aCampos, {"PGTO"               ,"C",15,0})
AADD(aCampos, {"MOEDA"              ,"N",02,0})
AADD(aCampos, {"PRI_UNID"           ,"C",02,0})
AADD(aCampos, {"SEG_UNI"            ,"C",02,0})
AADD(aCampos, {"PRECO"              ,"N",14,6})
AADD(aCampos, {"VIGENCIA"           ,"D",08,0})


oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"TAB"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("TAB"	            ):SetBlock( { || aDados[1 ]	})
oSection1:Cell("PRODUTO"            ):SetBlock( { || aDados[2 ]	})
oSection1:Cell("DESCRICAO"          ):SetBlock( { || aDados[3 ]	})
oSection1:Cell("DESCRI_TAB"	        ):SetBlock( { || aDados[4 ]	})
oSection1:Cell("FORNECEDOR"		    ):SetBlock( { || aDados[5 ]	})
oSection1:Cell("NOME"	            ):SetBlock( { || aDados[6 ]	})
oSection1:Cell("PGTO"	            ):SetBlock( { || aDados[7 ]	})
oSection1:Cell("MOEDA"	            ):SetBlock( { || aDados[8 ]	})
oSection1:Cell("PRI_UNID"	        ):SetBlock( { || aDados[9 ]	})
oSection1:Cell("SEG_UNI"	        ):SetBlock( { || aDados[10]	})
oSection1:Cell("PRECO"	            ):SetBlock( { || aDados[11]	})
oSection1:Cell("VIGENCIA"	        ):SetBlock( { || aDados[12]	})

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Tabela de Precos de Compras"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ]  := TRX->TAB
	aDados[2 ]  := TRX->PRODUTO
	aDados[3 ]  := TRX->DESCRICAO
	aDados[4 ]  := TRX->DESCRI_TAB
	aDados[5 ]  := TRX->FORNECEDOR
	aDados[6 ]  := TRX->NOME
	aDados[7 ]  := TRX->PGTO
    aDados[8 ]  := TRX->MOEDA
    aDados[9 ]  := TRX->PRI_UNID
    aDados[10 ] := TRX->SEG_UNI
	aDados[11 ] := TRX->PRECO
	aDados[12 ] := TRX->VIGENCIA


	

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

cQuery:="SELECT  AIB_CODTAB TAB,AIB_CODPRO PRODUTO,B1_DESC DESCRICAO ,AIA_DESCRI DESCRI_TAB,A2_COD FORNECEDOR,A2_NREDUZ NOME ,E4_DESCRI PGTO,AIB_MOEDA MOEDA,B1_UM PRI_UNID,B1_SEGUM SEG_UNI,AIB_PRCCOM PRECO,AIB_DATVIG VIGENCIA "
cQuery+="        FROM AIA010 A(NOLOCK), AIB010 B(NOLOCK),SE4010 C(NOLOCK),SB1010 D(NOLOCK),SA2010 F(NOLOCK) "
cQuery+="WHERE AIA_DATATE=''  AND A.D_E_L_E_T_<>'*' AND B.D_E_L_E_T_<>'*' AND C.D_E_L_E_T_<>'*' AND D.D_E_L_E_T_<>'*' "
cQuery+="	AND AIA_CODTAB= AIB_CODTAB "
cQuery+="	AND AIA_CODFOR= AIB_CODFOR "
cQuery+="	AND AIA_CONDPG= E4_CODIGO "
cQuery+="	AND AIB_CODPRO= B1_COD "
cQuery+="	AND AIB_LOJFOR= AIA_LOJFOR "
cQuery+="	AND AIB_CODFOR= A2_COD "
cQuery+="	AND AIB_LOJFOR= A2_LOJA "
cQuery+="	AND AIA_FILIAL= AIB_FILIAL "
cQuery+="   AND AIB_CODTAB BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+="   AND A2_COD     BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery+="ORDER BY AIA_CODTAB,AIB_CODFOR,AIB_CODPRO "

TCQUERY cQuery New Alias "TMP" 

DbSElectArea("TMP")                                                      
DbGotop()                        		

While !TMP->(Eof())      
	RecLock("TRX",.T.)
		TRX->TAB           := TMP->TAB
		TRX->PRODUTO       := TMP->PRODUTO
		TRX->DESCRICAO     := TMP->DESCRICAO
		TRX->DESCRI_TAB    := TMP->DESCRI_TAB
		TRX->FORNECEDOR    := TMP->FORNECEDOR
		TRX->NOME          := TMP->NOME
		TRX->PGTO          := TMP->PGTO
		TRX->MOEDA         := TMP->MOEDA
		TRX->PRI_UNID      := TMP->PRI_UNID
		TRX->SEG_UNI       := TMP->SEG_UNI
     	TRX->PRECO         := TMP->PRECO
		TRX->VIGENCIA      := stod(TMP->VIGENCIA)
		
	Msunlock()
   TMP->( DbsKip() )           
Enddo

TMP->(DbcloseArea())

Return
    