#INCLUDE "rwmake.ch"               
#INCLUDE "Protheus.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFE01     บAutor  ณJefferson Moreira   บ Data ณ  21/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ENVIA PARA OS RESPONSAVEIS A RELAวรO DE ITENS EM INSPEวรO  บฑฑ
ฑฑบ          ณ COM DE 24Hr DE SALDO NO ARMAZEM 98                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8  - Esse grava o e-mail enviado                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

********************************
  User Function WFE24
********************************  
  Local aProd := {}
  Local cProd,cMen 
  Local CodRot:="WFE23"
  Local Perg:="WFE23"

 Local aMoeda:={}        
 Private  Banco:={}
 Pergunte (Perg,.T.)
                                      
  

 mv_par01:=DDatabase 
 Dini:= mv_par01-30              

 If DIni<Stod("20100401")
 	DIni:=Stod("20100401")
 EndIf  

 
 DIni:=Dtos(DIni)
 DFim:=DTos(DDataBase)       
 DifData:=STod(DFim)-STod(Dini)+1 

//  Prepare Environment Empresa "01" Filial "01" Tables "SB1"  // Usado apenas quando o uso for por agendamento
 DCambio:=GeraDCambio(DIni,DFim) 
 SBancos:=GeraSaldBanco (DIni,DFim)   
 Titulos:=GeraContPagRec(DIni,DFIM)
     
  If Len(DCambio) > 0
  
    oProcess := TWFProcess():New( "000001", "Fluxo de Caixa Realizado na Nipoon Seiki do Brasil." )
    oProcess :NewTask( "100001", "\WORKFLOW\FLUXOR.HTM" )
    oProcess :cSubject := "WFE24 - Fluxo de Caixa Realizado na Nipoon Seiki do Brasil Ltda."
    oHTML    := oProcess:oHTML 
    
    //qout("Entrou no Html")
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title>Fluxo de Caixa da Nipon Seiki do Brasil </title>"
    cMen := " </head>"    
    cMen += " <body>"                                             
    /************************************************************************/
    /*********Informa็๕es do primeiro quadro  *******************************/
    /************************************************************************/
    NCol:=DifData+1
    cMen += ' <table border="1" width="750">'
    cMen += ' <tr width="600" align="left" >'
    cMen += ' <td colspan=30 >TAXAS DE CยMBIO APLICADAS </td></tr>' 
    cMen+=MontaCab("Cota็๕es",DIni,DifData)
    cMen+=MontaDados("Dolar",DCambio,DIni,DFim)
    cMen+=MontaDados("Iene", DCambio,DIni,DFim)            
    //teste grafico *//
	cMen+=' <td class="td"> '
    cMen+='<script language="JavaScript"> <!--'
    cMen+=' graph = new BAR_GRAPH("vBar"); '
    cMen+=' graph.values = "88,150,260,310,500"; '
    cMen+=' document.write(graph.create()); '
    cMen+=' //--> </script>'
    cMen+='</td> '
 
    cMen+=MDadosBanco(Banco,SBancos,DIni,DCambio,DifData)

    cMen +=MDadosTitulo(Titulos,DIni,'P')
	 cMen+=MDadosTitulo(Titulos,DIni,'R')
    cMen += ' </table>'
    cMen += '<tr>'
    cMen += '</tr>'
    cMen += '<tr>'
    cMen += '</tr>'
    /*************************************************************************/


    /************************************************************************/
    /*********Informa็๕es do primeiro quadro  *******************************/
    /************************************************************************/
    
//t    cMen += ' <table border="1" width="750">'
//t    cMen += ' <tr width="600" align="left" >'
//t    cMen += ' <td colspan=32 >Saldos Bancarios </td></tr>' 
//t    cMen+=MontaCab("Bancos",DIni,DifData,"Moeda")
//t   cMen+=MDadosBanco(Banco,SBancos,DIni,DCambio,DifData)
//t    cMen += ' </table>'
   cMen += '<tr>'
    cMen += '</tr>'
    cMen += '<tr>'
    cMen += '</tr>'

    /*************************************************************************/
    /*Informa็๕es sobre as carteiras******************************************/
    
