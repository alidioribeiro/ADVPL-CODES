#include "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


User Function PONCALD()

cQuery := " SELECT PB_FILIAL,PB_MAT,PB_DATA,PB_PD,PB_TIPO1,PB_HORAS,PB_CC,PB_TIPO2 FROM SPB010"
cQuery += " WHERE "
cQuery += " PB_PD IN ('323') AND D_E_L_E_T_ = '' "
TCQUERY cQuery New Alias TRX

DBSELECTAREA("TRX")
DbGotop()

While !EOF("TRX")

	QTD323:= TRX->PB_HORAS
	
	IF QTD323 <= 8
		//--Permanece verba de 60%
	 	
	 	DbSelectArea("SPB")
        DbSetOrder(1)   
        If DbSeek(xFilial("SPB")+TRX->PB_MAT+TRX->PB_PD)
        RECLOCK("SPB",.F.)
		  SPB->PB_HORAS := QTD323
		   MsUnlock()
        ENDIF

		
	ELSEIF QTD323>8 .AND. QTD323<=16
		// Alterada verba de 60% e Adicionada Verba de 80%
		DbSelectArea("SPB")
        DbSetOrder(1)   
        If DbSeek(xFilial("SPB")+TRX->PB_MAT+TRX->PB_PD)
        RECLOCK("SPB",.F.)
		  SPB->PB_HORAS := 8
		   MsUnlock()
        ENDIF

		QTD323:=QTD323-8
		//INSERIR VERBA DE 60% E 80%
		
		RECLOCK("SPB",.T.)
		SPB->PB_FILIAL :=TRX->PB_FILIAL
		SPB->PB_MAT    :=TRX->PB_MAT
		SPB->PB_DATA   :=STOD(TRX->PB_DATA)
		SPB->PB_PD:= "118" // verba de 80% 118
		SPB->PB_TIPO1  :=TRX->PB_TIPO1
		SPB->PB_HORAS  :=QTD323
		SPB->PB_CC     :=TRX->PB_CC
		SPB->PB_TIPO2  :=TRX->PB_TIPO2
		MsUnlock()
		DBSELECTAREA("SPB")
		
	ELSEIF QTD323 > 16
		// INSERI VERBAS 60% / 80% / 110%
		// Alterada verba de 60% e Adicionada Verba de 80%
		
		DbSelectArea("SPB")
        DbSetOrder(1)   
        If DbSeek(xFilial("SPB")+TRX->PB_MAT+TRX->PB_PD)
        RECLOCK("SPB",.F.)
		  SPB->PB_HORAS := 8
		   MsUnlock()
        ENDIF

		
		
		DBSELECTAREA("SPB")
					
		QTD16         :=8
		QTD323:=QTD323-16
		//INSERIR VERBA DE 60% E 80%
		
		RECLOCK("SPB",.T.)
		SPB->PB_FILIAL :=TRX->PB_FILIAL
		SPB->PB_MAT    :=TRX->PB_MAT
		SPB->PB_DATA   :=STOD(TRX->PB_DATA)
		SPB->PB_PD:= "118" // verba de 80% 118
		SPB->PB_TIPO1  :=TRX->PB_TIPO1
		SPB->PB_HORAS  :=QTD16
		SPB->PB_CC     :=TRX->PB_CC
		SPB->PB_TIPO2  :=TRX->PB_TIPO2
		MsUnlock()
		DBSELECTAREA("SPB")
				
		RECLOCK("SPB",.T.)
		SPB->PB_FILIAL :=TRX->PB_FILIAL
		SPB->PB_MAT    :=TRX->PB_MAT
		SPB->PB_DATA   :=STOD(TRX->PB_DATA)
		SPB->PB_PD:= "344" // verba de 80% 118
		SPB->PB_TIPO1  :=TRX->PB_TIPO1
		SPB->PB_HORAS  :=QTD323
		SPB->PB_CC     :=TRX->PB_CC
		SPB->PB_TIPO2  :=TRX->PB_TIPO2
		MsUnlock()
		DBSELECTAREA("SPB")
			
		cQuery := "	UPDATE SPB010 SET PB_HORAS = 8  WHERE SPB->PB_MAT = TRX->PB_MAT AND"
	    cQuery += " PB_PD IN ('323') AND D_E_L_E_T_ = '' "  
	    TCSQLExec(cQuery)
	   
		
	ENDIF
	DBSELECTAREA("TRX")	
	
	Dbskip()
EndDo
DbcloseArea("TRX")
Return()
