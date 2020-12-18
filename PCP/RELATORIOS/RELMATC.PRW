#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

//Alterado por : Márcio Macedo - 28/03/2020
//Para se adequar ao novo modelo de relatorio para Excel
User Function RelMatC

Local oReport

Private cPerg := "ESTR32"
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

oReport := TReport():New("RelMatC","Relatório de Materia-Prima no processo",cPerg,{|oReport| ReportPrint(oReport)},"Movimentação de Materia-Prima")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Relatório de Movimentação de Materia-Prima")

TRCell():New(oSection1,"ITEM"			   ,	  ,"ITEM"		      ,,6	,.F.,)
TRCell():New(oSection1,"COD"			   ,	  ,"COD"				   ,,15	,.F.,)
TRCell():New(oSection1,"DESCR"  			,	  ,"DESCR"	 			,,50	,.F.,)
TRCell():New(oSection1,"QTDINV"			,	  ,"QTDINV"		  		,,14	,.F.,)
TRCell():New(oSection1,"QTDTRANS"	   ,	  ,"QTDTRANS"		   ,,14	,.F.,)
TRCell():New(oSection1,"QTDMPUTL"		,	  ,"QTDMPUTL"			,,14	,.F.,)
TRCell():New(oSection1,"QTDPAPROD"		,	  ,"QTDPAPROD"			,,14	,.F.,)
TRCell():New(oSection1,"PERDA_MP"		,	  ,"PERDA_MP" 			,,14	,.F.,)
TRCell():New(oSection1,"PERDA_PR"		,	  ,"PERDA_PR"		   ,,14  ,.F.,)
TRCell():New(oSection1,"QTDCONS"			,	  ,"QTDCONS"			,,14  ,.F.,)
TRCell():New(oSection1,"CONSTOTAL"		,	  ,"CONSTOTAL"			,,14	,.F.,)

oSection1:Cell("ITEM"		  		):SetHeaderAlign("CENTER")
oSection1:Cell("COD"				   ):SetHeaderAlign("CENTER")
oSection1:Cell("DESCR"				):SetHeaderAlign("CENTER")
oSection1:Cell("QTDINV"				):SetHeaderAlign("CENTER")
oSection1:Cell("QTDTRANS"		   ):SetHeaderAlign("CENTER")
oSection1:Cell("QTDMPUTL"			):SetHeaderAlign("CENTER")
oSection1:Cell("QTDPAPROD"			):SetHeaderAlign("CENTER")
oSection1:Cell("PERDA_MP"			):SetHeaderAlign("CENTER")
oSection1:Cell("PERDA_PR"		   ):SetHeaderAlign("CENTER")
oSection1:Cell("QTDCONS"			):SetHeaderAlign("CENTER")
oSection1:Cell("CONSTOTAL"			):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local nOrdem 	   := oSection1:GetOrder()
Local aDados[11]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"ITEM"      ,"C",6 ,0})
AADD(aCampos, {"COD  "     ,"C",15,0})
AADD(aCampos, {"DESCR  "   ,"C",50,0})
AADD(aCampos, {"QTDINV"    ,"N",14,2})
AADD(aCampos, {"QTDTRANS"  ,"N",14,2})
AADD(aCampos, {"QTDMPUTL"  ,"N",14,2})
AADD(aCampos, {"QTDPAPROD" ,"N",14,2})
AADD(aCampos, {"PERDA_MP"  ,"N",14,4})
AADD(aCampos, {"PERDA_PR"  ,"N",14,4})
AADD(aCampos, {"QTDCONS"   ,"N",14,4})
AADD(aCampos, {"CONSTOTAL" ,"N",14,4})

oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"ITEM"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("ITEM"	      ):SetBlock( { || aDados[1 ]	})
oSection1:Cell("COD"				):SetBlock( { || aDados[2 ]	})
oSection1:Cell("DESCR"			):SetBlock( { || aDados[3 ]	})
oSection1:Cell("QTDINV"			):SetBlock( { || aDados[4 ]	})
oSection1:Cell("QTDTRANS"		):SetBlock( { || aDados[5 ]	})
oSection1:Cell("QTDMPUTL"		):SetBlock( { || aDados[6 ]	})
oSection1:Cell("QTDPAPROD"		):SetBlock( { || aDados[7 ]	})
oSection1:Cell("PERDA_MP"		):SetBlock( { || aDados[8 ]	})
oSection1:Cell("PERDA_PR"		):SetBlock( { || aDados[9 ]	})
oSection1:Cell("QTDCONS"		):SetBlock( { || aDados[10]	})
oSection1:Cell("CONSTOTAL"		):SetBlock( { || aDados[11]	})

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Relatório de Materia-Prima no processo"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ] := TRX->ITEM
	aDados[2 ] := TRX->COD
	aDados[3 ] := TRX->DESCR
	aDados[4 ] := TRX->QTDINV
	aDados[5 ] := TRX->QTDTRANS
	aDados[6 ] := TRX->QTDMPUTL
	aDados[7 ] := TRX->QTDPAPROD
	aDados[8 ] := TRX->PERDA_MP
	aDados[9 ] := TRX->PERDA_PR
	aDados[10] := TRX->QTDCONS
	aDados[11] := TRX->CONSTOTAL

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
Local cFiltro:="",cQuery:=""
Local DataI, cData, DataI, DatInv, Ender, FiltroBc,i

DataI:=substr(Dtos(mv_par07),1,6)+'01'
cData:=STod(DataI)-1
DataI:=Dtos(cData)
DatInv:=substr(DataI,1,6)
Ender:=""
FiltroBc:=""

Do Case                                                             
	Case mv_par09=1 //Injecao Plastica
       Ender+=" and B2_CC='231' "
	Case mv_par09=2 //Impressao
       Ender+=" and B2_CC='221' "
    Case mv_par09=3 ///montagem
	   Ender+=" and B2_CC='211' "     
    Case mv_par09=4 //Ia
	   Ender+=" and B2_CC='241' "     
	Otherwise   //Todos
       Ender+="  "
EndCase            

If !Empty(mv_par07) 
	FiltroBC=" and BC_MOTIVO>='"+mv_par05+"' and BC_MOTIVO<='"+mv_par06+"' "
	FiltroBc+=" and BC_DTRM>='"+Dtos(mv_par07)+"'  and BC_DTRM<='"+Dtos(mv_par08)+"'"
EndIF 

FRecurso:=" C2_RECURSO>='"+mv_par10+"' and C2_RECURSO<='"+mv_par11+"' "


cQuery:= " SELECT D3_COD,B1_DESC,SB9.TOTINV AS TOTINV,"
cQuery+=" SUM(CASE WHEN (D3_CF IN('RE4','RE5') AND D3_LOCAL='10')   THEN D3_QUANT ELSE 0 END) AS QTDPERD,  " //Alterado para poder jogar as perdas para o custos 02/08/2012
cQuery+=" SUM(CASE WHEN D3_CF='RE3' OR (D3_CF='PR0' and D3_LOCAL='10') OR (D3_CF='DE2' AND D3_TM='499') THEN D3_QUANT ELSE 0 END) AS QTDTRAN , "
cQuery+=" SUM(CASE WHEN D3_CF='RE2' AND D3_LOCAL='10' THEN D3_QUANT ELSE 0 END) AS QTDCONS "
cQuery+=" FROM SD3010 "
cQuery+=" LEFT JOIN (SELECT B9_COD,SUM(B9_QINI) AS TOTINV FROM SB9010 WHERE D_E_L_E_T_='' AND B9_LOCAL='10' AND LEFT(B9_DATA,6)='"+DatInv+"' GROUP BY B9_COD ) SB9 ON SD3010.D3_COD=SB9.B9_COD "
cQuery+=" INNER JOIN SB1010  ON (B1_COD=D3_COD)  "
cQuery+=" INNER JOIN SB2010  ON (B2_COD=D3_COD)  "
cQuery+=" WHERE B2_LOCAL='10' "//AND D3_OP >='"+mv_par01 +"' and D3_OP<='"+mv_par02 +"' "  //OP TESTE
cQuery+=" and D3_ESTORNO<>'S' "                   
cQuery+=" and D3_COD>='" +mv_par03+"' and D3_COD<='"+mv_par04+"' "  //Codigo 
cQuery+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"' "//Movimentação do periodo
cQuery+=" and D3_CF IN('RE2','RE3','PR0','RE4','RE5','DE2') "     
cQuery+=" and D3_GRUPO NOT IN ('GGF') "
cQuery+=Ender 
cQuery+=" and SD3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
cQuery+=" group by D3_COD,B1_DESC, SB9.TOTINV"
cQuery+=" order by D3_COD"
TCQUERY cQuery New Alias "TSD3" 

