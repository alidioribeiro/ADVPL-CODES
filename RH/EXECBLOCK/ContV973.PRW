#include "rwmake.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  01/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ContV973


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Periodo:=""
Private Vlr973 :=0
Private VlTotRat:=0


Lote    :=  "008890"
SBLote  :=  "001"
Doc     :=  "000030"
NrDoc:=""

Periodo:=substr(getmv("MV_FOLMES"),5,2)+'/'+substr(getmv("MV_FOLMES"),1,4)
LConf:=msgbox("Você confirma a contabilização do INSS no periodo "+Periodo+'com a data '+Dtoc(DdataBase),"Atenção","YESNO")
if  !LConf
    Return
EndIf    
DbSelectArea("CT2")
DbSetOrder(1)
if DbSeek(xFilial("CT2")+Dtos(DdataBase)+Lote+SBLote+Doc)
	Alert("Contabilização do INSS já efetuada!!")
	Return
EndIf
cQuery:="SELECT RZ_VAL FROM SRZ010 WHERE RZ_FILIAL='ZZ' AND RZ_CC='ZZZZZZZZZ' 	AND D_E_L_E_T_='' AND RZ_PD='973' "	
TCQUERY cQuery New Alias "TRB"
DbSelectArea("TRB")
If !Eof()
    Vlr973 :=TRB->RZ_VAL
    VlTotRat:=TRB->RZ_VAL

	Hist:="I.N.S.S. S/ FATURAMENTO "+Periodo
	RecLock("CT2",.T.) //Geração do valores de Debito nas contas contábeis
	CT2->CT2_Filial  :=  xFilial()
	CT2->CT2_Lote    :=  Lote
	CT2->CT2_SBLote  :=  SBLote
	CT2->CT2_Doc     :=  Doc
	CT2->CT2_Linha   :=  "001"
	CT2->CT2_SeqLan  :=  "001"
	CT2->CT2_Data    :=  dDataBase
	CT2->CT2_DC      :=  "1"
//	CT2->CT2_CCD     :=  TRB->RZ_CC
	CT2->CT2_Debito  :=  "41121008"
	CT2->CT2_Moedas  :=  "12222"
	CT2->CT2_Moedlc  :=  "01"
	CT2->CT2_Valor   :=  TRB->RZ_VAL
	CT2->CT2_Hist    :=  Hist
	CT2->CT2_SeqHis  :=  "001"
	//CT2->CT2_DtVenc  :=  mv_par02
	CT2->CT2_Origem  :=  "CONTV973"
	CT2->CT2_FilOrig :=  "01"
	CT2->CT2_EmpOrig :=  "01"
	CT2->CT2_TPSald  :=  "9"
	CT2->CT2_Manual  :=  "1"
	CT2->CT2_Aglut   :=  "2"
	msUnlock()      
	
	Hist:="I.N.S.S. S/ FATURAMENTO DO MES "+Periodo
	RecLock("CT2",.T.) //Geração do valores de Debito nas contas contábeis
	CT2->CT2_Filial  :=  xFilial()
	CT2->CT2_Lote    :=  Lote
	CT2->CT2_SBLote  :=  SBLote
	CT2->CT2_Doc     :=  Doc
	CT2->CT2_Linha   :=  "002"
	CT2->CT2_SeqLan  :=  "002"
	CT2->CT2_Data    :=  dDataBase
	CT2->CT2_DC      :=  "2"
	CT2->CT2_CREDIT  :=  "22231008"
	CT2->CT2_Moedas  :=  "12222"
	CT2->CT2_Moedlc  :=  "01"
	CT2->CT2_Valor   :=  TRB->RZ_VAL
	CT2->CT2_Hist    :=  Hist
	CT2->CT2_SeqHis  :=  "001"
	//CT2->CT2_DtVenc  :=  mv_par02
	CT2->CT2_Origem  :=  "CONTV973"
	CT2->CT2_FilOrig :=  "01"
	CT2->CT2_EmpOrig :=  "01"
	CT2->CT2_TPSald  :=  "9"
	CT2->CT2_Manual  :=  "1"
	CT2->CT2_Aglut   :=  "2"
	msUnlock()

	infRateio()
EndIf
DbSelectArea("TRB")
dbCloseArea()
Return
	
