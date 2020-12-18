/*
  PE - Filtro do Browse antes de entrar na solicitacao de compras
*/
User Function MT110FIL()
Local cFiltro := ''
Local lPermissao := .F.
Local cAlias := Alias()
Local cMatUsr:= ""
Local cCC    := ""

aInfoUser := PswRet()
cMatUsr   := Substring(aInfoUser[1,22],5,6) 
cSolic    := __cUserId


dbselectarea("SRA")
SRA->(dbsetorder(1))
If SRA->(dbSeek(xFilial("SRA")+ cMatUsr))
   cCC       := Alltrim(SRA->RA_CC)
Endif
//cFiltro :=  ' .NOT. "MPR"$C1_ORIGEM '  05/05/2016 Nilton
//If cCC <> "613" // Centro de Custo do Compras
If cCC <> "618" .and. cCC <> "126" // Centro de Custo Cadeia de Suprimentos - 05/05/2016 Nilton  
   cFiltro +=  ' .AND. C1_CC = "' + cCC +'" '
Endif   
dbselectArea(cAlias)
Return (cFiltro) 
