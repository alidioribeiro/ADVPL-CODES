#include "rwmake.ch"
#Include "TOPCONN.CH"

User Function GeraCD5() 

cPerg:="IMPETIQS"
If ! Pergunte (cPerg,.T.,'Parametros para geração CD5 ')
	Return
Endif 


//mv_par01 - NF Inicial
//mv_par02 - NF Final
//mv_par03 - Serie NF
cQuery:=" select D1_EMISSAO,D1_COD,D1_DOC,D1_SERIE,F1_ESPECIE,D1_FORNECE,D1_LOJA,D1_TIPO, "
cQuery+=" D1_ADICAO,D1_SEQADIC,D1_ITEM ,D1_FABRIC,D1_DI,D1_LI,D1_INVOICE,D1_PEDIDO,"
cQuery+=" ISNULL(F8_NFORIG,'') AS NFORI,ISNULL(F8_SERORIG,'') AS SERORI, "
cQuery+=" ISNULL(F8_FORNECE,'') AS FORNORI, "
cQuery+=" ISNULL(F8_LOJA,'') AS LOJAORI "
cQuery+=" from SF1010 A  ,  SA2010 C,SD1010 B "
cQuery+=" left join SF8010 on B.D1_DOC=F8_NFDIFRE  "
cQuery+="  AND B.D1_SERIE=F8_SEDIFRE  "  
cQuery+="  AND B.D1_SERIE=F8_SEDIFRE  "
cQuery+=" WHERE  "
cQuery+=" A.D_E_L_E_T_='' "
cQuery+=" AND B.D_E_L_E_T_='' "
cQuery+=" AND C.D_E_L_E_T_='' "
cQuery+=" AND F1_FORMUL='S' "
cQuery+=" AND D1_EMISSAO >='20111101' "
cQuery+=" AND F1_ESPECIE='SPED' "
cQuery+=" AND F1_DOC=D1_DOC "
cQuery+=" AND F1_SERIE=D1_SERIE "
cQuery+=" AND F1_FORNECE=D1_FORNECE "
cQuery+=" AND F1_LOJA=D1_LOJA "
cQuery+=" AND A2_COD=D1_FORNECE "
cQuery+=" AND A2_LOJA=D1_LOJA "
cQuery+=" AND A2_EST='EX' "
cQuery+=" AND D1_DOC>='"+mv_par01+"'"
cQuery+=" AND D1_DOC<='"+mv_par02+"'"
cQuery+=" AND D1_SERIE='"+mv_par03+"'"
TCQUERY cQuery New Alias "TMP" 

DbSelectArea("SZB")
DbSetOrder(4)

DbSelectArea("SD1") 
DbSetOrder(1)

DbSelectArea("TMP")
DbGotop()

While !Eof()
	//Inclui os complementos de nota fiscal

    NrLi:=""                
    NrDI:=""
    DtRegDi:=SToD(" /  / ")
    DtDes  :=SToD(" /  / ")
    
//    ZB_DATDESE	varchar	no	8	     	     	no	no	no	Latin1_General_BIN
    
    DbSelectArea("SZB")    
    DbSetOrder(3)
    If DbSeek(xFilial("SZB")+TMP->D1_DI+TMP->D1_INVOICE+TMP->D1_PEDIDO)     
	  // 	NrDi:=SZB->ZB_DI
    	DtRegDi:=SZB->ZB_DATADI
    	DtDes:=SZB->ZB_DATDESE
    Endif  
    //Verifica se a nota é complementar de despesa de importacao
    If TMP->D1_TIPO="C" .and. ( Empty(Dtos(DtDes)) .OR. Empty(Dtos(DtDI))) 
    	DbSelectArea("SD1") 
    	If DbSeek(xFilial("SD1")+TMP->NFORI+TMP->SERORI+TMP->FORNORI+TMP->LOJAORI+TMP->D1_COD)
    		DtDes:=SD1->D1_DATADES
    		DtRegDi:=SD1->D1_DATADI
   	    Endif 
    EndIf 
    DbSelectArea("SD1")
    If DbSeek(xFilial("CD5")+TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_FORNECE+TMP->D1_LOJA+TMP->D1_COD) 
        if Empty(SD1->D1_DATADES)
   			RecLock("SD1",.F.)
   			SD1->D1_DATADES:=DtDes
   			SD1->D1_DATADI:=DtRegDi
   			MsUnlock()
        EndIf 
        
    EndIf 
   
                           
	NrDi:=TMP->D1_DI
   	NrLi:=TMP->D1_LI
    DbSelectArea("CD5")                           
    DbSetOrder(4)
    If ! DbSeek(xFilial("CD5")+TMP->D1_DOC+TMP->D1_SERIE+TMP->D1_FORNECE+TMP->D1_LOJA+TMP->D1_ITEM)          
		RecLock("CD5",.T.)
	    CD5->CD5_NDI:=NRDI
	    CD5->CD5_DOCIMP:=NRLI
	    CD5->CD5_DTDI :=DtRegDI
	    CD5->CD5_DTDES:=DtDes            
	    CD5->CD5_FILIAL :=xFilial("CD5")	
		CD5->CD5_DOC    :=TMP->D1_DOC
		CD5->CD5_SERIE  :=TMP->D1_SERIE
		CD5->CD5_ESPEC:=TMP->F1_ESPECIE
		CD5->CD5_FORNEC :=TMP->D1_FORNECE
		CD5->CD5_LOJA   :=TMP->D1_LOJA
		CD5->CD5_TPIMP  :='0'
		CD5->CD5_LOCAL  :='0'
		CD5->CD5_LOCDES :='MANAUS'
		CD5->CD5_UFDES  :='AM'
		CD5->CD5_CODEXP :=TMP->D1_FORNECE
		CD5->CD5_NADIC  :=TMP->D1_ADICAO
		CD5->CD5_SQADIC :=TMP->D1_SEQADIC
		CD5->CD5_ITEM   :=TMP->D1_ITEM 
		CD5->CD5_CODFAB :=TMP->D1_FABRIC
		MsUnlock()           
	Else
		RecLock("CD5",.F.)
	    CD5->CD5_NDI:=NRDI
	    CD5->CD5_DOCIMP:=NRLI
	    CD5->CD5_DTDI :=DtRegDI
	    CD5->CD5_DTDES:=DtDes            
		CD5->CD5_TPIMP  :='0'
		CD5->CD5_LOCAL  :='0'
		CD5->CD5_LOCDES :='MANAUS'
		CD5->CD5_UFDES  :='AM'
		CD5->CD5_CODEXP :=TMP->D1_FORNECE
		CD5->CD5_NADIC  :=TMP->D1_ADICAO
		CD5->CD5_SQADIC :=TMP->D1_SEQADIC
		CD5->CD5_ITEM   :=TMP->D1_ITEM 
		CD5->CD5_CODFAB :=TMP->D1_FABRIC
		MsUnlock()           
	    
    EndIf
    
	
    DbSelecTArea("TMP")
    DbSkip()

EndDo 
DbSelectArea("TMP")
DbCloseArea()
Return
