#INCLUDE "rwmake.ch"               
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE01     ºAutor  ³Jefferson Moreira   º Data ³  21/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIA PARA OS RESPONSAVEIS A RELAÇÃO DE ITENS EM INSPEÇÃO  º±±
±±º          ³ COM DE 24Hr DE SALDO NO ARMAZEM 98                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8  - Esse grava o e-mail enviado                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
  User Function WFE23
********************************  
  Local aProd := {}
  Local cProd,cMen 
  Local CodRot:="WFE23"
  Local Perg:="WFE23"

 Local aMoeda:={}        
 Private  Banco:={}
 Pergunte (Perg,.T.)
                                      
 
 DataF:=mv_par01+30
 DIni:=Dtos(mv_par01)
 DFim:=DTos(DataF)
//  Prepare Environment Empresa "01" Filial "01" Tables "SB1"  // Usado apenas quando o uso for por agendamento
 DCambio:=GeraDCambio(DIni,DFim) 
 SBancos:=GeraSaldBanco (DIni,DFim)   
 Titulos:=GeraContPagRec(DIni,DFIM)
     
  If Len(DCambio) > 0
  
    oProcess := TWFProcess():New( "000001", "Fluxo de Caixa da Nipoon Seiki do Brasil." )
    oProcess :NewTask( "100001", "\WORKFLOW\FLUXO.HTM" )
    oProcess :cSubject := "WFE23 - Fluxo de Caixa da Nipoon Seiki do Brasil Ltda."
    oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title>Fluxo de Caixa da Nipon Seiki do Brasil </title>"
    cMen := " </head>"    
    cMen += " <body>"
    /************************************************************************/
    /*********Informações do primeiro quadro  *******************************/
    /************************************************************************/
    
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="left" >'
    cMen += ' <td colspan=31 >Taxas de câmbio aplicadas </td></tr>' 
    cMen+=MontaCab("Cotações",mv_par01,30)
    cMen+=MontaDados("Dolar",DCambio,mv_par01)
    cMen+=MontaDados("Iene", DCambio,mv_par01)
    cMen += ' </table>'
    cMen += '<tr>'
    cMen += '</tr>'
    cMen += '<tr>'
    cMen += '</tr>'
    /*************************************************************************/


    /************************************************************************/
    /*********Informações do primeiro quadro  *******************************/
    /************************************************************************/
    
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="left" >'
    cMen += ' <td colspan=32 >Saldos Bancarios </td></tr>' 
    cMen+=MontaCab("Bancos",mv_par01,31,"Moeda")
    cMen+=MDadosBanco(Banco,SBancos,mv_par01,DCambio)
    cMen += ' </table>'
    cMen += '<tr>'
    cMen += '</tr>'
    cMen += '<tr>'
    cMen += '</tr>'

    /*************************************************************************/
    /*Informações sobre as carteiras******************************************/
    
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="left" >'
    cMen += ' <td colspan=31 >Carteiras a Pagar.</td></tr>' 
    cMen +=MontaCab("Tipo",mv_par01,30,"")
    cMen +=MDadosTitulo(Titulos,mv_par01,'P')
    cMen += ' </table>'


    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="left" >'
    cMen += ' <td colspan=32 >Carteiras a Receber.</td></tr>' 
    cMen+=MontaCab("Tipo",mv_par01,30,"")
    cMen+=MDadosTitulo(Titulos,mv_par01,'R')


    /*************************************************************************/



    cMen += " </body>"
    cMen += " </html>" 




    
    oHtml:ValByName( "MENS", cMen)
   // oProcess:ClientName( Subs(cUsuario,7,15) )
    Mto:= u_MontaRec(CodRot)
    oProcess:cTo  := Mto
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()

  EndIf
 
Return


