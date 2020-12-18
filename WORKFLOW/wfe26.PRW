#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH" 

/*
Criacao....: Desenvolvido por Aglair Ishii em 09/08/09
Resultado..: Sera e atualiza os itens de Fornecedor e Clientes bloqueados. 
*/

*******************************************************************************************
User Function WFE026
Local aCampos     := {}
Local cGera := "" 
Private aDados:={}


Prepare Environment Empresa "01" Filial "01" Tables "SA2,SA1"


/*Seleciona dados */
/*Lista os Fornecedores que devem ter o cadastro Bloqueado!!!***/
CQuery:=" SELECT A2_COD,A2_LOJA,A2_NOME FROM SA2010 "
CQuery+=" WHERE A2_MSBLQL='2'        AND	SA2010.D_E_L_E_T_='' AND  "
cQuery+= " A2_PRICOM<>'' AND "
CQuery+="	NOT EXISTS "
CQuery+=" (  "
CQuery+=" select F1_FORNECE+F1_LOJA from SF1010 "
CQuery+=" WHERE "
CQuery+=" DATEDIFF(day,CONVERT (datetime,F1_EMISSAO), getdate())<720 AND
CQuery+=" A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND
CQuery+=" SF1010.D_E_L_E_T_='' AND SA2010.D_E_L_E_T_='' "
CQuery+=" GROUP BY  F1_FORNECE,F1_LOJA,DATEDIFF(day,CONVERT (datetime,F1_EMISSAO), getdate()) "
CQuery+=" ) "               
//Consulta se há pedido de compras em aberto 
CQuery+=" and	NOT EXISTS "
CQuery+=" (  "
CQuery+=" select C7_FORNECE, C7_LOJA from SC7010 "
CQuery+=" WHERE "
CQuery+=" A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND
CQuery+=" SC7010.D_E_L_E_T_='' AND SA2010.D_E_L_E_T_='' AND C7_QUJE>0 AND C7_RESIDUO='' "
CQuery+=" ) "               
cQuery+=" AND "
cQuery+=" NOT EXISTS  "
cQuery+=" (   "
cQuery+=" select E2_FORNECE+E2_LOJA from SE2010 "
cQuery+="  WHERE "
cQuery+="   DATEDIFF(day,CONVERT (datetime,E2_EMISSAO), getdate())<720 AND "
cQuery+="   A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND "
cQuery+="   SE2010.D_E_L_E_T_='' AND SA2010.D_E_L_E_T_='' "
cQuery+="   GROUP BY  E2_FORNECE,E2_LOJA,DATEDIFF(day,CONVERT (datetime,E2_EMISSAO), getdate()) "
cQuery+="  ) "


                              
TCQUERY cQuery NEW ALIAS "TRB"
               

DataBlq:=DToc(DDataBase)
AtuStatFor()
If Len(Adados)>0
 GeraWorkFlow(aDados,"Fornecedor(es) com cadastro(s) bloqueado(s)" )
 ADados:={}	
Endif  	

/***Lista os Clientes a terem o cadastro bloqueado******/
CQuery:=" SELECT A1_COD,A1_LOJA,A1_NOME FROM SA1010 "
CQuery+=" WHERE A1_MSBLQL='2'        AND	SA1010.D_E_L_E_T_='' AND  "
CQuery+=" A1_PRICOM<>'' AND " 
CQuery+="	NOT EXISTS "
CQuery+=" (  "
CQuery+=" select F2_CLIENTE+F2_LOJA from SF2010 "
CQuery+=" WHERE "
CQuery+=" DATEDIFF(day,CONVERT (datetime,F2_EMISSAO), getdate())<720 AND "
CQuery+=" A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND "
CQuery+=" SF2010.D_E_L_E_T_='' AND SA1010.D_E_L_E_T_='' "
CQuery+=" GROUP BY  F2_CLIENTE,F2_LOJA,DATEDIFF(day,CONVERT (datetime,F2_EMISSAO), getdate()) "
CQuery+=" ) "
cQuery+=" AND
cQuery+=" NOT EXISTS  "
cQuery+=" (   "
cQuery+=" select E1_CLIENTE+E1_LOJA from SE1010 "
cQuery+="  WHERE "
cQuery+="   DATEDIFF(day,CONVERT (datetime,E1_EMISSAO), getdate())<720 AND "
cQuery+="   A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND "
cQuery+="   SE1010.D_E_L_E_T_='' AND SA1010.D_E_L_E_T_='' "
cQuery+="   GROUP BY  E1_CLIENTE,E1_LOJA,DATEDIFF(day,CONVERT (datetime,E1_EMISSAO), getdate()) "
cQuery+="  ) "




TCQUERY cQuery NEW ALIAS "TRB"
AtuStatCli()
If Len(Adados)>0
 GeraWorkFlow(aDados,"Cliente(s) com cadastro(s) bloqueado" )
Endif  	
        

Return    
/***************************************************************************************/
Static Function AtuStatFor()
 dbSelectArea("TRB")
 dbGotop()       
 Qtd:=1
 While !EOF()    
		aadd(aDados,{Alltrim(Str(Qtd)),TRB->A2_COD,TRB->A2_LOJA,TRB->A2_NOME,DataBlq})
		DbSelectArea("SA2")
		DbSetOrder(1)
		If DbSeek(xFilial("SA2")+TRB->A2_COD+TRB->A2_LOJA)
			RecLock("SA2",.F.)
			SA2->A2_MSBLQL='1'
			MsUnlock()
		EndIF		
		Qtd++
        DbSelectArea("TRB")
        dbSkip()          
  Enddo      
  DbCloseArea("TRB")
Return 
/**************************************************************************************/
Static Function AtuStatCli()
 dbSelectArea("TRB")
 dbGotop()
 Qtd:=1
 While !EOF()    
		aadd(aDados,{Alltrim(Str(Qtd)),TRB->A1_COD,TRB->A1_LOJA,TRB->A1_NOME,DataBlq})
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+TRB->A1_COD+TRB->A1_LOJA)
			RecLock("SA1",.F.)
			SA1->A1_MSBLQL='1'
			MsUnlock()
		EndIF		
        Qtd++
        DbSelectArea("TRB")
        dbSkip()          
  Enddo      
  DbCloseArea("TRB")
Return 

/***************************************************************************************/
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡„o ³ Ajusta perguntas do SX1                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*exemplo de work flow */      

Static Function GeraWorkFlow(aDados,Msg)
Local CodRot,MTo
CodRot:="WFE26"
                      

  If Len(aDados) > 0 

    Mto:= u_MontaRec(CodRot)
    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\BLOQUEIO.HTML" )
    oProcess :cSubject := "WFE26-"+Msg
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="5" width="800">'
    cMen += ' <td colspan=5 align="center"> '+"WFE26-"+Msg+'</td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Item     </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Codigo     </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Loja     </td>'
    cMen += ' <td align="center" width="50%"><font size="1" face="Times">Nome   </td>'
   cMen += ' <td align="center" width="10%"><font size="1" face="Times"> Data Bloqueio </td>'
    cMen += ' </tr>'

      For x:= 1 to Len(aDados)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="05%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="05%"><font size="1" face="Times">'+ aDados[x][2] +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aDados[x][3] + '</td>'
        cMen += ' <td align="left  " width="50%"><font size="1" face="Times">'+ aDados[x][4] +'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][5] +'</td>'
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
/*************************************/                
/**fim do exemplo do workflow*/