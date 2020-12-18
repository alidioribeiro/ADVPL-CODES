#Include "Rwmake.ch" 
#Include "TOPCONN.ch"

User Function SELECHA() 

anRadion :={0,0,0}
nOpcao   := ""
aResp:={"SSI   - Solicita��o de Servi�o de Inform�tica",;
        "SSM - Solicita��o de Servi�o de Manuten��o ",;
        "SSQ - Solicita��o de Servi�o de Qualidade  "}  

main()
Return


**********************************                                                       				
Static Function main()
**********************************    
//Local oDlg, oSay, oFontD:= TFont():New("Time New Roman",,-12,.T.,.T.)
Local oDlg, oSay, oFontD:= TFont():New("Arial",,-12,.T.,.T.)
Local oDlg, oSay, oFont := TFont():New("Time New Roman",,-15,.T.,.T.)
@ 96,20 To 700,1027 DIALOG oDlg TITLE "BEM VINDO AO PORTAL DE SOLICITA��O DE SERVI�OS DA NIPPON SEIKI DO BRASIL"  

@ 06,2  To 275, 505  
//@ 36,6  To 245, 500 

oSay:= tSay():New(45,45,{||"BUSCANDO MELHORAR O PROCESSO DE ABERTURA DE SOLI�ITA��ES DE SERVI�OS, "},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(55,45,{||"O TI NSB DESENVOLVEU UMA ROTINA DE GERENCIAMENTO DE SOLICITA��ES."},; 
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(75,45,{||"ESSA ROTINA TRAZ MAIS FACILIDADE, FLEXIBILIDADE E RAPIDEZ NA HORA "},; 
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(85,45,{||"DE SOLICITAR UM SERVI�O AL�M DE GERENCIAR AS SOLICITA��ES COM "},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(95,45,{||"CONSULTAS, HISTORICOS E RELATORIOS."},;
oDlg,,oFont,,,,.T.,,,500,30) 


//oSay:= tSay():New(150,45,{||"ESTA PESQUISA COMPREENDE 4 ETAPAS CONCLUINDO UMA DE CADA VEZ"},; 
//oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(170,45,{||" Na pr�xima tela dever� escolher as op��es abaixo: "},;
oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(180,45,{||":. SSI   - Solicita��o de Servi�o de Inform�tica "},;
oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(190,45,{||":. SSM - Solicita��o de Servi�o de Manuten��o "},;
oDlg,,oFont,,,,.T.,,,500,30)               
oSay:= tSay():New(200,45,{||":. SSQ - Solicita��o de Servi�o de Qualidade "},;
oDlg,,oFont,,,,.T.,,,500,30)              


oSay:= tSay():New(230,390,{||":. Desenvolvido por: Jefferson Moreira"},;
oDlg,,oFontD,,,,.T.,,,500,30)
oSay:= tSay():New(238,390,{||":. aishii@nippon-seikibr.com.br"},;
oDlg,,oFontD,,,,.T.,,,500,30)
oSay:= tSay():New(246,390,{||":. TI - Tecnologia da Informa��o"},;
oDlg,,oFontD,,,,.T.,,,500,30)

 
@ 275,2  To 300, 505
//@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("LP8841")
@ 280, 450 BUTTON "Escolher >" SIZE 34, 15 ACTION (fFim(oDlg),selecha1()) 
          
ACTIVATE DIALOG oDlg
return


**********************************
Static Function selecha1()        	
**********************************
@ 96,20 To 700,1027 DIALOG oDlg01A TITLE "SELE��O DO SERVI�O"

@ 06,2  To 275, 505
@ 120,200    SAY   "Qual o servi�o a ser solicitado ?"
//@ 165,500    SAY   "  "  
@ 135,200    RADIO aResp VAR anRadion[1] 

@ 275,2  To 300, 505
@ 280, 450 BUTTON "->Solicitar<-"  SIZE 34, 15 ACTION iif (Valida(),(fFim(oDlg01A),iif (nOpcao==1,U_CHAMUS(),MSG())),)
ACTIVATE DIALOG oDlg01A
Return 

Return


**********************************
Static Function fFim(oDlgx)
**********************************
Close(oDlgx)
Return  

**********************************
Static Function Valida
**********************************
Ret := .f.

For x:= 1 to 3
   if anRadion[x]<> 0
      Ret := .t.
      nOpcao := anRadion[x]
   endif
Next
if !Ret
    MSGSTOP("Voc� n�o escolheu a op��o!")
Endif
      
Return Ret 

**********************************
Static Function MSG
**********************************
Alert("Em desenvolvimento!!!")
Return  