/*********************************************************************************/
/*Gera os dados dos Saldos Bancarios *********************************************/
/*********************************************************************************/
Static Function GeraSaldBanco (Dinicial,DFinal) 
Local aDados:={}
cQuery:="SELECT A6_NREDUZ,E8_DTSALAT,SUM(E8_SALATUA)AS SALDO FROM SE8010,SA6010 "
cQuery+="WHERE E8_BANCO+E8_AGENCIA+E8_CONTA=A6_COD+A6_AGENCIA+A6_NUMCON "
cQuery+="AND A6_FLUXCAI='S' AND SE8010.D_E_L_E_T_='' AND SA6010.D_E_L_E_T_='' "
cQuery+="AND E8_DTSALAT>='"+Dinicial+"' and E8_DTSALAT<='"+DFinal+"' "  
cQuery+="GROUP BY A6_NREDUZ,E8_DTSALAT  "
cQuery+="ORDER BY A6_NREDUZ,E8_DTSALAT "

TCQUERY cQuery NEW ALIAS "SSE8"        





cQuery:= "SELECT A6_NREDUZ,E8_SALATUA AS SALDO FROM SE8010 A,SA6010 B "
cQuery+=" WHERE A.E8_BANCO+A.E8_AGENCIA+A.E8_CONTA=B.A6_COD+B.A6_AGENCIA+B.A6_NUMCON AND B.A6_FLUXCAI='S' AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND "
cQuery+=" A.E8_DTSALAT IN ( "
cQuery+=" select MAX(C.E8_DTSALAT) FROM SE8010 C,SA6010 D  where  "
cQuery+=" C.E8_BANCO+C.E8_AGENCIA+C.E8_CONTA=D.A6_COD+D.A6_AGENCIA+D.A6_NUMCON "
cQuery+=" AND D.A6_FLUXCAI='S' AND D.D_E_L_E_T_='' AND C.D_E_L_E_T_='' "
cQuery+=" AND C.E8_DTSALAT<'"+DIni+"'"
cQuery+=" AND D.A6_COD+D.A6_AGENCIA+D.A6_NUMCON=B.A6_COD+B.A6_AGENCIA+B.A6_NUMCON "
cQuery+=" )"
TCQUERY cQuery NEW ALIAS "SINI" 

/*
cQuery:="SELECT E8_BANCO,E8_DTSALAT,A6_NREDUZ,E8_SALATUA AS SALDO FROM SE8010 A,SA6010 "
cQuery+="WHERE E8_BANCO+E8_AGENCIA+E8_CONTA=A6_COD+A6_AGENCIA+A6_NUMCON "
cQuery+="AND A6_FLUXCAI='S' AND A.D_E_L_E_T_='' AND SA6010.D_E_L_E_T_='' "
cQuery+="AND E8_DTSALAT< '"+Dinicial+"' "  
cQuery+="AND E8_DTSALAT IN ("
cQuery+=" select MAX(E8_DTSALAT) FROM SE8010,SA6010 A  where  E8_BANCO+E8_AGENCIA+E8_CONTA=A6_COD+A6_AGENCIA+A6_NUMCON "
cQuery+=" and A6_FLUXCAI='S' and A.D_E_L_E_T_='' "
cQuery+=" and SE8010.E8_DTSALAT<='"+Dinicial+"')
TCQUERY cQuery NEW ALIAS "SINI" 
*/


cQuery:="SELECT A6_NREDUZ FROM SE8010,SA6010 "
cQuery+="WHERE E8_BANCO+E8_AGENCIA+E8_CONTA=A6_COD+A6_AGENCIA+A6_NUMCON "
cQuery+="AND A6_FLUXCAI='S' AND SE8010.D_E_L_E_T_='' AND SA6010.D_E_L_E_T_='' "
cQuery+="AND E8_DTSALAT<='"+Dinicial+"' "  
cQuery+="GROUP BY A6_NREDUZ "
cQuery+="ORDER BY A6_NREDUZ "
TCQUERY cQuery NEW ALIAS "SSA6"

DbSelectArea("SSA6")
DbGotop()
While !Eof()
    AAdd(banco,SSA6->A6_NREDUZ)
	DbSelectArea("SSA6")
	DbSkip()
