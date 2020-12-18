#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  WFE11      บAutor  ณJefferson Moreira   บ Data ณ  01/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEsse programa tem como objetivo enviar e-mails com a relacaoบฑฑ
ฑฑบ          ณdas Ordens de producao Abertas.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


***************************************
User Function WFE11
***************************************

pergunte("WFE011",.F.)
aFalt  := {}
//MV_PAR01 - Da Data  ?
//MV_PAR02 - Ate a Data  ?
//MV_PAR03 - Da OP ?
//MV_PAR04 - Ate a OP  ?


@ 96, 013 To 310,410 DIALOG oDlg TITLE "Ordens de Produ็ใo Abertas"
@ 18, 006 To 60, 187
@ 29, 015 SAY OemToAnsi("Este programa tem como objetivo enviar para o almoxarifado,")
@ 39, 015 SAY OemToAnsi("a Rela็ใo das Op disponiveis para Movimenta็ใo.")  
@ 89, 150 BUTTON "Enviar"  SIZE 30,13 ACTION WFE110()
@ 89, 085 BMPBUTTON TYPE 5 ACTION Pergunte("WFE011")
@ 89, 015 BMPBUTTON TYPE 2 ACTION WFE41Fim()
ACTIVATE DIALOG oDlg
Return



***********************************
Static Function WFE110
***********************************

Close(oDlg)
PROCESSA ({|| WFE111()},"Enviando e-mailดs..." )

return

***********************************
Static Function WFE111
***********************************

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de  Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/
aROP   := {}
xFilter:= {}
cMen   := ""


yData := Subs(Dtos(mv_par01),7,2) + "/" + Subs(Dtos(mv_par01),5,2)+ "/" + Subs(Dtos(mv_par01),3,2)  // Entrada
//AND P8_DATA = '"+ yData +"')"
 
 cQuery := " Select (C2_NUM+C2_ITEM+C2_SEQUEN) as C2_OP,C2_PRODUTO,B1_DESC,C2_QUANT,C2_DATPRI,C2_RECURSO,C2_TURNO,C2_CC,C2_OBS "
 cQuery += " From "+RetSQLName("SC2")+" SC2 "
 cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON C2_PRODUTO = B1_COD "
 cQuery += " WHERE "
 cQuery += " SC2.D_E_L_E_T_ <> '*' "
 cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
 cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN >= '"+MV_PAR03 + "'"
 cQuery += " AND C2_NUM+C2_ITEM+C2_SEQUEN <= '"+MV_PAR04 + "'"
 cQuery += " AND C2_DATPRI >= '"+DTOS(MV_PAR01)+"'"
 cQuery += " AND C2_DATPRI <= '"+DTOS(MV_PAR02)+"'"
 cQuery += " AND C2_RECURSO >= '"+MV_PAR05+"'"
 cQuery += " AND C2_RECURSO <= '"+MV_PAR06+"'"
 cQuery += " AND C2_CC >= '"+MV_PAR07+"'"
 cQuery += " AND C2_CC <= '"+MV_PAR08+"'"  
 cQuery += " AND C2_FILIAL=B1_FILIAL "
 Cquery += " AND C2_FILIAL='"+xFilial("SC2")+"'"

 cQuery += " ORDER BY C2_NUM "
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TRA New      // 
 
 DbSElectArea("TRA") 
 DbGotop()
 ProcRegua(RecCount()) 
                                       
 While !TRA->(Eof())
  IncProc()
     AAdd(aROP,{C2_OP,;    //[1]
	       C2_PRODUTO,;    //[2]
	          B1_DESC,;    //[3]
	         C2_QUANT,;    //[4]
	        C2_DATPRI,;    //[5]
	       C2_RECURSO,;    //[6]
	         C2_TURNO,;    //[7] 
	            C2_CC,;
	            C2_OBS})    //[8]
	 TRA->(DBSKIP())          
 Enddo 
 

 dbClearFil(NIL)
 dbCloseArea("TRA")
 dbCloseArea()
 aDados:={}
 CodRot:="WFE11"
 GrpEmail:=""
 IF Len(aROP) > 0
    OpCC := aROP
    aDados:= u_MRecECC(CodRot) /*Retorna todos os e-mail's cadastrados*/
 
    For j:=1 to len (aDados)
		 if  aDados[j][1]>=mv_par07 .and. aDados[j][1]<=mv_par08
	          
    	      If  aDados[j][1]= "221"          //Impressao
				    OpCC := FiltraOp("221,211,251")  //Recebe as op aberta dela mesma e da produ็ใo                                 
				    MensCC:=" - Centros de Custos 221-211-251 "
			  Elseif aDados[j][1]= "231"    	//Injecao
				    OpCC := FiltraOp("221,211,231,251")  //Recebe as op dela mesma, da produ็ใo e da impressใo                                 
                    MensCC := " - Centros de Custos 231-211-221-251 " 
			  Elseif !Empty(aDados[j][1]) 	    
 		 	 	  	 OpCC  := FiltraOp(aDados[j][1])                    
		   	  	     DescCC:=posicione("CTT",1,xfilial("CTT")+aDados[j][1],"CTT_DESC01")
					 MensCC:=" - "+ aDados[j][1]+" "+DescCC             		 		 	 	  	 
			  Else
  			  		MensCC:=" - Todos os Centro de Custo "		  
			  Endif          
