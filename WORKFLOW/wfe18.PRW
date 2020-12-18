#include "rwmake.ch"
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH" 

/*
Criacao....: Desenvolvido por Aglair Ishii em 09/08/09
Resultado..: Sera gera um workflow dos títulos a receber. 
*/

*******************************************************************************************
User Function WFE018
Local aCampos     := {}
Local cGera := "" 
Local DatVenc

Prepare Environment Empresa "01" Filial "01" Tables "SE1"



cQuery:=""

DataVenc:=DdataBase-1
DataVenc:=Dtos(DataVenc)
/*Seleciona dados */
cQuery := " SELECT  E1_SALDO,E1_VALOR,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA,E1_NOMCLI, "
cQuery += " SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) AS EMISSAO, "
cQuery +=" SUBSTRING(E1_VENCTO,7,2)+'/'+SUBSTRING(E1_VENCTO,5,2)+'/'+SUBSTRING(E1_VENCTO,1,4) AS VENCTO, " 
cQuery +=" DATEDIFF(day,CONVERT (datetime,E1_VENCTO ), getdate()) AS DIASDIF "
cQuery +="  FROM SE1010,SA1010  WHERE E1_TIPO in('NCC' ,'NF') AND E1_SALDO>0  AND SA1010.D_E_L_E_T_=''  AND  SE1010.D_E_L_E_T_='' AND  SA1010.D_E_L_E_T_=''  AND "
cQuery += " E1_VENCTO <='"+DataVenc+"' "
cQuery +="  AND RTRIM(A1_COD)+A1_LOJA=RTRIM(E1_CLIENTE)+E1_LOJA AND A1_EST<>'EX'  "
cQuery +=" order by DIASDIF desc"
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
			AADD(aDados  , {E1_PREFIXO,;
									  E1_NUM,;
									  E1_PARCELA,;	
                                      E1_VALOR,;
                                      E1_SALDO,;
									  E1_TIPO,;	
									  E1_CLIENTE,;
									  E1_LOJA,;
									  E1_NOMCLI,;
									  EMISSAO,;
									  VENCTO,; 
									  Cont,;
									  Str(DIASDIF) })
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
    oProcess := TWFProcess():New( "000003", "" )
    oProcess :NewTask( "100003", "\WORKFLOW\TITREC.HTML" )
    oProcess :cSubject := "WF18 - TITULOS A RECEBER NCC/NF  "
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=13 align="center"> WFE18 - TÍTULOS A RECEBER PENDENTES ( NCC/NF) </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times">Item     </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Prefixo     </td>'
    cMen += ' <td align="center" width="06%"><font size="1" face="Times">Numero   </td>'
   cMen += ' <td align="center" width="05%"><font size="1" face="Times"> Parcela   </td>'
   cMen += ' <td align="center" width="10%"><font size="1" face="Times"> Cod Cli  </td>'
   cMen += ' <td align="center" width="03%"><font size="1" face="Times"> Loja  </td>'
   cMen += ' <td align="center" width="40%"><font size="1" face="Times"> Cliente  </td>'
    cMen += ' <td align="center" width="05%"><font size="1" face="Times"> Tipo  </td>'
    cMen += ' <td align="center" width="14%"><font size="1" face="Times">Valor do titulo </td>'
    cMen += ' <td align="center" width="20%"><font size="1" face="Times">Saldo do titulo</td>'
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
/*************************************/                
/**fim do exemplo do workflow*/