End 

DbSelectArea("SSE8")
DbGotop()
While !SSE8->(Eof())
	  aaDD(aDados,{SSE8->A6_NREDUZ,SSE8->E8_DTSALAT,SSE8->SALDO})
	  SSE8->(DbSkip())
End
       
DBselectArea("SINI")
DBgotop()              
DataAtu:=DTos(mv_par01)
PosM:=0
DBselectArea("SINI")
DBgotop()
While !Eof()
	If !Empty(aDAdos) 
		PosM:=Ascan(aDados,{|x|x[1]=SINI->A6_NREDUZ .AND. x[2]=DataAtu }) 
	Endif
	If PosM=0
		aaDD(aDados,{SINI->A6_NREDUZ,DataAtu,SINI->SALDO})		
	EndIf
	DbSKip()
End 

DbSelectArea("SSA6")
DbGotop()
DataAtu:=mv_par01
AuxD:={}        
aSORT(aDados,,, { |x,y| x[1]+x[2] < y[1]+y[2] })

DBselectArea("SINI")
DbGotop()
While !Eof()
 	SConta:=0
 	DataAnt:=""
	DataAtu:=mv_par01
	For i:=1 to 30
 		PosM:=Ascan(aDados,{|x|x[1]==SINI->A6_NREDUZ .AND. x[2]==DTos(DataAtu)}) 

        if PosM=0
	  		For j:=1 to len(aDados)

    	   		if (aDados[j][1]=SINI->A6_NREDUZ) .and. aDados[j][2]<DTos(DataAtu)
			        DataAnt:=aDados[j][2]
					SConta:=aDados[j][3]
		   		EndIf 


                if !Empty(DataAnt) 
					Aux1:=Substr(aDados[j][2],7,2)+'/'+Substr(aDados[j][2],5,2)+'/'+Substr(aDados[j][2],1,4)
                    Aux2:=Substr(DataAnt,7,2)+'/'+Substr(DataAnt,5,2)+'/'+Substr(DataAnt,1,4)
		   			AuxD1:=STod(Aux1)
                    AuxD2=STod(Aux2)
		   			if (aDados[j][1]=SINI->A6_NREDUZ) .and. AuxD2+1<AuxD1 .and. aDados[j][2]>DTos(DataAtu)
						Exit
           			Endif 	
                EndiF 

					
//			   		Exit



			//	EndIf
	   		Next		
// 		   AAdd(aDados,{SINI->A6_NREDUZ,DTos(DataAtu),SConta})
 		   AAdd(aDados,{SINI->A6_NREDUZ,DTos(DataAtu),SConta})
		   aSORT(aDados,,, { |x,y| x[1]+x[2] < y[1]+y[2] })
	   	EndIF	
        DataAtu+=1
	Next     	
	DbSelectArea("SINI")
	DbSkip()
End 
DbSelectArea("SINI")
DbCloseArea()

                                                                                      
DbSelectArea("SSE8")	
DbCloseArea()

DbSelectArea("SSA6")	
DbCloseArea()	
aSORT(aDados,,, { |x,y| x[1]+x[2] < y[1]+y[2] })                            
Return aDados
/*********************************************************************************/
/***Gera contas a pagar e a receber************************************************/
/**********************************************************************************/
Static Function GeraContPagRec(Dini,DFim)

//Verifica o que foi pago e recebido no periodo ***/
DataAtu:=mv_par01
DataF:=Dtos(mv_par01)
DtF:=mv_par01+30
DtFim:=Dtos(DtF)

AuxPg:={} //aPagar
Aux1:={} //Vencidos
aDados:={}