//t    cMen += ' <table border="1" width="750">'
//t    cMen += ' <tr width="600" align="left" >'
//t    cMen += ' <td colspan=31 >Carteiras a Pagar.</td></tr>' 
//t    cMen +=MontaCab("Tipo",Dini,DifData)
//t    cMen +=MDadosTitulo(Titulos,DIni,'P')
//T    cMen += ' </table>'


//t    cMen += ' <table border="1" width="750">'
//t    cMen += ' <tr width="600" align="left" >'
//t    cMen += ' <td colspan=32 >Carteiras a Receber.</td></tr>' 
//t    cMen+=MontaCab("Tipo",DIni,DifData,"")
//t    cMen+=MDadosTitulo(Titulos,DIni,'R')


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
/*Aplica็๕es/Empr้stimos**********************************************************/
/********************************************************************************/
Static Function GeraAplicEmp (DInicial,DFinal)


//cQuery+=" select E5_DATA,

cQuery:=" select EH_DATA,EH_APLEMP,EH_NBANCO,EH_AGENCIA,EH_CONTA,EH_NBANCO,SUM(EH_VALOR)AS VALOR FROM SEH010 
cQuery+=" WHERE EH_DATA >='"+DInicial+"' and EH_DATA<='"+DFinal+"' "
cQuery+=" and EH_VALREG<>EH_VALOR AND D_E_L_E_T_='' AND  " 



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



/*
cQuery:= "SELECT A6_NREDUZ,E8_SALATUA AS SALDO FROM SE8010 A,SA6010 B "
cQuery+=" WHERE A.E8_BANCO+A.E8_AGENCIA+A.E8_CONTA=B.A6_COD+B.A6_AGENCIA+B.A6_NUMCON AND B.A6_FLUXCAI='S' AND A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' AND "
cQuery+=" A.E8_DTSALAT IN ( "
cQuery+=" select MAX(C.E8_DTSALAT) FROM SE8010 C,SA6010 D  where  "
cQuery+=" C.E8_BANCO+C.E8_AGENCIA+C.E8_CONTA=D.A6_COD+D.A6_AGENCIA+D.A6_NUMCON "
cQuery+=" AND D.A6_FLUXCAI='S' AND D.D_E_L_E_T_='' AND C.D_E_L_E_T_='' "
cQuery+=" AND C.E8_DTSALAT<'"+DInicial+"'"
cQuery+=" AND D.A6_COD+D.A6_AGENCIA+D.A6_NUMCON=B.A6_COD+B.A6_AGENCIA+B.A6_NUMCON "
cQuery+=" )"
*/
 
cQuery:=" select A6_NREDUZ,C.E8_BANCO,C.E8_AGENCIA,C.E8_CONTA,D.A6_NREDUZ,MAX(C.E8_DTSALAT)AS DTSALD "
cQuery+="	FROM SE8010 C,SA6010 D  "
cQuery+="  where   C.E8_BANCO=D.A6_COD AND C.E8_AGENCIA=D.A6_AGENCIA AND C.E8_CONTA=D.A6_NUMCON  AND D.A6_FLUXCAI='S' AND D.D_E_L_E_T_='' AND C.D_E_L_E_T_=''  AND C.E8_DTSALAT<'"+DInicial+"'"
cQuery+=" AND D.A6_FLUXCAI='S' "
cQuery+=" GROUP BY A6_NREDUZ,C.E8_BANCO,C.E8_AGENCIA,C.E8_CONTA,D.A6_NREDUZ "

TCQUERY cQuery NEW ALIAS "SINI" 



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
DataAtu:=Dinicial
DifData:=Stod(DFinal)-Stod(DInicial)+1
PosM:=0
DBselectArea("SINI")
DBgotop()
While !Eof()
	    
	If !Empty(aDAdos) 
		PosM:=Ascan(aDados,{|x|x[1]=SINI->A6_NREDUZ .AND. x[2]=DataAtu }) 
	Endif

    if PosM=0
	    Chave:=SINI->E8_BANCO+SINI->E8_AGENCIA+SINI->E8_CONTA+SINI->DTSALD 
	    SaldC:=Posicione("SE8",1,xFilial("SE8")+Chave,"E8_SALATUA")
		aaDD(aDados,{SINI->A6_NREDUZ,DataAtu,SaldC})		

    Endif
    
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
AuxD:={}        
aSORT(aDados,,, { |x,y| x[1]+x[2] < y[1]+y[2] })