/*
cQuery:=" SELECT RZ_CC, ROUND( RZ_VAL/   ( SELECT SUM(RZ_VAL) FROM SRZ010   WHERE RZ_PD='900' and RZ_FILIAL='01' and RZ_CC='zzzzzzzzz' AND RZ_OCORREN<>'1'   AND D_E_L_E_T_=''  )*100,2)   AS PERC ,   	(SELECT RZ_VAL FROM SRZ010 WHERE RZ_FILIAL='ZZ' AND RZ_CC='ZZZZZZZZZ' 	AND D_E_L_E_T_='' AND RZ_PD='973') as VALOR   "
cQuery+=" FROM SRZ010   WHERE RZ_PD='900' AND D_E_L_E_T_=''  and   RZ_MAT='zzzzzz' and RZ_CC<>'zzzzzzzzz'  ORDER BY RZ_FILIAL   "
TCQUERY cQuery New Alias "TRB"
DbSelectArea("TRB")
DbGotop()
xLinha:=1
cConta:=""
VlTotRat:=0
VlRateio:=0
While !Eof()
	If PERC=0
    	DbSelectArea("TRB")
    	DbSkip()
    	Loop
	EndIf 
	Vlr973:=TRB->VALOR
	Do Case
		Case substr(TRB->RZ_CC,1,1)="1"
			CConta:="35112011"
		Case substr(TRB->RZ_CC,1,3)="211"
			CConta:="31112011"
		Case substr(TRB->RZ_CC,1,3)="221"
			CConta:="31212011"
		Case substr(TRB->RZ_CC,1,3)="231"
			CConta:="31412011"
		Case substr(TRB->RZ_CC,1,3)="241"
			CConta:="31312011"
		Case substr(TRB->RZ_CC,1,1)="6"
			CConta:="31512011"
	EndCase
	VlRateio:=(TRB->VALOR*PERC)/100
	VlTotRat+=VlRateio
	Hist:="I.N.S.S. S/ FATURAMENTO "+TRB->RZ_CC
	RecLock("CT2",.T.) //Geração do valores de Debito nas contas contábeis
	CT2->CT2_Filial  :=  xFilial()
	CT2->CT2_Lote    :=  Lote
	CT2->CT2_SBLote  :=  SBLote
	CT2->CT2_Doc     :=  Doc
	CT2->CT2_Linha   :=  StrZero(xLinha,3)
	CT2->CT2_SeqLan  :=  StrZero(xLinha,3)
	CT2->CT2_Data    :=  dDataBase
	CT2->CT2_DC      :=  "1"
	CT2->CT2_CCD     :=  TRB->RZ_CC
	CT2->CT2_Debito  :=  cConta
	CT2->CT2_Moedas  :=  "12222"
	CT2->CT2_Moedlc  :=  "01"
	CT2->CT2_Valor   :=  VlRateio
	CT2->CT2_Hist    :=  Hist
	CT2->CT2_SeqHis  :=  "001"
	//CT2->CT2_DtVenc  :=  mv_par02
	CT2->CT2_Origem  :=  "CONTV973"
	CT2->CT2_FilOrig :=  "01"
	CT2->CT2_EmpOrig :=  "01"
	CT2->CT2_TPSald  :=  "9"
	CT2->CT2_Manual  :=  "1"
	CT2->CT2_Aglut   :=  "2"
	msUnlock()
	xLinha++
	DbSelectArea("TRB")
	DbSkip()
EndDO
Hist:="I.N.S.S. S/ FATURAMENTO DO MES "+Periodo
RecLock("CT2",.T.) //Geração do valores de Debito nas contas contábeis
CT2->CT2_Filial  :=  xFilial()
CT2->CT2_Lote    :=  Lote
CT2->CT2_SBLote  :=  SBLote
CT2->CT2_Doc     :=  Doc
CT2->CT2_Linha   :=  StrZero(xLinha,3)
CT2->CT2_SeqLan  :=  StrZero(xLinha,3)
CT2->CT2_Data    :=  dDataBase
CT2->CT2_DC      :=  "2"
CT2->CT2_CREDIT  :=  cConta
CT2->CT2_Moedas  :=  "12222"
CT2->CT2_Moedlc  :=  "01"
CT2->CT2_Valor   :=  Vlr973
CT2->CT2_Hist    :=  Hist
CT2->CT2_SeqHis  :=  "001"
//CT2->CT2_DtVenc  :=  mv_par02
CT2->CT2_Origem  :=  "CONTV973"
CT2->CT2_FilOrig :=  "01"
CT2->CT2_EmpOrig :=  "01"
CT2->CT2_TPSald  :=  "9"
CT2->CT2_Manual  :=  "1"
CT2->CT2_Aglut   :=  "2"
msUnlock()
infRateio()

Return

//**************************************************************************************/
Static Function InfRateio()

FPeriodo:=Periodo

FLote:="008890"
FDoc :="000030"
cPeriodo:=Dtoc(DdataBase)
FVerba973:=Transform(Vlr973 ,"@E 999,999.99")
FRateio  :=transform(VlTotRat,"@E 999,999.99")


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oSay1","oSay2","oSay3","oSay4","oSay5","oGet1","oGet2","oGet3","oGet4","oGet5","oSBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 095,232,292,510,"Dados do Rateio da Verba 973",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,008,{||"Periodo"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 042,007,{||"Valor da Verba 973"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay3      := TSay():New( 052,007,{||"Valor do Rateio"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay4      := TSay():New( 027,008,{||"Lote"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay5      := TSay():New( 026,059,{||"Documento"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)

//oGet1      := TGet():New( 026,056,{|u| If(PCount()>0,cPeriodo:=u,cPeriodo)},oDlg1,052,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPeriodo",,)
                                                 
//Desc       := TGet():New( 042,063,{|u| If(PCount()>0,cDesc:=u,cDesc)}      ,oGrp1,204,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDesc",,)

oGet1      := TGet():New( 011,027,{|u| If(PCount()>0,cPeriodo:=u,cPeriodo)},oDlg2,041,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","FPeriodo",,)
oGet2      := TGet():New( 041,064,{|u| If(PCount()>0,FVerba973:=u,FVerba973)},oDlg2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","FVerba973",,)
oGet3      := TGet():New( 052,065,{|u| If(PCount()>0,FRateio:=u,FRateio)},oDlg2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","FRateio",,)
oGet4      := TGet():New( 026,025,{|u| If(PCount()>0,FLote:=u,FLote)},oDlg2,027,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","FLote",,)
oGet5      := TGet():New( 024,087,{|u| If(PCount()>0,FDoc:=u,FDoc)},oDlg2,037,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","FDoc",,)
//oSBtn1     := SButton():New(068,052,1,exit,oDlg2,,"", )
//oSBtn1     := SButton():New(068,052,1,,oDlg2,,"", )
//oButton     :=tButton():New(068,521,"Ok",oDlg2,{||oDlg2.End()},037,012,,,,.T.,,"",,,,.F. )
oButton:=     tButton():New(68,052,"Fechar",oDlg2,{||oDlg2:End()},037,12,,,,.T.) 

oDlg2:Activate(,,,.T.)

Return