///Verifica os Titulos já vencidos até a data inicial ******/
cQuery:=" select 'P' as TP , "
CQuery+=" SUM(E2_SALDO) AS VRVENC "
CQuery+=" FROM SE2010 WHERE D_E_L_E_T_='' AND E2_SALDO>0 and E2_TIPO NOT IN('PA','NDF') " 
CQuery+=" and E2_VENCREA<'"+DataF+"' "
cQuery+="UNION "
cQuery+="select 'R' as TP ," 
CQuery+=" SUM(E1_SALDO) AS VRVENC "
cQuery+=" FROM SE1010 WHERE D_E_L_E_T_='' AND E1_SALDO>0 "
CQuery+=" and E1_VENCREA<'"+DataF+"' "

TCQUERY cQuery NEW ALIAS "E1E2"

DbSelectArea("E1E2")
dbGotop()

While ! Eof()
    If E1E2->TP='R'
    	TitVencR:=E1E2->VRVENC
    Else 
		TitVencP:=E1E2->VRVENC    		
    EndIf 
	DbSkip()
End 
DbSelectArea("E1E2")
DbCloseArea()       
          


/*

DataAtu:=mv_par01 
Tp:="R"
For i:=1 to 30
   DataF:=DTos(DataAtu	)
   For j:=1 to 2
 	   if Tp="R"
 	     aaDD(aDados,{DataF,Tp,TitVencR,0,0})
	   Else 
 	     aaDD(aDados,{DataF,Tp,TitVencP,0,0})
	   EndIf 	
       Tp:="P"
   Next	
   DataAtu+=1
Next 
*/


cQuery:=" select 'P' as TP ,E2_VENCREA AS VENCTO ,sum(E2_SALDO) AS SALDO "
CQuery+=" FROM SE2010 WHERE D_E_L_E_T_='' AND E2_SALDO>0 AND E2_TIPO NOT IN('PA','NDF')  " 
CQuery+=" and E2_VENCREA>='"+DataF+"' and E2_VENCREA<='"+DtFim+"' "  	 
CQuery+=" Group by E2_VENCREA
cQuery+=" UNION "
cQuery+="select 'R' as TP ,E1_VENCREA  AS VENCTO ,SUM(E1_SALDO) AS SALDO " 
cQuery+=" FROM SE1010 WHERE D_E_L_E_T_='' AND E1_SALDO>0 "
CQuery+=" and E1_VENCREA>='"+DataF+"' and E1_VENCREA<='"+DtFim+"'"  	 
CQuery+=" Group by E1_VENCREA"
cQuery+=" ORDER BY VENCTO "       
TCQUERY cQuery NEW ALIAS "TRB"

DbSelectArea("TRB")
dbGoTop()
DbSelectArea("TRB")

//Títulos a pagar              
While ! Eof()
	aaDD(auxPg,{TRB->VENCTO,TRB->TP,TRB->SALDO})	
    DbSelectArea("TRB")
    DbSkip()
End

DbSelectArea("TRB")
DbCloseArea()

cQuery:=" select E5_DATA,E5_RECPAG,SUM(E5_VALOR)as Total from SE5010 "
cQuery+=" WHERE D_E_L_E_T_='' and  E5_DATA>='"+DataF+"' and E5_DATA<='"+DtFim+"' "
cQuery+=" GROUP BY E5_DATA,E5_RECPAG  "
cQuery+=" ORDER BY E5_DATA,E5_RECPAG 
TCQUERY cQuery NEW ALIAS "ASE5"                      

DbSelectArea("ASE5")
dbGoTop()
While ! Eof()
	aaDD(aux1,{ASE5->E5_DATA,ASE5->E5_RECPAG,ASE5->TOTAL})	
	DbSkip()
End
DbCloseArea("ASE5")


Tp:="R"
//ASort(aux1,,,{|x,y| x[1]<y[1] .and. x[2]<y[2] })
//ASort(auxPg,,,{|x,y| x[1]<y[1] .and. x[2]<y[2] })