DBselectArea("SINI")
DbGotop()
While !Eof()
 	SConta:=0
 	DataAnt:=""
	DataAtu:=STod(DInicial)
	For i:=1 to DifData
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
DataAtu:=Stod(Dini)
DataF:=DIni
DtF:=STod(DFim)
DtFim:=Dtos(DtF)

AuxPg:={} //aPagar
Aux1:={} //Vencidos
aDados:={}


///Verifica os Titulos jแ vencidos at้ a data inicial ******/
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

//Tํtulos a pagar              
While ! Eof()
	aaDD(auxPg,{TRB->VENCTO,TRB->TP,TRB->SALDO})	
    DbSelectArea("TRB")
    DbSkip()
End

DbSelectArea("TRB")
DbCloseArea()

cQuery:=" select E5_DATA,E5_RECPAG,SUM(CASE WHEN E5_TIPODOC<>'ES' THEN  E5_VALOR ELSE 0 END )as Total, "
cQuery+=" SUM(CASE WHEN E5_TIPODOC='ES' AND substring(Ltrim(E5_KEY),1,1)<>' ' THEN E5_VALOR Else 0 End) as QtdEst, "
cQuery+=" SUM(CASE WHEN E5_TIPODOC='DC' THEN  E5_VALOR ELSE 0 END )as VrDesC "
cQuery+=" from SE5010 "
cQuery+=" WHERE D_E_L_E_T_='' and  E5_DATA>='"+DataF+"' and E5_DATA<='"+DtFim+"' AND E5_SITUACA<>'C' "
cQuery+=" and E5_TIPODOC	NOT IN('CH','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BL','EC','RF') "
//cQuery+=" AND E5_TIPO <>'NDF' AND E5_TIPODOC<>'CP' "
cQuery+=" GROUP BY E5_DATA,E5_RECPAG  "
cQuery+=" ORDER BY E5_DATA,E5_RECPAG "
/*
cQuery+=" UNION
cQuery+=" select E5_DATA,E5_RECPAG,SUM(E5_VALOR)as Total from SE5010 "
cQuery+=" WHERE D_E_L_E_T_='' and  E5_DATA>='"+DataF+"' and E5_DATA<='"+DtFim+"' AND E5_TIPODOC='ES' AND E5_KEY<>'' "
cQuery+=" GROUP BY E5_DATA,E5_RECPAG  "
cQuery+=" ORDER BY E5_DATA,E5_RECPAG 
*/

TCQUERY cQuery NEW ALIAS "ASE5"                      

DbSelectArea("ASE5")
dbGoTop()
While ! Eof()
	aaDD(aux1,{ASE5->E5_DATA,ASE5->E5_RECPAG,ASE5->TOTAL+ASE5->QTDEST-ASE5->VrDesC})	
	DbSkip()
End
DbCloseArea("ASE5")


Tp:="R"
//ASort(aux1,,,{|x,y| x[1]<y[1] .and. x[2]<y[2] })
//ASort(auxPg,,,{|x,y| x[1]<y[1] .and. x[2]<y[2] })

DifData:=Stod(DFim)-Stod(Dini)+1
For i:=1 to DifData
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

DifData:=Stod(DFinal)-Stod(DInicial)+1

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
	  DtAux:=DInicial
	  aaDD(aDados,{DtAux,SCAM->M2_MOEDA2,SCAM->M2_MOEDA5})
Endif              

TxDolar:=0
TxIene:=0
DataAtu:=Stod(Dinicial)
For i:=1 to DifData//Preenchendo o cambio 
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

Static Function MontaDados(Titulo,Dados,DIni,DFim)
Local cMen:=""

DataAtu:=STod(Dini)
DifData:=Stod(DFim)-Stod(Dini)+1

cMen := ' <tr>'

cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Titulo+'</Blink></font></td>'
cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+'' +'</Blink></font></td>'
	
