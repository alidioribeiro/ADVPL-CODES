#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH" 

/*
Criacao....: Desenvolvido por Aglair Ishii em 09/03/05
Objetivo...: Este programa tera como parametros a Data de inicio e a Data Fim do Periodo para
             geração dos Dados
Resultado..: Sera gerado um arquivo em formato Excel chamado Notas Entrada de Dt.Ini a Dt. Fim.XLS
             que trara as informacoes das Notas Fiscais de Entradas do Periodo.
*/

*******************************************************************************************
User Function WFE025
Local aCampos     := {}
Local cGera := "" 
Local aDados:={}                       

Prepare Environment Empresa "01" Filial "01" Tables "SCP,SB1,CTT"
cQuery:=""

/*Seleciona dados */                     
cQuery:=" SELECT CP_NUM,CP_ITEM,CP_PRODUTO,CP_DESCRI,CP_UM,CP_QUANT-CP_QUJE as QTD,CP_QUANT,CP_QUJE, CP_SOLICIT,CP_CC,CTT_DESC01,CP_EMISSAO "
cQuery+=" FROM SCP010,CTT010,SB1010 "
cQuery+=" WHERE "
cQuery+=" CP_PRODUTO=B1_COD    and "
cQuery+=" B1_TIPO   ='MC'      and "
cQuery+=" CTT_CUSTO=CP_CC      and "
cQuery+=" CP_PREREQU='S'       and "
cQuery+=" CP_QUANT<>CP_QUJE    and "
cQuery+=" SCP010.D_E_L_E_T_='' and "
cQuery+=" CTT010.D_E_L_E_T_='' and "
cQuery+=" SB1010.D_E_L_E_T_='' "


TCQUERY cQuery NEW ALIAS "TRB"
	         
dbSelectArea("TRB")
DbGotop()        
        //Checa quantos registro possue a Query
While !EOF()      
           
	AADD(aDados  , {Dtoc(SToD(CP_EMISSAO)),;
		           CP_CC,;
		           CTT_DESC01,;
		           CP_NUM,;
		           CP_ITEM,;
		           CP_PRODUTO,;
		           CP_DESCRI,;
		           CP_UM,;
		           Transform(CP_QUANT,'@ 999.99'),;
		           Transform(QTD,'@ 999.99'),;
		           CP_SOLICIT})
		           
	dbSelectArea("TRB")
    dbSkip()
EndDo
DbCloseArea("TRB")
If Len(Adados)>0
   	GeraWorkFlow(aDados)
Endif  	
Return    

*****************************************************************************************
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡„o ³ Ajusta perguntas do SX1                                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*exemplo de work flow */      

Static Function GeraWorkFlow(aDados,DataF)
Local CodRot,MTo
CodRot:="WFE25"
                      

  If Len(aDados) > 0 
    DataF:=  Dtoc(Ddatabase)
    Mto:= u_MontaRec(CodRot)
    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\SOLMC.HTM" )
    oProcess :cSubject := "WFE25 - MATERIAL DE CONSUMO A LIBERAR NA DATA "+ DATAF
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=11 align="center"> WFE25 - Material de consumo a liberar. </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Data Req </td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">C.Custos</td>'
    cMen += ' <td align="center" width="20%"><font size="1" face="Times">Descrição</td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">Requisição     </td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">Item  </td>'
    cMen += ' <td align="center" width="20%"><font size="1" face="Times">Produto </td>'
    cMen += ' <td align="center" width="40%"><font size="1" face="Times">Descrição </td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">UN </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Quantidade </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Saldo </td>'
    cMen += ' <td align="center" width="20%"><font size="1" face="Times">Solicitante</td>'
    cMen += ' </tr>'
/*
 {Dtoc(SToD(CP_EMISSAO)),;   //1
		           CP_CC,;   //2
		           CP_DESC01,;//3
		           CP_NUM,;  //4
		           CP_ITEM,; //5
		           CP_PRODUTO,;//6
		           CP_DESCRI,; //7
		           CP_UM,;    //8
		           Transform(CP_QUANT,'@ 999.99'),; //9
		           Transform(QTD,'@ 999.99'),; //10
		           CP_SOLICI}) */

      For x:= 1 to Len(aDados)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="06%"><font size="1" face="Times">'+ aDados[x][2] +'</td>'
        cMen += ' <td align="center" width="20%"><font size="1" face="Times">'+Alltrim(aDados[x][3]) +'</td>'
        cMen += ' <td align="center" width="06%"><font size="1" face="Times">'+ aDados[x][4] +'</td>'
        cMen += ' <td align="center" width="06%"><font size="1" face="Times">'+ aDados[x][5] +'</td>'
        cMen += ' <td align="center" width="20%"><font size="1" face="Times">'+ aDados[x][6] +'</td>'
        cMen += ' <td align="center" width="40%"><font size="1" face="Times">'+ aDados[x][7] +'</td>'
        cMen += ' <td align="center" width="06%"><font size="1" face="Times">'+ aDados[x][8] +'</td>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][9] +'</td>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][10] +'</td>'
        cMen += ' <td align="center" width="20%"><font size="1" face="Times">'+ aDados[x][11] +'</td>'
        cMen += ' </tr>'
    
      Next
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
      
    oHtml:ValByName( "MENS", cMen)
	Mto:= u_MontaRec(CodRot)
    oProcess:cTo  := Mto
    cMailId := oProcess:Start()
     
  EndIf

  ConOut("Finalizou")

Return