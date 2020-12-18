#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

//Criado por : Bruno Freitas Pacheco - 27/08/2020
// RELATÓRIO PARA CALCULO DE SEGURO DE MERCADORIA TRANSPORTADA.
//Para se adequar ao novo modelo de relatorio para Excel
User Function RELFATSEG

Local oReport

Private cPerg := "NIPPON09"
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

oReport := TReport():New("RELFATSEG","Relatório Para Calculo de Seguro de Mercadoria",cPerg,{|oReport| ReportPrint(oReport)},"Calculo de Seguro de Mercadoria")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.T.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Relatório Para Calculo de Seguro de Mercadoria")
oSection1 :SetTotalInLine(.T.)

TRCell():New(oSection1,"LOJA"	        ,	  ,"LOJA"         ,,02	,.F.,)
TRCell():New(oSection1,"NOTA"	        ,	  ,"NOTA"         ,,09	,.F.,)
TRCell():New(oSection1,"CFOP"           ,	  ,"CFOP"	      ,,05	,.F.,)
TRCell():New(oSection1,"CLIENTE"        ,	  ,"CLIENTE"      ,,06	,.F.,)
TRCell():New(oSection1,"NOME"	        ,	  ,"NOME"	      ,,20	,.F.,)
//TRCell():New(oSection1,"TOTAL"          ,      "Loc Physical"/*Titulo*/,"@E 999,999,999.99"/*Picture*/,08/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TOTAL"	        ,	  ,"TOTAL"        ,"@E 999,999,999.99",14	,,)
TRCell():New(oSection1,"EMISSAO"	    ,	  ,"EMISSAO"      ,,08	,.F.,)


 oSection1:Cell("LOJA"	        ):SetHeaderAlign("CENTER")
oSection1:Cell("NOTA"           ):SetHeaderAlign("CENTER")
oSection1:Cell("CFOP"	        ):SetHeaderAlign("CENTER")
oSection1:Cell("CLIENTE"        ):SetHeaderAlign("CENTER")
oSection1:Cell("NOME"		    ):SetHeaderAlign("CENTER")
oSection1:Cell("TOTAL"	        ):SetHeaderAlign("CENTER")
oSection1:Cell("EMISSAO"   	    ):SetHeaderAlign("CENTER")


oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

TRFunction():New(oSection1:Cell("TOTAL"),NIL,"SUM",/*oBreak*/,,"@E 999,999,999.99",/*uFormula*/,.T.,.T.,,oSection1)

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local aDados[11]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"LOJA"              ,"C",02,0})
AADD(aCampos, {"NOTA"              ,"C",09,0})
AADD(aCampos, {"CFOP"              ,"C",05,0})
AADD(aCampos, {"CLIENTE"           ,"C",06,0})
AADD(aCampos, {"NOME"              ,"C",20,0})
AADD(aCampos, {"TOTAL"             ,"N",14,2})
AADD(aCampos, {"EMISSAO"           ,"D",08,0})


oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"LOJA"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("LOJA"             ):SetBlock( { || aDados[1 ]	})
oSection1:Cell("NOTA"             ):SetBlock( { || aDados[2 ]	})
oSection1:Cell("CFOP"             ):SetBlock( { || aDados[3 ]	})
oSection1:Cell("CLIENTE"	   	  ):SetBlock( { || aDados[4 ]	})
oSection1:Cell("NOME"		      ):SetBlock( { || aDados[5 ]	})
oSection1:Cell("TOTAL"	          ):SetBlock( { || aDados[6 ]	})
oSection1:Cell("EMISSAO"	      ):SetBlock( { || aDados[7 ]	})

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Relatório Para Calculo de Seguro de Mercadoria"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ] := TRX->LOJA
	aDados[2 ] := TRX->NOTA
	aDados[3 ] := TRX->CFOP
	aDados[4 ] := TRX->CLIENTE
	aDados[5 ] := TRX->NOME
	aDados[6 ] := TRX->TOTAL
	aDados[7 ] := TRX->EMISSAO
	

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

cQuery:= "SELECT    D2_LOJA  LOJA,D2_DOC  NOTA,D2_CF  CFOP,D2_CLIENTE  CLIENTE,A1_NREDUZ NOME, SUM( D2_TOTAL) AS TOTAL,D2_EMISSAO EMISSAO "
cQuery+= " FROM SD2010  D2 INNER JOIN SA1010  A1 " 
cQuery+= " ON A1.A1_COD= D2.D2_CLIENTE AND D2.D2_LOJA= A1.A1_LOJA " 
cQuery+= " AND D2.D_E_L_E_T_<>'*' " 
cQuery+= " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' " 
cQuery+= " AND D2_CLIENTE IN('081','148') "
//cQuery+= " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery+= " AND D2_TIPO='N' "
cQuery+= " GROUP BY D2_LOJA, D2_DOC,D2_CF ,D2_CLIENTE ,A1_NREDUZ ,D2_EMISSAO " 
cQuery+= " ORDER BY 5,7 "



TCQUERY cQuery New Alias "TMP" 

DbSElectArea("TMP")                                                      
DbGotop()                        		

While !TMP->(Eof())      
	RecLock("TRX",.T.)
		TRX->LOJA             := TMP->LOJA
		TRX->NOTA             := TMP->NOTA
		TRX->CFOP             := TMP->CFOP
		TRX->CLIENTE          := TMP->CLIENTE
		TRX->NOME             := TMP->NOME
		TRX->TOTAL            := TMP->TOTAL
		TRX->EMISSAO          := stod(TMP->EMISSAO)
				
		
	Msunlock()
   TMP->( DbsKip() )           
Enddo

TMP->(DbcloseArea())

Return
    