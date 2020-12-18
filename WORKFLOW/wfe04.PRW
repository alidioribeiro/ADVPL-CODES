#INCLUDE "rwmake.ch"
//#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFE04     �Autor  �Jefferson Moreira   � Data �  08/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esse programa tem como objetivo enviar e-mails para cada    ���
���          �responsavel dos Centros de Custo com os ausentes do mesmo   ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


***************************************
User Function WFE04
***************************************

pergunte("WFE004",.F.)
aFalt  := {}
//MV_PAR01 - Do turno ?


@ 96,  013 To 510,410 DIALOG oDlg TITLE "Envia lista de ausentes de cada respons�veis"
@ 18,  006 To 60, 187
@ 29,  015 SAY OemToAnsi("Este programa tem como objetivo enviar para os rensponsaveis,")
@ 39,  015 SAY OemToAnsi("de cada CC, um e-mail com os colaboradores ausentes.")  
@ 69,  015 SAY ("100 - COMERCIAL   ")
@ 79,  015 SAY ("101 - PRIMEIRO TURNO  ")  
@ 89,  015 SAY ("102 - SEGUNDO TURNO  ")
//@ 89,  015 SAY ("003 - TERCEIRO TURNO")
@ 99, 015 SAY ("103 - 1�TURNO ESPECIAL")
@ 109, 015 SAY ("104 - 2�TURNO ESPECIAL")
@ 119, 015 SAY ("105 - 3�TURNO ESPECIAL")
@ 129, 015 SAY ("106 - 1�TURNO APRENDIZ")
@ 139, 015 SAY ("107 - 2�TURNO APRENDIZ")
@ 149, 015 SAY ("109 - TURNO INTERMEDIARIO")
@ 159, 015 SAY ("110 - MOTOBOY")
@ 169, 015 SAY ("111 - ESTAGIARIO DO 1 TURNO")

//@ 129, 015 SAY ("007 - TERCEIRIZADOS ")
//@ 139, 015 SAY ("008 - ESTAGIARIOS")
//@ 149, 015 SAY ("010 - MOTOBOY")
//@ 159, 015 SAY ("011 - ESTAGIARIO 1 TURNO ESPECIAL")
@ 189, 150 BUTTON "Enviar"  SIZE 30,13 ACTION WFE40()
@ 189, 085 BMPBUTTON TYPE 5 ACTION Pergunte("WFE004")
@ 189, 015 BMPBUTTON TYPE 2 ACTION WFE41Fim()
ACTIVATE DIALOG oDlg
Return



***********************************
Static Function WFE40
***********************************

Close(oDlg)
PROCESSA ({|| WFE41()},"Enviando e-mail�s..." )

return

***********************************
Static Function WFE41
***********************************

aFunc  := {}
aPon   := {}
vFCC   := {}
vCCR   := {}
xFilter:= {}
aPre   := {}
cMen   := ""
Situ   := ""
Turno  := ""

//  aAdd(vCCR,{"112","Ronaldo/Eurico","01"}) // Secretaria
//  aAdd(vCCR,{"123","Ronaldo/Eurico","01"}) // Financeiro
//  aAdd(vCCR,{"124","Ronaldo/Eurico","01"}) // RH
aAdd(vCCR,{"122","Cintia"        ,"01"}) // Contabilidade
aAdd(vCCR,{"611","Julio"         ,"02"}) // Produ��o Geral
aAdd(vCCR,{"613","Joaquim"       ,"03"}) // Compras
aAdd(vCCR,{"615","Edy"           ,"04"}) // PCP
aAdd(vCCR,{"612","Edy"           ,"04"}) // Almoxarifado
aAdd(vCCR,{"618","Takafusa"      ,"05"}) // ImpEx
aAdd(vCCR,{"126","Jorge"         ,"06"}) // TI
aAdd(vCCR,{"211","Paulo"         ,"07"}) // Produ��o
aAdd(vCCR,{"221","Clavis"        ,"08"}) // Impress�o
aAdd(vCCR,{"231","Sergio"        ,"09"}) // Inj. Plastica
aAdd(vCCR,{"614","Jo�o Marques"  ,"10"}) // Manuten��o
aAdd(vCCR,{"621","Pacheco"       ,"11"}) // SGI
aAdd(vCCR,{"622","Pacheco"       ,"11"}) // CQ Rec
aAdd(vCCR,{"623","Pacheco"       ,"11"}) // CQ Exp
aAdd(vCCR,{"624","Pacheco"       ,"11"}) // CQ inj 
aAdd(vCCR,{"241","Silvio"        ,"12"}) // IA