For i:=1 to 30
   DataF:=Dtos(DataAtu)
   Tp="R"
   For j:=1 to 2

      If Tp="R" 
	      aaDD(aDados,{DataF,Tp,0,TitVencR,0})                                               	
      Else 
	      aaDD(aDados,{DataF,Tp,0,TitVencP,0})
      EndIF 
	  //Verifica os Pagos	
      Pos:=aScan(aux1,{|x|x[1]=DataF .and. x[2]=TP})
	  If Pos<>0
 		aDados[Len(aDados)][3]:=aux1[Pos][3]
	  EndIF 
      //Verifica a vencer 
      Pos1:=aScan(auxpg,{|x|x[1]=DataF .and. x[2]=TP})
	  If Pos1<>0
	    if Tp="R"
    		TitVencR+=AuxPg[Pos1][3]
    	Else 	    	
			TitVencP+=AuxPg[Pos1][3]
		EndIf 
 		aDados[Len(aDados)][5]:=auxPg[Pos1][3]
	  EndIF 
      Tp:="P"
 	Next
   //ASort(aDados,,,{|x,y| x[1]<y[1] .and. x[2]<y[2] })
   DataAtu+=1
Next 


Return aDados 



/*********************************************************************************/
/*********************************************************************************/
/*Gera os cambio *****************************************************************/
/*********************************************************************************/

Static Function GeraDCambio(Dinicial,DFinal) 
Local aDados :={}
DbSelectArea("SM2")



cQuery:=" select M2_DATA,M2_MOEDA2,M2_MOEDA5 FROM SM2010 "
cQuery+=" where D_E_L_E_T_='' AND M2_DATA>='"+Dini+"' and M2_DATA<='"+Dfim+"' and M2_MOEDA2>0 "
cQuery+=" order by M2_DATA " 
 
TCQUERY cQuery NEW ALIAS "SSM2"


cQuery:=" select M2_DATA,M2_MOEDA2,M2_MOEDA5 FROM SM2010 A "
cQuery+=" where A.D_E_L_E_T_='' "
cQuery+=" and M2_DATA IN(SELECT MAX(M2_DATA) FROM SM2010 WHERE M2_MOEDA2>0 ) 
cQuery+=" order by M2_DATA " 

TCQUERY cQuery NEW ALIAS "SCAM"        



DbSelectArea("SSM2")
DbGotop()
While !SSM2->(Eof())
	  aaDD(aDados,{SSM2->M2_DATA,SSM2->M2_MOEDA2,M2_MOEDA5})
	  SSM2->(DbSkip())
End

DbselectArea("SCAM")
DbGoTop()
if Empty(aDados)   
	  DtAux:=DTos(mv_par01)	
	  aaDD(aDados,{DtAux,SCAM->M2_MOEDA2,SCAM->M2_MOEDA5})
Endif              

TxDolar:=0
TxIene:=0
DataAtu:=mv_par01
For i:=1 to 30//Preenchendo o cambio 
	PosM=Ascan(aDados,{|x|x[1]=DTos(DataAtu)})
	If PosM<>0
	   TxDolar:=aDados[i][2]
	   TxIene:=aDados[i][3]
    Else 
    	aadd(aDados,{Dtos(DataAtu),txDolar,txIene})
	EndIf        
	DataAtu++
Next 

dbSelectArea("SSM2")	
DbCloseArea()
DbselectArea("SCAM")
DbCloseArea()

  
Return aDados
/*********************************************************************************/

Static Function MontaDados(Titulo,Dados,DIni)
Local cMen:=""

DataAtu:=Dini 
cMen := ' <tr>'

cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Titulo+'</Blink></font></td>'

if Titulo="Dolar" .OR. Titulo="Iene"
    For i:=1 to 30//Preenchendo o cambio 
		PosM=Ascan(Dados,{|x|x[1]=DTos(DataAtu)})
		If PosM<>0
		    if Titulo="Dolar"
		    	Taxa=Dados [PosM][2]
		    Else 
		    	Taxa=Dados [PosM][3]
		    EndIf 
		EndIf 
       cMen += ' <td align="center" width="12%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(Taxa,"@E 9.999999999" )+'</Blink></font></td>'
	   DataAtu+=1	
    Next 
