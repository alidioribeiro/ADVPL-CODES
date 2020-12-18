#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function OM010LOK

lRet:=.T.
/*
cQuery  := "select A.DA0_DATATE,B.DA1_PRCVEN from DA0010 AS A,DA1010 AS B  "
cQuery +=" where  A.DA0_CODTAB=B.DA1_CODTAB          AND  "
cQuery +=" A.D_E_L_E_T_ ='' AND  B.D_E_L_E_T_ =''         AND  "
cQuery +=" B.DA1_CODPRO ='"+acols[n,2]+"'  AND "
cQuery  +="SUBSTRING(A.DA0_DESCRI,1,10)='"+SUBSTR(DA0_DESCRI,1,10)+"' "
cQuery   +="ORDER BY A.DA0_DATATE DESC "
TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
If !Eof()                     
	DifVlr:=acols[n,5]-TRB->DA1_PRCVEN
	If DifVlr>= TRB->DA1_PRCVEN*0.1  
         lRet:= U_SUsuario('000219')
	   //	Msgbox("Preço atual é maior que o estabelecido 10%. É necessário autorização")


	EndIf 
Endif                                                                                                  
DbSelectArea("TRB")
DbCloseArea("TRB")
Return lRet
/*********************************************************************************************************/
/*********************************************************************************************************/
/*
User Function SUsuario(CodResp)     
Local SenhaR
Local lRet:=.F.

SenhaR:=space(6)

PswOrder(1)
If PswSeek( CodResp )
	DLogin := PSWRET() // Retorna o ID do usuário
EndIf

@ 250,250 To 360,600 Dialog oDlg Title "Informações do autorizante"      
@ 002,005 Say " Usuario " + DLogin[1][2]
@ 020,005 Say "Senha:" 
@ 020,040 Get SenhaR Picture "@s" Valid PswName(SenhaR)  PASSWORD
@ 030,080  BmpButton Type 1 Action Close(oDlg)
//@ 02,50 Get cCod Picture "@!" F3 "SB1"
Activate Dialog oDlg Centered
If  PswName(SenhaR)
	lRet:=.T.		
EndIf
*/
Return lRet
/*********************************************************************************************************/
/*********************************************************************************************************/