xData := Subs(Dtos(dDataBase),7,2) + "/" + Subs(Dtos(dDataBase),5,2)+ "/" + Subs(Dtos(dDataBase),3,2)
yData := Dtos(dDataBase)

 
 cQuery := ""
 cQuery := " select RA_MAT,RA_NOME,RA_CC,RA_TNOTRAB,RA_SITFOLH,P8_DATA,R6_DESC"
 cQuery += " from DADOSAP10..SRA010"
 cQuery += " left join DADOSAP10..SP8010 on (P8_MAT = RA_MAT"
 cQuery += " AND P8_DATA = '"+ yData +"')"                  
 cQuery += " join DADOSAP10..SR6010 on (RA_TNOTRAB = R6_TURNO)" 
 cQuery += " WHERE RA_SITFOLH <> 'D'" 
 cQuery += " AND RA_MAT <> '000029'" 
 cQuery += " AND RA_MAT <> '000031'" 
 cQuery += " AND RA_MAT <> '001001'"
 cQuery += " AND RA_MAT <> '001002'"
 cQuery += " AND RA_MAT <> '000277'"
// cQuery += " AND D_E_L_E_T_ <> '*'"
 cQuery += " UNION"
 cQuery += " select RA_MAT,RA_NOME,RA_CC,RA_TNOTRAB,RA_SITFOLH,P8_DATA,R6_DESC"
 cQuery += " from DADOSAP10..SRA020"
 cQuery += " left join DADOSAP10..SP8020 on (P8_MAT = RA_MAT"
 cQuery += " AND P8_DATA = '"+ yData +"')"   
 cQuery += " join DADOSAP10..SR6020 on (RA_TNOTRAB = R6_TURNO)" 
 cQuery += " WHERE RA_SITFOLH <> 'D'"
// cQuery += " AND D_E_L_E_T_ <> '*'"
 cQuery += " ORDER BY RA_MAT"
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TRA New      // Tabela de Funcionario Temporarios
 
 DbSElectArea("TRA") 
 DbGotop() 
 While !TRA->(Eof())
 
    IF !EMPTY(mv_par01) .and. !(RA_TNOTRAB $ AllTrim(mv_par01))
	   TRA->(DBSKIP())
	   Loop
    End  
    
 
    IF EMPTY(P8_DATA) 
    turno :=    TRA->R6_DESC
    
		if RA_SITFOLH == "A"
			Situ := "Afastado"
		elseif TRA->RA_SITFOLH == "F"
			Situ := "Ferias"
		elseif TRA->RA_SITFOLH == "T"
			Situ := "Transferido"
		else
			Situ := "Ausente"
		endif
		    AAdd(aFalt,{RA_MAT,;    //[1]
		               RA_NOME,;    //[2]
		                 RA_CC,;    //[3]
		                  Situ,;    //[4]
	      	             turno})    //[5]    
    
    END
 
    TRA->(DBSKIP())
    
 ENDDO

 *********************************************************************************
 

PROCREGUA(RECCOUNT(Len(aFalt)))

IF Len(aFalt) > 0	
	vFCC:= FiltrarResp("01")
	sendMsg(.F.)
	vFCC:= FiltrarResp("02")
	sendMsg(.F.)
	vFCC:= FiltrarResp("03")
	sendMsg(.F.)
	vFCC:= FiltrarResp("04")
	sendMsg(.F.)
	vFCC:= FiltrarResp("05")
	sendMsg(.F.)
	vFCC:= FiltrarResp("06")
	sendMsg(.F.)
	vFCC:= FiltrarResp("07")
	sendMsg(.F.)
	vFCC:= FiltrarResp("08")
	sendMsg(.F.)
	vFCC:= FiltrarResp("09")
	sendMsg(.F.)
	vFCC:= FiltrarResp("10")
	sendMsg(.F.)
	vFCC:= FiltrarResp("11")
	sendMsg(.F.)
	vFCC:= FiltrarResp("12")
	sendMsg(.F.)
    asort(aFalt,,,{|x,y| x[05]+x[03] < y[05]+y[03]})
   	vFCC:=aFalt
   	sendMsg(.T.)
    dbCloseArea("TRA")
    MSGSTOP("E-mail�s enviados com sucesso!!!")	
ELSE	
	MSGSTOP("N�o h� Ausentes")	
ENDIF

dbSelectArea("TRA")
dbClearFil(NIL)
dbCloseArea("TRA")
dbCloseArea()

Return

************************************
Static Function FiltrarResp(nResp)
************************************
xFilter:={}

PROCREGUA(RECCOUNT(Len(aFalt)))