Endif

cMen += ' </tr>'

Return cMen
/****************************************************************************************/
Static Function MontaCab(Titulo,DataIni,QtdCol,Titulo2)
Local cMen 

cMen := ' <tr >'	
cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Titulo+'</Blink></font></td>'
DataAtu=DataIni
if QtdCol=31
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Titulo2+'</Blink></font></td>'
    QtdCol=30	
Endif     

For i:=1 to QtdCol// Criando as datas 
    
  	DtFor:=substr(DTos(DataAtu),7,2)+'/'+substr(DTos(DataAtu),5,2)+'/'+substr(DTos(DataAtu),3,2)
   	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+DtFor+'</Blink></font></td>'
    DataAtu+=1
   
Next 
cMen += ' </tr>'                  
   
Return cMen 

/****************************************************************************************/



Static Function MDadosBanco(Banco,Dados,DIni,Cambio)
Local cMen:=""

//ASort(Dados,,,{|x,y|x[1]+x[2]<y[1]+y[2]})

For i:=1 to Len(Banco)
	DataAtu:=Dini 
	txMoeda=1
	DescM:="Real"
	cMen += ' <tr>'
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Banco[i]+'</Blink></font></td>'

	For M:=1 to 3
        DataAtu:=Dini 
		If M<>1
		    PosM=Ascan(Cambio,{|x|x[1]=DTos(DataAtu)})
		    if m=2
			    txMoeda:=Cambio[PosM][2]
			    DescM:="Dolar"
			Else 
				txMoeda:=Cambio[PosM][3]			
			    DescM:="Iene"
			EndIf 
			cMen += ' <tr>'
	  		cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink></Blink></font></td>'

		Endif 
		cMen += ' <td align="center" width="01%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+DescM+'</Blink></font></td>'		
		For j:=1 to 30
			PosM:=Ascan(Dados,{|x|Alltrim(x[1])==Alltrim(Banco[i]) .AND. x[2]==DTos(DataAtu)}) 
	    	If PosM<>0
				Saldo:=(DAdos[PosM][3]/txMoeda)//Valor dividido por 1 milhão. 
				If M<>1
				Saldo:=Saldo/1000000 //Valor dividido por 1 milhão. 
                EndIf 
				cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(Saldo,"@E 999,999,999,999.99")+'</Blink></font></td>'		
			EndIf	
			DataAtu+=1
		Next 
		cMen += ' </tr>'

	Next
	
	cMen += ' </tr>'

Next 
//	   	  	 AAdd(aDados,{SSA6->A6_NREDUZ,DTos(DataAtu),SConta})

Return cMen


/******************************************************************************************************/
Static Function MDadosTitulo(Titulos,mv_par01,Tp)
Local cMen:=""
If tp="P"
	Desc:={"Titulos Pagos ","Titulos a Pagar ", "Titulos Vencidos " }
Else 
	Desc:={"Titulos Recebidos ","Titulos a Receber ", "Titulos Vencidos " }
EndIF 

Saldo:=0
For i:=1 to 3
	DataAtu:=mv_par01
	cMen += ' <tr>'
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Desc[i]+'</Blink></font></td>'
	Saldo:=0	
	For j:=1 to 30
		DataF:=Dtos(DataAtu)
		Pos:=Ascan(Titulos,{|x|Alltrim(x[1])==Alltrim(DataF) .AND. x[2]==Tp}) 
    	If Pos<>0
            Do Case
            	Case i=1
            	  Saldo:=Titulos[Pos][3]
            	Case i=2  
            	  Saldo:=Titulos[Pos][5]
            	Otherwise  
                  Saldo:=Titulos[Pos][4]
            EndCase
            cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+Transform(Saldo,"@@E 999,999,999,999.99")+'</Blink></font></td>'		
		EndIf	
		DataAtu+=1
	Next 
    cMen+= '</tr>

Next 

Return cMen


			
/******************************************************************************************************/
