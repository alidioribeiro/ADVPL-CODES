#INCLUDE "Protheus.ch"
#include "TOPCONN.CH"
#include "TBICONN.CH"
#include "rwmake.ch"
#include "ap5mail.ch"

User Function N_WF01()

Prepare Environment Empresa "01" Filial "01" Modulo "EST"  // Usado apenas quando o uso for por agendamento 

Processa({|| WorkFlowWF01() })

RESET ENVIRONMENT
  
Return nil

Static Function WorkFlowWF01() // Tratamento Específico conforme regra de negócio
Local aWF:= {}
Local cEmail  := ""
Local aPessoas:= {}

If select("TM1") >0
   TM1->(DbCloseArea())
Endif

cQuery:= " SELECT SP8.P8_CC "
cQuery+= " FROM "+RetSqlName('SP8')+" SP8 "
cQuery+= "     INNER JOIN "+RetSqlName('SRA')+" SRA ON (SRA.RA_FILIAL = SP8.P8_FILIAL AND SRA.RA_MAT = SP8.P8_MAT) "
cQuery+= " WHERE SP8.D_E_L_E_T_<>'*' "
cQuery+= "      AND SRA.RA_SITFOLH <>'D' AND SRA.D_E_L_E_T_<>'*' "
cQuery+= "      AND SP8.P8_FILIAL = '"+xFilial('SP8')+"' "
cQuery+= " 	    AND SP8.P8_DATA BETWEEN '"+Dtos(dDatabase-1)+"' AND '"+Dtos(dDatabase)+"' "
cQuery+= "      AND SP8.P8_TPMARCA IN ('1E','2S') "
cQuery+= " GROUP BY SP8.P8_CC "
cQuery+= " ORDER BY SP8.P8_CC "  

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TM1",.F.,.T.)

DbSelectArea("TM1")
DbGotop()
While TM1->(!Eof()) //adicionando responsáveis

   If select("TM2") >0
      TM2->(DbCloseArea())
   Endif
   
   cQuery:= " SELECT SP8.P8_FILIAL, SP8.P8_DATA, SP8.P8_HORA, SP8.P8_MAT, SRA.RA_NOME, SP8.P8_CC, SRA.RA_TNOTRAB "
   cQuery+= " FROM "+RetSqlName('SP8')+" SP8 "
   cQuery+= "     INNER JOIN "+RetSqlName('SRA')+" SRA ON (SRA.RA_FILIAL = SP8.P8_FILIAL AND SRA.RA_MAT = SP8.P8_MAT) "
   cQuery+= " WHERE SP8.D_E_L_E_T_<>'*' "
   cQuery+= "      AND SRA.RA_SITFOLH <>'D' AND SRA.D_E_L_E_T_<>'*' "
   cQuery+= "      AND SP8.P8_FILIAL = '"+xFilial('SP8')+"' "
   cQuery+= " 	   AND SP8.P8_DATA BETWEEN '"+Dtos(dDatabase-1)+"' AND '"+Dtos(dDatabase)+"' "
   cQuery+= "      AND SP8.P8_TPMARCA IN ('1E','2S') "
   cQuery+= "	   AND SP8.P8_CC = '"+TM1->P8_CC+"' "
   cQuery+= " ORDER BY  SP8.P8_DATA, SP8.P8_MAT, SP8.P8_HORA "  
   
 
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TM2",.F.,.T.)
   DbSelectArea("TM2")
   DbGotop()
   
   While TM2->(!Eof())
      aadd(aWf,{TM2->P8_MAT,TM2->RA_NOME,Stod(TM2->P8_DATA),StrTran(Transform(TM2->P8_HORA,"99.99"),".",":"),TM2->P8_CC,TM2->RA_TNOTRAB})
      TM2->(DbSkip())
   End
   TM2->(DbCloseArea())
   
   aPessoas:= PegaEmail(TM1->P8_CC)
   
   For i:=1 to Len(aPessoas)
       If Len(aPessoas) == 1
           cEmail:= aPessoas[i][1]
       Else
           cEmail+= aPessoas[i][1]+";"
       Endif
   Next
   
   If Len(aWf) > 0
      If !Empty(cEmail)
           GeraWFE(aWF,cEmail)
           cEmail:= ""
      Endif
      aWf:= {}
   Endif
   
   TM1->(DbSkip())
End

TM1->(DbCloseArea())

Return nil

Static Function GeraWFE(aVetor,cEmail)

oProcess := TWFProcess():New( "WFE04_", "WorkFlow wfe04_" )
oProcess:NewTask( "WFE04_", "\WORKFLOW\wfe04_.HTML" )
oProcess:cSubject := "Apontamento de marcações"
//oProcess:bTimeOut := {{"U_CURSO01T()",0, 0, 5 }}
oHTML := oProcess:oHTML
For i:=1 to Len(aVetor)      
   aadd((oHtml:valByName('tab.mat')) ,aVetor[i,1])
   aadd((oHtml:valByName('tab.nome')),aVetor[i,2])   
   aadd((oHtml:valByName('tab.data')),aVetor[i,3])
   aadd((oHtml:valByName('tab.hora')),aVetor[i,4])   
   aadd((oHtml:valByName('tab.ccusto')),aVetor[i,5])
   aadd((oHtml:valByName('tab.turno')),aVetor[i,6])   
Next
oProcess:cTo := cEmail
oProcess:ClientName( Subs(cUsuario,7,15) )
oProcess:Start()

Return

Static Function PegaEmail(cCC)

Local aVetor:= {}

If select("TMD") >0
    TMD->(DbCloseArea())
Endif

cQuery:= " SELECT ZWF_EMAIL "
cQuery+= " FROM  "+RetSqlName('ZWF')+" ZWF "
cQuery+= " WHERE ZWF.D_E_L_E_T_<>'*' AND ZWF.ZWF_FILIAL = '"+xFilial('ZWF')+"' AND ZWF.ZWF_ROT = 'N_WF01  ' AND ZWF.ZWF_CC = '"+cCC+"' "

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMD",.F.,.T.)
DbSelectArea("TMD")
DbGotop()
   
While TMD->(!Eof())
    aadd(aVetor,{TMD->ZWF_EMAIL})
    TMD->(DbSkip())
End
TMD->(DbCloseArea())

Return aVetor