For i:=1 to Len(aFalt)
	INCPROC()
	fCCusto:= alltrim(aFalt[i][3])
	nPos := ASCAN(vCCR,{|x| x[1]==fCCusto})
	
	If nPos <> 0
		If vCCR[nPos][3] <> nResp
			Loop
		Else
			
			AAdd(xFilter,{aFalt[i][1],;    // [1] Matricula
			              aFalt[i][2],;    // [2] Nome
			              aFalt[i][3],;    // [3] CC
			              aFalt[i][4],;    // [4] Situa��o
			              aFalt[i][5],;    // [5] Turno de Trabalho
			                    nResp})    // [6] N�Responsavel
			
		Endif
	Else
		loop
	End
Next

Return xFilter

//*********************************
//* Fun��o para envio de messagens*
//*********************************
**********************************
Static Function sendMsg(gerencia)
**********************************
local x:= 0 
If Len(vFCC) > 0
	
	oProcess := TWFProcess():New( "000003", "AUSENCIAS" )
	oProcess :NewTask( "100002", "\WORKFLOW\ENVIA.HTM" )
	oProcess :cSubject := "WFE04 - AUSENCIAS"
	oHTML    := oProcess:oHTML
	
	
	cMen := " <html>"
	cMen := " <head>"
	cMen := " <title></title>"
	cMen := " </head>"
	cMen += " <body>"
	cMen += ' <table border="1" width="650">'
	cMen += ' <tr width="650" align="center" >'
	cMen += ' <td colspan=5 font size="1" >Colaboradores Ausentes em '+ xData +'</td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="8%" ><font size="1" face="Times">Matricula </td>'
	cMen += ' <td align="center" width="30%"><font size="1" face="Times">Nome      </td>'
	cMen += ' <td align="center" width="5%" ><font size="1" face="Times">CC        </td>'
	cMen += ' <td align="center" width="5%" ><font size="1" face="Times">Status    </td>'
	cMen += ' <td align="center" width="22%"><font size="1" face="Times">Turno     </td>'
	cMen += ' </tr>'
	For x:= 1 to Len(vFCC)
		cMen += ' <tr>'
		cMen += ' <td align="center" width="08%"><font size="1" face="Times">' + vFCC[x][1] +'</td>'
		cMen += ' <td align="left  " width="30%"><font size="1" face="Times">' + vFCC[x][2] +'</td>'
		cMen += ' <td align="center" width="05%"><font size="1" face="Times">' + vFCC[x][3] +'</td>'
		cMen += ' <td align="center" width="05%"><font size="1" face="Times">' + vFCC[x][4] +'</td>'
		cMen += ' <td align="center" width="05%"><font size="1" face="Times">' + vFCC[x][5] +'</td>'
		cMen += ' </tr>'
		
	Next
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>" 
	
	if gerencia         // Gerencial
	
		oHtml:ValByName("MENS", cMen)
	 	oProcess:cTo  := "ronaldob@nippon-seikibr.com.br;eurico@nippon-seikibr.com.br;elismar@nippon-seikibr.com.br;rtanaka@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
	
	else
	IF Alltrim(vFCC[1][6]) == "01"      // Contabilidade
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "eliel.andrade@nippon-seikibr.com.br"
		cMailId := oProcess:Start()		
		
	ElseIF Alltrim(vFCC[1][6]) == "02"  // Novos Projetos / Engenharia
		
		oHtml:ValByName("MENS", cMen)
	 	oProcess:cTo  := "silvio@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "03"  // Compras Nacional
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "sheilabezerra@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "04"  // PCP / Materiais
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "edyikeoka@nippon-seikibr.com.br"
		oProcess:cCC  := "paulo@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "05"  // Compras Internacionais
		
		oHtml:ValByName("MENS", cMen)
  		oProcess:cTo  := "tiagomunden@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "06"  // Tecnologia da Informa��o
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "jorge@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "07"  // Produ��o
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "allan@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "08"  // Impress�o
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "jackson@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "09"  // Inj. Plastica
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "simoney@nippon-seikibr.com.br;wpacheco@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "10"  // Manuten��o
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "haroldolima@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
		
	ElseIF Alltrim(vFCC[1][6]) == "11"  // Controle de Qualidade
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "darlan.alves@nippon-seikibr.com.br"
		cMailId := oProcess:Start()
	
	ElseIF Alltrim(vFCC[1][6]) == "12"  // IA
		
		oHtml:ValByName("MENS", cMen)
		oProcess:cTo  := "edsonsato@nippon-seikibr.com.br"
		cMailId := oProcess:Start()	
		
	EndIf
	end
EndIf

Return


**********************************
Static Function WFE41Fim()
**********************************
Close(oDlg)

Return               

