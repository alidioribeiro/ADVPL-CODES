User Function MT110VLD()
Local ExpN1    := Paramixb[1] // 3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusão.
Local ExpL1    := .T.   //Validações do ClienteReturn ExpL1
Local cAlias   := Alias()
Local cCodUsr  := __cUserId
Local cCC    := ""
//-------------   
aInfoUser := PswRet()
cMatUsr   := Substring(aInfoUser[1,22],5,6) 
dbselectarea("SRA")
SRA->(dbsetorder(1))
If SRA->(dbSeek(xFilial("SRA")+ cMatUsr))
   cCC       := Alltrim(SRA->RA_CC)
Endif
//-------------
DbSElectArea("SC1")                                                      
If (ExpN1 == 4 .OR. ExpN1 == 6) .AND. C1_APROV <> 'B'
   Alert("O STATUS atual da solicitação nao permite esta operação!")   
   ExpL1 := .F.   
Endif
If (ExpN1 == 4 .OR. ExpN1 == 6) .AND. C1_APROV == 'B' 
   If (cCodUsr <> C1_CODAPRV .AND. C1_USER <> cCodUsr ) .OR. cCC<>'613' // Setor de Compras
      Alert("Operação Inválida, você não tem pemissão!")   
      ExpL1 := .F.
   Endif   
Endif   

DbSElectArea(cAlias)                                                      
Return (ExpL1) 