if Titulo="Dolar" .OR. Titulo="Iene"
    For i:=1 to DifData //Preenchendo o cambio 
		PosM=Ascan(Dados,{|x|x[1]=DTos(DataAtu)})
		If PosM<>0
		    if Titulo="Dolar"
		    	Taxa=Dados [PosM][2]
		    Else 
		    	Taxa=Dados [PosM][3]
		    EndIf 
		EndIf 
//t       cMen += ' <td align="center" width="12%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Transform(Taxa,"@E 9.999999999" )+'</Blink></font></td>'
       cMen += ' <td align="center" width="12%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Transform(Taxa,"@E 9.999999999" )+'</Blink></font></td>'
	   DataAtu+=1	
    Next 
Endif

cMen += ' </tr>'

Return cMen
/****************************************************************************************/
Static Function MontaCab(Titulo,DataIni,QtdCol,Titulo2)
Local cMen 

cMen := ' <tr >'	
cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Titulo+'</Blink></font></td>'
DataAtu=STod(DataIni)
//t if !Empty(Titulo2)
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+'' +'</Blink></font></td>'
//   QtdCol+=1
//tEndif     

For i:=1 to QtdCol// Criando as datas 
    
  	DtFor:=substr(DTos(DataAtu),7,2)+'/'+substr(DTos(DataAtu),5,2)+'/'+substr(DTos(DataAtu),3,2)
   	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+DtFor+'</Blink></font></td>'
    DataAtu+=1
   
Next 
cMen += ' </tr>'                  
   
Return cMen 

/****************************************************************************************/



Static Function MDadosBanco(Banco,Dados,DIni,Cambio,DifData)
Local cMen:=""

//ASort(Dados,,,{|x,y|x[1]+x[2]<y[1]+y[2]})
cMen +=' <tr>'
cMen += ' <td colspan=30 >SALDOS BANCARIOS </td></tr>' 
cMen +=' </tr>'

For i:=1 to Len(Banco)
	DataAtu:=Stod(Dini) 
	txMoeda=1
	DescM:="Real"
	cMen += ' <tr>'
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Banco[i]+'</Blink></font></td>'

	For M:=1 to 3
        DataAtu:=STod(Dini) 
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
	  		cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink></Blink></font></td>'

		Endif 
		cMen += ' <td align="center" width="01%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+DescM+'</Blink></font></td>'		
		For j:=1 to DifData
			PosM:=Ascan(Dados,{|x|Alltrim(x[1])==Alltrim(Banco[i]) .AND. x[2]==DTos(DataAtu)}) 
	    	If PosM<>0
				Saldo:=(DAdos[PosM][3]/txMoeda)//Valor dividido por 1 milhใo. 
				If M<>1
				Saldo:=Saldo/1000000 //Valor dividido por 1 milhใo. 
                EndIf 
				cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Transform(Saldo,"@E 999,999,999,999.99")+'</Blink></font></td>'		
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
Static Function MDadosTitulo(Titulos,Dinicial,Tp)
Local cMen:=""
If tp="P"
	DescT:="CARTEIRA A PAGAR "
	Desc:={"Titulos Pagos ","Titulos a Pagar ", "Titulos Vencidos " }
Else 
	DescT:="CARTEIRA A RECEBER"
	Desc:={"Titulos Recebidos ","Titulos a Receber ", "Titulos Vencidos " }
EndIF 
          
Saldo:=0


cMen +=' <tr>'
cMen += ' <td colspan=30 >'+DescT +'</td></tr>' 
cMen +=' </tr>'
/*
cMen+="<tr>"
if Tp="R"
	cMen += ' <td colspan=30 >Carteira a Receber </td></tr>' 
Else 
	cMen += ' <td colspan=30 >Carteira a Pagar </td></tr>' 
EndIF 	
cMen:="</tr>"
*/
For i:=1 to 3
	DataAtu:=Stod(Dinicial)
	cMen += ' <tr>'
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Desc[i]+'</Blink></font></td>'
	cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink> </Blink></font></td>'

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
            cMen += ' <td align="center" width="02%" bgcolor="#FFFFFF"><font size="2" face="Times New Roman"><Blink>'+Transform(Saldo,"@@E 999,999,999,999.99")+'</Blink></font></td>'		
		EndIf	
		DataAtu+=1
	Next 
    cMen+= '</tr>

Next 

Return cMen


			
/******************************************************************************************************/
