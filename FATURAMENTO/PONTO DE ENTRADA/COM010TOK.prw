#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#Include "TOPCONN.CH"
// ******************************************************************************************************
// * Desenvolvedora: Aglair Brito Ishii  **************************************************************
// * Ponto de entrada Chamado na confirmação da gravação da tabela de preço *************
//*******************************************************************************************************

User Function CM010TOK
/*
Local CodRot 
Local aDados 
Local PosCod

PosP   :=aScan(aHeader,{|x| AllTrim(x[2])=="AIB_CODPRO"})
PosI   :=aScan(aHeader,{|x| AllTrim(x[2])=="AIB_ITEM"})
PosPr  :=aScan(aHeader,{|x| AllTrim(x[2])=="AIB_PRCCOM"})


aDados:={}                                                        Ñ
For i:=1 to Len(aCols)
	If ! Acols[i][Len(aheader)+1]  // Verifica se o item não foi excluido do browse //
		cQuery  := "select A.AIA_DATATE,A.AIA_CODTAB, B.AIB_PRCCOM,AIA_CODFOR, AIA_LOJFOR  from AIA010 AS A,AIB010 AS B  "
		CQuery +=" where  A.AIA_CODTAB=B.AIB_CODTAB          AND  "
		cQuery +=" A.AIA_CODFOR+A.AIA_LOJFOR=B.AIB_CODFOR+B.AIB_LOJFOR  AND "
		cQuery +=" A.D_E_L_E_T_ ='' AND  B.D_E_L_E_T_ =''         AND  "
		cQuery +=" B.AIB_CODPRO ='"+acols[I,PosP]+"'  AND "                                                      
		cQuery +=" A.AIA_CODFOR+A.AIA_LOJFOR='"+M->AIA_CODFOR+M->AIA_LOJFOR+"' AND  "
		cQuery +=" A.AIA_CODTAB<>'"+M->AIA_CODTAB+"'  "
		cQuery +=" ORDER BY A.AIA_DATATE DESC " 
		TCQUERY cQuery NEW ALIAS "TRB" //Compara os itens da tabela atual com a anterior.
		DbSelectArea("TRB")     
        If !Eof()
            NomeFor:= Posicione("SA2",1,xFilial("SA2")+TRB->AIA_CODFOR+TRB->AIA_LOJFOR, "A2_NOME") 
            DifVlr:=acols[I,PosPR]-TRB->AIB_PRCCOM
            If  (DifVlr>= TRB->AIB_PRCCOM*0.1) .or. ( DifVlr<0 .and. DifVlr*-1>= TRB->AIB_PRCCOM*0.1) 
//				Aadd(aDados,{acols[i][PosI]	,acols[PosP][2],acols[i][3],M->AIA_CODTAB,acols[i][PosPr],TRB->AIA_CODTAB,TRB->AIB_PRCCOM})           
				Aadd(aDados,{acols[i][PosI]	,acols[I][PosP],acols[i][3],M->AIA_CODTAB,acols[i][PosPr],TRB->AIA_CODTAB,TRB->AIB_PRCCOM})           
			Endif		
		Endif	
        DbCloseArea("TRB") 
	EndIf
Next 	
If len(aDados)>0
	WGerTabPreco(aDados)
EndIf
*/
Return .T.
// **********************************************************************************************************************************************************
// *Montagem do Workflow           ********************************************************************************************************************
// *********************************************************************************************************************************************************
Static Function WGerTabPreco(aDados)
Local CodRot,MTo
/*CodRot:="WFE19"
                      

  If Len(aDados) > 0 
    DataF:=  Dtos(Ddatabase)
     Mto:= u_MontaRec(CodRot)                          

    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\DivTabP.HTM" )
    oProcess :cSubject := "WF19 - DIVERGENCIA NAS TABELAS DE PREÇO DO FORNECEDOR "+NomeFor
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=8 align="center"> WFE19 - ITENS COM DIFERENÇAS ACIMA DE 10% ENTRE AS TABELAS </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Item Tab    </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Codigo     </td>'
    cMen += ' <td align="center" width="40%"><font size="1" face="Times">Descrição  </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Tab.Atual  </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Preço Atual </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Tab.Ant  </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Preço Anterior </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Diferença % </td>'
    cMen += ' </tr>'

      For x:= 1 to Len(aDados)
        Porc:=(aDados[x][5]*100)/aDados[x][7]
        Porc:=Iif(aDados[x][7]>aDados[x][5],Porc *-1,Porc )
        cMen += ' <tr>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][2] + '</td>'
        cMen += ' <td align="left  " width="15%"><font size="1" face="Times">'+ aDados[x][3] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+  aDados[x][4] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ Str( aDados[x][5]) +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+  aDados[x][6] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ Str( aDados[x][7]) +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ TRANSFORM( Porc,'@E 99999.99') +'</td>'
        cMen += ' </tr>'
    
      Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 

    oHtml:ValByName( "MENS", cMen)
    oProcess:cTo  := Mto
    cMailId := oProcess:Start()
     
  EndIf

  ConOut("Finalizou")

Return
*/
// **********************************************************************************************************************************************************/