DbSElectArea("TSD3")                                                      
DbGotop()                        		
ContI:=0

While !TSD3->(Eof())      
    ContI++
	DbselectArea("TSD3")
	RecLock("TRX",.T.)
	TRX->ITEM:=Alltrim(Str(ContI))
	TRX->COD:=TSD3->D3_COD
	TRX->DESCR:=TSD3->B1_DESC
	TRX->QTDINV   :=TSD3->TOTINV
	TRX->QTDTRANS :=TSD3->QTDTRAN
	TRX->PERDA_MP:= TSD3->QTDPERD
	TRX->QTDCONS  :=TSD3->QTDCONS
	TRX->CONSTOTAL:=TSD3->QTDCONS+TSD3->QTDPERD
	Msunlock()
   /****************************************************************************************/
   /*Verifica as produçõe do produto***************************************************/
	Producao:=VerificaProd(TSD3->D3_COD)
//    Producao[i][1] Produto
//    Producao[i][2] Produção
//    Producao[i][3] QtdUtilizada
//    Producao[i][3] PerdaProducao
    
    For i:=1 to Len(Producao)
    	RecLock("TRX",.T.)
		TRX->ITEM:=Alltrim(Str(ContI))+"."+Alltrim(Str(i))
		TRX->COD:=Producao[i][1]
		TRX->DESCR:=Posicione("SB1",1,xFilial("SB1")+Producao[i][1],"B1_DESC")
		TRX->QTDPAPROD:=Producao[i][2]
		TRX->QTDMPUTL:=Producao[i][3]
		TRX->PERDA_PR:=Producao[i][4]

		Msunlock()
    Next    

   DbselectArea("TSD3")
   DbsKip()    
       
Enddo

DbSelectArea("TSD3")
DbcloseArea("TSD3")

Return
    
**********************************************************************************************************************************************

Static Function VerificaProd (CodMp)
CQuery:=""  
CFiltro:=" "

CFiltro:=" D_E_L_E_T_='' "	
CFiltro+=" and D3_COD='"+CodMp+"' "
CFiltro+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"' "//Movimentação do periodo
Cfiltro+=" and D3_CF IN('RE2') "  
CFiltro+=" and D3_ESTORNO<>'S' "                   

CQuery:=" SELECT D3_DOC,D3_TM,D3_COD, SUM(D3_QUANT)AS QTD, SUM(D3_PERDA) AS QTDPERDA FROM SD3010 C "
CQuery+=" WHERE D_E_L_E_T_='' AND EXISTS 
CQuery+=" (select D3_DOC FROM SD3010 WHERE "+cFiltro+" and D3_DOC=C.D3_DOC AND SD3010.D_E_L_E_T_='' AND C.D_E_L_E_T_='' ) "
CQuery+=" AND D3_CF in('RE2','PR0') and D3_ESTORNO<>'S'  "
CQuery+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"'"
CQuery+=" and (D3_TM='400' or D3_COD='"+CodMp+"')"
CQuery+=" GROUP BY D3_DOC,D3_TM,D3_COD   "
CQuery+=" ORDER BY D3_DOC,D3_TM,D3_COD   "
TCQUERY cQuery New Alias "ASD3" 
IProd:={}
DbSelectArea("ASD3")
DbGotop()
PosI=0
While !Eof()
    If !Empty(IProd)

    	If D3_TM="400"
		    PosI:=ASCAN(Iprod,{|x| x[1] == ASD3->D3_COD})
       		If PosI<>0
		    	IProd[PosI][2]+=ASD3->QTD    		
		    	IProd[PosI][4]+=ASD3->QTDPERDA    		
       		Else
			   	aaDD(IProd,{ASD3->D3_COD,ASD3->QTD,0,ASD3->QTDPERDA})       			
       		EndIf
        Else
		    PosI:=ASCAN(Iprod,{|x|Alltrim(x[1]) == Alltrim(ProdAnt)})
			If PosI<>0
		    	IProd[PosI][3]+=ASD3->QTD    		
		    EndIf	
        Endif 	
	Else 
	   	aaDD(IProd,{ASD3->D3_COD,ASD3->QTD,0,0})       			
    Endif 
    PosI:=0
    ProdAnt:=ASD3->D3_COD
	DbSelectArea("ASD3")
	DbSkip()
EndDo 

DbCloseArea() 
Return iProd
