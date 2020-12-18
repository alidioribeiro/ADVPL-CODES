#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"                                                     


/*
Criacao....: Desenvolvido por Aglair Ishii em 09/08/09
Objetivo...:Verifica o status da nota fiscal Eletrônica
*/

*******************************************************************************************
User Function WFE27
Local aCampos     := {}                                                          
Local cGera := "" 
Private aDados:={}


Prepare Environment Empresa "01" Filial "01,02" Tables "SF3"


/*Seleciona dados */
/*Lista os Fornecedores que devem ter o cadastro Bloqueado!!!***/

cQuery:="SELECT 'SF1' AS ORIGEM ,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_VALCONT,F3_TIPO "
cQuery+="FROM SF3010,SPED050,SF1010 "
cQuery+="WHERE "
cQuery+="    F3_FILIAL=F1_FILIAL "
cQuery+="AND F3_SERIE+F3_NFISCAL =NFE_ID  "
cQuery+="AND F1_FORNECE=F3_CLIEFOR AND F1_LOJA=F3_LOJA "
cQuery+="AND  F1_SERIE+F1_DOC =NFE_ID  "
cQuery+="AND F3_FORMUL='S'  "
cQuery+="AND F1_FORMUL='S'  "
cQuery+="AND SPED050.D_E_L_E_T_='' "
cQuery+="AND SF3010.D_E_L_E_T_=''  "
cQuery+="AND SF1010.D_E_L_E_T_=''  "
cQuery+="AND SF1010.F1_CHVNFE =''  "
cQuery+="AND STATUS NOT IN('6','7')  "
cQuery+="UNION  "
cQuery+="SELECT 'SF2' AS ORIGEM ,F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_VALCONT,F3_TIPO  "
cQuery+="FROM SF3010,SPED050,SF2010 "
cQuery+="WHERE "
cQuery+="    F3_FILIAL=F2_FILIAL "
cQuery+="AND F3_SERIE+F3_NFISCAL =NFE_ID  "
cQuery+="AND F2_CLIENTE=F3_CLIEFOR AND F2_LOJA=F3_LOJA "
cQuery+="AND  F2_SERIE+F2_DOC =NFE_ID  "
cQuery+="AND SPED050.D_E_L_E_T_='' "
cQuery+="AND SF2010.F2_CHVNFE =''  "
cQuery+="AND SF3010.D_E_L_E_T_=''  "
cQuery+="AND SF2010.D_E_L_E_T_=''  "
cQuery+="AND STATUS NOT IN('6','7')  "



TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
DbGotop()               
While !Eof()
	DatEmis:=Dtoc(Stod(TRB->F3_ENTRADA))
	OriNf:=Iif(TRB->ORIGEM="SF1","NFE-ENTRADA","NFE-SAIDA")
	If TRB->ORIGEM="SF1"
	     if TRB->F3_TIPO $'DB'
				NomeFC:=Posicione("SA1",1,xFilial("SA1")+TRB->F3_CLIEFOR+TRB->F3_LOJA,"A1_NOME")
		 Else 
				NomeFC:=Posicione("SA2",1,xFilial("SA2")+TRB->F3_CLIEFOR+TRB->F3_LOJA,"A2_NOME")
		 EndIF
	Endif
	If TRB->ORIGEM="SF2"
	     if TRB->F3_TIPO ='B'
				NomeFC:=Posicione("SA2",1,xFilial("SA2")+TRB->F3_CLIEFOR+TRB->F3_LOJA,"A2_NOME")
		 Else 
				NomeFC:=Posicione("SA1",1,xFilial("SA1")+TRB->F3_CLIEFOR+TRB->F3_LOJA,"A1_NOME")
		 EndIF
	Endif                                                  
	Aadd(aDados,{OriNf,DatEmis,F3_NFISCAL,F3_SERIE,F3_TIPO,F3_CLIEFOR,F3_LOJA,NOMEFC,Transform(F3_VALCONT,     "@E 9,999,999.99") })
    DbSelectArea("TRB")
	DbSkip()
EndDo
DbCloseArea()
If Len(Adados)>0
 GeraWorkFlow(aDados,"ATENÇÃO NF-E COM STATUS DIVERGENTE" )
 ADados:={}	
Endif  	

Return    
/***************************************************************************************/
Static Function GeraWorkFlow(aDados,Msg)
Local CodRot,MTo
CodRot:="WFE27"
                      

  If Len(aDados) > 0 

    Mto:= u_MontaRec(CodRot)
    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\RELNF.HTML" )
    oProcess :cSubject := "WFE27-"+Msg
    oProcess:cTo  := Mto
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=9 align="center"> '+"WFE27-"+Msg+'</td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Tipo de Nf </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Data Emissão</td>'
    cMen += ' <td align="center" width="09%"><font size="1" face="Times">Nota     </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Serie   </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times"> Tipo </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Cod Cli/For Tipo </td>'
    cMen += ' <td align="center" width="5%"><font size="1" face="Times">Loja </td>'
    cMen += ' <td align="center" width="40%"><font size="1" face="Times">Nome </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Valor </td>'
    cMen += ' </tr>'
                                                    
//	Aadd(aDados,{OriNf,DatEmis,F3_NFISCAL,F3_SERIE,F3_TIPO,F3_CLIEFOR,F3_LOJA,NOMEFC,Transform(F3_VALCONT,     "@E 9,999,999.99") }
 
      For x:= 1 to Len(aDados)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="05%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="05%"><font size="1" face="Times">'+ aDados[x][2] +'</td>'
        cMen += ' <td align="center" width="09%"><font size="1" face="Times">'+ aDados[x][3] + '</td>'
        cMen += ' <td align="left  " width="5%"><font size="1" face="Times">'+ aDados[x][4] +'</td>'
        cMen += ' <td align="left  " width="5"%"><font size="1" face="Times">'+ aDados[x][5] +'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][6] +'</td>'
        cMen += ' <td align="left  " width="5%"><font size="1" face="Times">'+ aDados[x][7] +'</td>'
        cMen += ' <td align="left  " width="50%"><font size="1" face="Times">'+ aDados[x][8] +'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][9] +'</td>'
        cMen += ' </tr>'
    
      Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
    
    oHtml:ValByName( "MENS", cMen)
    cEmUser:=u_MontaRec(CodRot)
    cMailId := oProcess:Start()
	    
  EndIf

  ConOut("Finalizou")

Return                                  
/*************************************/                
/**fim do exemplo do workflow*/