#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFE12     ºAutor  ³Jefferson Moreira   º Data ³  12/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esse programa tem como objetivo envia um e-mail para o setorº±±
±±º          ³manutencao com as horas paradas por motivo "29"(Man.de Maq.)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8.11                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


***************************************
User Function WFE12(aImp)
***************************************

If Len(aImp) > 0
	
	oProcess := TWFProcess():New( "000003", "Manutencao de Maquinas" )
	oProcess :NewTask( "100002", "\WORKFLOW\MANU.HTM" )
	oProcess :cSubject := "WFE12 - Horas Paradas"
	oHTML    := oProcess:oHTML
		
	cMen := " <html>"
	cMen := " <head>"
	cMen := " <title></title>"
	cMen := " </head>"
	cMen += " <body>"
	cMen += ' <table border="1" width="800">'
	cMen += ' <tr width="800" align="center" >'
	cMen += ' <td colspan=09 font size="1" > Horas Paradas </td></tr>'

	For x:= 1 to Len(aImp)
	    
   	    //xData := Subs(OpCC[x][5],7,2) + "/" + Subs(OpCC[x][5],5,2)+ "/" + Subs(OpCC[x][5],3,2)
		xDataEmi := Subs(Dtos(aImp[x][01]),7,2) + "/" + Subs(Dtos(aImp[x][01]),5,2)+ "/" + Subs(Dtos(aImp[x][01]),3,2)
		xDataIni := Subs(Dtos(aImp[x][11]),7,2) + "/" + Subs(Dtos(aImp[x][11]),5,2)+ "/" + Subs(Dtos(aImp[x][11]),3,2)
		xDataFim := Subs(Dtos(aImp[x][13]),7,2) + "/" + Subs(Dtos(aImp[x][13]),5,2)+ "/" + Subs(Dtos(aImp[x][13]),3,2)
		xHoraIni := Transform(aImp[x][12],"@R !!:!!")
		xHoraFim := Transform(aImp[x][14],"@R !!:!!")
		xHoraPar := Transform(aImp[x][15],"@R !!:!!")
		If x==1 
		
		
		cMen += '<td colspan=09 font size="0" >Emissão: '+xDataEmi+" Doc: "+aImp[x][02]+"OP: "+aImp[x][05]+" Recurso: "+aImp[x][06]+" Turno: "+aImp[x][07]+'</td></tr>'
		cMen += '<td colspan=09 font size="0" >Cod: '+aImp[x][03]+" Desc: "+aImp[x][04]+'</td></tr>'
		
		cMen += ' <tr >'
	    cMen += ' <td align="center" width="03%"><font size="1" face="Times">Cod.Motivo </td>'
	    cMen += ' <td align="center" width="25%"><font size="1" face="Times">Desc.Motivo</td>'
	    cMen += ' <td align="center" width="30%"><font size="1" face="Times">Obs        </td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Dt Inicial </td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Hr Inicial </td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Dt Final   </td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Hr Final   </td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">Parada(min)</td>'
	    cMen += ' <td align="center" width="10%"><font size="1" face="Times">CC Aplic   </td>'
	    cMen += ' </tr>'
		
		Endif
		
		cMen += ' <tr>'
		cMen += ' <td align="center" width="03%"><font size="1" face="Times">' + aImp[x][08] +'</td>'
		cMen += ' <td align="center" width="25%"><font size="1" face="Times">' + aImp[x][09] +'</td>'
		cMen += ' <td align="center" width="30%"><font size="1" face="Times">' + aImp[x][10] +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + xDataIni    +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + xHoraIni    +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + xDataFim    +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + xHoraFim    +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + xHoraPar    +'</td>' 
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + aImp[x][16] +'</td>'
		cMen += ' </tr>'
		
	Next   

	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>" 
	
    oHtml:ValByName("MENS", cMen)
	CodRot:="WFE12"
	Mto:= u_MontaRec(CodRot)
 	oProcess:cTo  :=Mto
	cMailId := oProcess:Start()

    
   
EndIf

Return