//		      Email:=aDados[j][2]
              sendMail(aDados[j][2],MensCC )
		Endif           
   Next  
    MSGSTOP("E-mailดs enviados com sucesso!!!")	
 Else 
    MsgAlert("Nใo hแ dados a enviar! Verifique os parametros.","Atencao!")
 endif
 Return 
*********************************************************************************
 

************************************
Static Function FiltraOp(CC)
************************************
xFilter:={}

For i:=1 to Len(aROP)

	If alltrim(aROP[i][8]) $ CC //.or. aROP[i][8] == _CC
				
	   AAdd(xFilter,{aROP[i][1],;    // [1] Op
	                 aROP[i][2],;    // [2] Produto
	                 aROP[i][3],;    // [3] Descricao
                     aROP[i][4],;    // [4] Quantidade
	                 aROP[i][5],;    // [5] Data de Inicio
	                 aROP[i][6],;    // [6] Recurso
	                 aROP[i][7],;    // [7] Turno
	                 aROP[i][8],;
	                 aROP[i][9]})    // [8] CC
			
	Endif

Next

Return xFilter


//*********************************
//* Fun็ใo para envio de messagens*
//*********************************

**********************************
//Static Function sendMail(setor) Fonte original
Static Function sendMail(GrpEmail,CCusto)
**********************************

If Len(OpCC) > 0
	
	oProcess := TWFProcess():New( "000003", "Rela็ใo das OPs" )
	oProcess :NewTask( "100002", "\WORKFLOW\RELACAOOP.HTM" )
	oProcess :cSubject := "WFE11 - Rela็ใo das Ordens de Produ็ใo "+CCusto
	oHTML    := oProcess:oHTML
		
	cMen := " <html>"
	cMen := " <head>"
	cMen := " <title></title>"
	cMen := " </head>"
	cMen += " <body>"
	cMen += ' <table border="1" width="700">'
	cMen += ' <tr width="700" align="center" >'
	cMen += ' <td colspan=9 font size="1" > Rela็ใo das Ordens de Produ็ใo </td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="10%"><font size="1" face="Times">Nบ OP      </td>'
	cMen += ' <td align="center" width="10%"><font size="1" face="Times">Produto    </td>'
	cMen += ' <td align="center" width="40%"><font size="1" face="Times">Descri็ใo  </td>'
	cMen += ' <td align="center" width="10%"><font size="1" face="Times">Quantidade </td>'
	cMen += ' <td align="center" width="03%"><font size="1" face="Times">Data Inicio</td>'
	cMen += ' <td align="center" width="03%"><font size="1" face="Times">Recurso    </td>'
	cMen += ' <td align="center" width="03%"><font size="1" face="Times">Turno      </td>'
	cMen += ' <td align="center" width="03%"><font size="1" face="Times">CC         </td>'
	cMen += ' <td align="center" width="03%"><font size="1" face="Times">Obs        </td>'
	cMen += ' </tr>'

	For x:= 1 to Len(OpCC)
	    xQuant := Transform (OpCC[x][4], "@E 999,999")//Transform(OpCC[x][4],"@E 999.999")
 //	    xData  := Subs(OpCC[x][5],7,2) + "/" + Subs(OpCC[x][5],5,2)+ "/" + Subs(OpCC[x][5],3,2)
   	    xData  := Dtoc(Stod(OpCC[x][5])) 
		cMen += ' <tr>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' + OpCC[x][1] +'</td>'
		cMen += ' <td align="left  " width="10%"><font size="1" face="Times">' + OpCC[x][2] +'</td>'
		cMen += ' <td align="center" width="40%"><font size="1" face="Times">' + OpCC[x][3] +'</td>'
		cMen += ' <td align="center" width="10%"><font size="1" face="Times">' +  xQuant    +'</td>'
		cMen += ' <td align="center" width="03%"><font size="1" face="Times">' +  xData     +'</td>'
		cMen += ' <td align="center" width="03%"><font size="1" face="Times">' + OpCC[x][6] +'</td>'
		cMen += ' <td align="center" width="03%"><font size="1" face="Times">' + OpCC[x][7] +'</td>'
		cMen += ' <td align="center" width="03%"><font size="1" face="Times">' + OpCC[x][8] +'</td>'
		cMen += ' <td align="center" width="40%"><font size="1" face="Times">' + OpCC[x][9] +'</td>'
		cMen += ' </tr>'
		
	Next   

	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>" 
	
    oHtml:ValByName("MENS", cMen)
    oProcess:cTo:= GrpEmail
    cMailId := oProcess:Start()
EndIf

Return


**********************************
Static Function WFE41Fim()
**********************************
Close(oDlg)

Return               

