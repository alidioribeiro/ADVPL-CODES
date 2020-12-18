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
User Function WFE017
Local aCampos     := {}
Local cGera := "" 

Prepare Environment Empresa "01" Filial "01" Tables "SE2"

cQuery:=""

DataVenc:=DdataBase-1
DataVenc:=Dtos(DataVenc)

/*Seleciona dados */

cQuery := " select E2_SALDO,E2_VALOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR, "
cQuery +=" SUBSTRING(E2_EMISSAO,7,2)+'/'+SUBSTRING(E2_EMISSAO,5,2)+'/'+SUBSTRING(E2_EMISSAO,1,4) AS EMISSAO, "
cQuery +=" SUBSTRING(E2_VENCTO,7,2)+'/'+SUBSTRING(E2_VENCTO,5,2)+'/'+SUBSTRING(E2_VENCTO,1,4) AS VENCTO, "
cQuery +=" DATEDIFF(day,CONVERT (datetime,E2_VENCTO ), getdate()) AS DIASDIF "
cQuery  +=" from SE2010 WHERE E2_TIPO IN('NDF','PA') AND E2_SALDO>0 and E2_VENCTO <='"+Datavenc+"' "      

cQuery += " and D_E_L_E_T_=''   "
cQuery  +=" order by DIASDIF DESC "
TCQUERY cQuery NEW ALIAS "TRB"
	         
 dbSelectArea("TRB")
 nQuant := 0
        
        //Checa quantos registro possue a Query
 While !EOF()
		nQuant++
         dbSkip()
  Enddo      
  aDados:={}        
  ProcRegua(nQuant)
  TRB->(dbGotop())      
  Cont:=1
  While !EOF()                
		  	IncProc()
			AADD(aDados  , {E2_PREFIXO,;
									  E2_NUM,;
									  E2_PARCELA,;	
                                      E2_VALOR,;
                                      E2_SALDO,;
									  E2_TIPO,;	
									  E2_FORNECE,;
									  E2_LOJA,;
									  E2_NOMFOR,;
									  EMISSAO,;
									  VENCTO,; 
									  Cont,;
									  Str(DiasDif) })
  			Cont++									  								         
									  
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
CodRot:="WFE17"
                      

  If Len(aDados) > 0 
    DataF:=  Dtos(Ddatabase-1)
    DataF:=  Substr(DataF,5,2)+"/"+Substr(DataF,1,4)
    Mto:= u_MontaRec(CodRot)
    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\TITULOS.HTM" )
    oProcess :cSubject := "WF17 - TITULOS A PAGAR NDF/PA "
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=13 align="center"> WFE17 - TÍTULOS A PAGAR PENDENTES ( NDF/PA) </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Item     </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Prefixo     </td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">Numero   </td>'
   cMen += ' <td align="center" width="05%"><font size="1" face="Times"> Parcela   </td>'
   cMen += ' <td align="center" width="10%"><font size="1" face="Times"> Cod For  </td>'
   cMen += ' <td align="center" width="03%"><font size="1" face="Times"> Loja  </td>'
   cMen += ' <td align="center" width="40%"><font size="1" face="Times"> Nome Fornecedor </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times"> Tipo  </td>'
    cMen += ' <td align="center" width="14%"><font size="1" face="Times">Valor do titulo </td>'
    cMen += ' <td align="center" width="20%"><font size="1" face="Times">Saldo do titulo </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Emissao </td>'
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Vencto </td>' 
    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Dias em Atraso </td>' 

    cMen += ' </tr>'

      For x:= 1 to Len(aDados)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="05%"><font size="1" face="Times">'+Str(aDados[x][12]) +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][2] + '</td>'
        cMen += ' <td align="left  " width="05%"><font size="1" face="Times">'+ aDados[x][3] +'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][7] +'</td>'
        cMen += ' <td align="left  " width="03%"><font size="1" face="Times">'+ aDados[x][8] +'</td>'
        cMen += ' <td align="left  " width="40%"><font size="1" face="Times">'+ aDados[x][9] +'</td>'
        cMen += ' <td align="left  " width="5%"><font size="1" face="Times">'+ aDados[x][6] +'</td>'
        cMen += ' <td align="left  " width="14%"><font size="1" face="Times">'+ str(aDados[x][4] )+'</td>'
        cMen += ' <td align="left  " width="20%"><font size="1" face="Times">'+ str(aDados[x][5] )+'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][10] +'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][11]+'</td>'
        cMen += ' <td align="left  " width="10%"><font size="1" face="Times">'+ aDados[x][13]+'</td>'
      
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
/**************************/

/**********************************************************************************************************************************************/                                             
/**********************************************************************************************************************************************/
/**fim do exemplo do workflow*/