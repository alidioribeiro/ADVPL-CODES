#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/02/02
#Include "TOPCONN.CH" 


User Function ConfirmaCpo(_cCampo)
Local lRet      := .T.
Local cAlias    := Select()
Local nX3Ordem  := 0

Private lRestricao := .T.
Private lPermissao := .T.
//
If Len(_cCampo) < 10
 _cCampo := PadR(_cCampo,10)
Endif
//
dbSelectArea("SX3")
nX3Ordem := dbsetorder()
dbSetOrder(2)
dbSeek(_cCampo)
//
Permissao(_cCampo)
//
//If (!lRestricao .and. lPermissao) .or. (lRestricao .and. !lPermissao)
//   Return(.T.)
//Endif
//                 
dbSelectArea("SX3")
dbSetOrder(nX3Ordem)
dbSelectarea(cAlias)
Return(lRet)
//
//
Static Function Permissao(_cCampo)
Local lRet  := .T.
Local cArea :=  Select()
//
lRestricao := .F.
lPermissao := .T.
//
dbSelectArea("SZZ")
dbsetorder(1)
If dbSeek(xFilial("SZZ")+ _cCampo)
    //
    lRestricao := .T.
	If dbSeek(xFilial("SZZ")+ _cCampo+ __cUserID)     
		If INCLUI 
			If !SZZ->ZZ_INCLUI    
				If &("M->"+_cCampo) <> &("SRA->"+_cCampo)	
					msgstop("Usuario: "+AllTrim(cUserName)+" não esta autorizado a incluir conteudo neste campo!","Atenção")	
					If     SX3->X3_TIPO == "C" ; &("M->"+_cCampo) := Space(SX3->X3_TAMANHO)
					ElseIf SX3->X3_TIPO == "N" ; &("M->"+_cCampo) := 0
					ElseIf SX3->X3_TIPO == "D" ; &("M->"+_cCampo) := CTOD("  /  /  ")
					Endif				  
				    lPermissao := .F.     
				Endif
			Else
		      Edicao(_cCampo)				    
			Endif	
			
		ElseIf ALTERA 
			If !SZZ->ZZ_ALTERA          
				If &("M->"+_cCampo) <> &("SRA->"+_cCampo)
					msgstop("Usuario: "+AllTrim(cUserName)+" não esta autorizado a alterar conteudo neste campo!","Atenção")
					&("M->"+_cCampo) := &("SRA->"+_cCampo)
				    lPermissao := .F.
				Endif
			Else
			  Edicao(_cCampo)				    				
			Endif
		Endif
	Else
		If INCLUI 
			If &("M->"+_cCampo) <> &("SRA->"+_cCampo)	
				msgstop("Usuario: "+AllTrim(cUserName)+" não esta autorizado a incluir conteudo neste campo!","Atenção")	
				If     SX3->X3_TIPO == "C" ; &("M->"+_cCampo) := Space(SX3->X3_TAMANHO)
				ElseIf SX3->X3_TIPO == "N" ; &("M->"+_cCampo) := 0
				ElseIf SX3->X3_TIPO == "D" ; &("M->"+_cCampo) := CTOD("  /  /  ")
				Endif				  
			Endif
			
		ElseIf ALTERA 
			If &("M->"+_cCampo) <> &("SRA->"+_cCampo)
				msgstop("Usuario: "+AllTrim(cUserName)+" não esta autorizado a alterar conteudo neste campo!","Atenção")
				&("M->"+_cCampo) := &("SRA->"+_cCampo)			
			Endif
			
		Endif	
		
	    lPermissao := .F.
	Endif
Endif
//          
dbSelectarea(cArea)
Return(lRet)
//
//
//
Static Function Edicao(_cCampo)
Local cTitulo   := "Titulo"
Local xConteudo := Space(10)
Local cPicture  := "@!"  
Local lRet      := .T.

dbSelectArea("SX3")
cTitulo := X3_TITULO
//
If X3_TIPO == "C"
   xConteudo := Space(X3_TAMANHO)
   xPicture  := X3_PICTURE

ElseIf X3_TIPO == "N"
   xConteudo := 0
   xPicture  := X3_PICTURE

ElseIf X3_TIPO == "D"
   xConteudo := CTOD("  /  /  ")
   xPicture  := X3_PICTURE
   
Endif
//
cTitulo := Alltrim(cTitulo)+": "
//
@ 96,42  TO 323,505 DIALOG oDlg5 TITLE "Confirmação de dados"
@ 08,10  TO 84,222
@ 30,20  SAY cTitulo
@ 30,20 + (Len(cTitulo)*3) Get xConteudo PICTURE xPicture SIZE (X3_TAMANHO*3),9
@ 91,168 BMPBUTTON TYPE 1 ACTION Close(oDlg5)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
ACTIVATE DIALOG oDlg5 CENTERED
//
If xConteudo <> &("M->"+_cCampo)
 	msgStop("O conteudo dos campos não confere!","Atenção")	 	
  	If INCLUI 
		If X3_TIPO     == "C" ;	&("M->"+_cCampo) := Space(X3_TAMANHO)
		ElseIf X3_TIPO == "N" ; &("M->"+_cCampo) := 0
		ElseIf X3_TIPO == "D" ; &("M->"+_cCampo) := CTOD("  /  /  ")
		Endif
		
	ElseIf ALTERA
   	  &("M->"+_cCampo) := &("SRA->"+_cCampo)   	  
   	  
	Endif	

	lRet := .F.
Endif
//
Return(lRet)


