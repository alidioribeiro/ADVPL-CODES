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
User Function WFE016
Local aCampos     := {}
Local cGera := "" 

Prepare Environment Empresa "01" Filial "01" Tables "SD1","SB1"

cQuery:=""

/*Seleciona dados */
cQuery := " SELECT  D1_COD,SUM(D1_QUANT) as QUANT ,cast(SUM(D1_TOTAL) as numeric (14,2)) AS TOTAL  "
cQuery += "FROM  SD1010  "
//cQuery := "SELECT D1_FILIAL, substring(D1_DTDIGIT,7,2)+'/'+substring(D1_DTDIGIT,5,2)+'/'+substring(D1_DTDIGIT,1,4) AS DIGIT,D1_FORNECE,D1_LOJA, D1_COD,D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_CF,D1_QUANT, D1_VUNIT,D1_TOTAL, D1_VALICM, D1_COD "
cQuery += "WHERE  "
cQuery += "  D_E_L_E_T_ = ' '  AND "
 cQuery += "  SUBSTRING(D1_DTDIGIT,1,4) LIKE datepart(year,getdate()-1) AND  " 
 cQuery += " CAST( SUBSTRING(D1_DTDIGIT,5,2) AS INT ) LIKE datepart(month,getdate()-1)  " 
 		//Seleciona por centro de custo 
cQuery += " AND D1_CC= '241'  "                                                     
 		//Exclui as notas de complemento de frete
cQuery += " AND D1_QUANT>0  "                                                     
cQuery += " group by  D1_COD "
//cQuery += "ORDER BY D1_DTDIGIT "

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

  While !EOF()                
            
		  	IncProc()
       	  cDescProd := ""
            SB1->(dbSetOrder(1))
            If SB1->(dbSeek(xFilial("SB1")+TRB->D1_COD))
               cDescProd := SB1->B1_DESC
            EndIf               
	 
			AADD(aDados  , {D1_COD,;
       	   						   cDescProd,;                                                                             
		 							QUANT,; 
									TOTAL})
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
Local CodRot,MTo,x
CodRot:="WFE16"
                      

  If Len(aDados) > 0 
    DataF:=  Dtos(Ddatabase-1)
    DataF:=  Substr(DataF,5,2)+"/"+Substr(DataF,1,4)
    Mto:= u_MontaRec(CodRot)
    oProcess := TWFProcess():New( "000030", "" )
    oProcess :NewTask( "teste", "\WORKFLOW\NOTAENT.HTM" )
    oProcess :cSubject := "WF16 - TOTAL DE ENTRADAS NO MES "+DataF
    oHTML    := oProcess:oHTML
 
        
    aMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"  
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <td colspan=4 align="center"> WFE16 - Total de entradas no mes </td></tr>'
    cMen += ' <tr >'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Codigo     </td>'
    cMen += ' <td align="center" width="40%"><font size="1" face="Times">Descrição  </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Quantidade </td>'
    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Valor Total </td>'
    cMen += ' </tr>'

      For x:= 1 to Len(aDados)
        cMen += ' <tr>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ aDados[x][1] +'</td>'
        cMen += ' <td align="center" width="10%"><font size="1" face="Times">'+ aDados[x][2] + '</td>'
        cMen += ' <td align="left  " width="15%"><font size="1" face="Times">'+ Str(aDados[x][3]) +'</td>'
        cMen += ' <td align="center" width="03%"><font size="1" face="Times">'+ Str( aDados[x][4]) +'</td>'
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
/**********************************************************************************************************************************************/                                             
/**********************************************************************************************************************************************/
User Function MontaRec(CodRot)
Local RecEmail 
RecEmail:=""
CodRot:=Alltrim(CodRot)+Replicate(" ",8-Len(CodRot))

DbSelectArea ("ZWF")
DbSetOrder(1)
Chave:="  "+CodRot
If DbSeek(Chave)  
	While Chave==ZWF->ZWF_FILIAL + ZWF->ZWF_ROT                                                                                                        
		RecEmail+=";"+Alltrim(ZWF->ZWF_EMAIL) 
		DbSkip()
	EndDo              
	RecEmail:=substr(RecEmail,2,Len(RecEmail)-1)
Endif
Return RecEmail

/**********************************************************************************************************************************************/
/**fim do exemplo do workflow*/