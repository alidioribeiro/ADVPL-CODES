#include "totvs.ch"
#include "protheus.ch"

User Function ImpPlano()
 
   Local cLinha  := ""
   Local lPrim   := .T.
   Local aCampos := {}
   Local aDados  := {}
   Local lEntrou :=.F. 
   Local Adver   :={}                             

   Local oDLG                                
   Local nLinha //Chave usada na WKERRO, usado para identificar qual item da MsSelect pertence o erro
   Local lIntegra := .F.  
   Local bOk := {|| lIntegra := .T.,oDlg:End()}
   Local bCancel := {|| oDlg:End()}
   Local lOk := .F.                                                                                                                             
   Local cFileWork //Armazena o arquivo da WKDADOSXLS      
   Local cFileErro //Armazena o arquivo da WKERRO
   Local aButtons := {{"DBG09",{||Legenda("ITENS")},"Botão Legenda na EnChoice - 'Legenda'","Botão Legenda na EnChoice - 'Legenda'"}} 
   Local i

   Private cOriDBF := "" //Armazena a origem do DBF temporário
   Private cDestDBF := ""//Armazena a origem do DBF temporário
  
   //Variáveis usadas para a integração com o EXCEL
   Private cOrigPath := GetTempPath()+space(150-Len(GetTempPath())) //tamanho total 150 caracteres - caminho de onde se encontra o arquivo       
   Private cFile //Nome do XLS que será importado  
   Private cDBF       := "" //Nome do arquivo DBF gerado, devido a restrição do DBF, o tamanho máximo é de 8 caracteres
   Private cNumFields := "" //Informa para a planilha do EXCEL, quais campos são numéricos          
   Private aErro := {}             
   Private m_pag      := 01
  
   if !showDLGImp()
       Return
   EndIF

 
If !File(cOrigPath+cFile)
	MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
	Return
EndIf
 
FT_FUSE(cOrigPath+cFile)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Elseif Alltrim(cLinha)<>";;;;"
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 
Begin Transaction
	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)
//        ChaveSHC:=xFilial("SHC")+aDados[i][1]+aDados[i][2]+aDados[i][4]+aDados[i][5]                                   
		DataPln:=Dtos(ctod(adados[i][1]))
        CodProd:=ForTexto(Alltrim(aDados[i][2]),15) 
        NumPln:=ForTexto(Alltrim(aDados[i][4]),2)
        Rev:=ForTexto(Alltrim(aDados[i][5]),3)
		ChaveSHC:=xFilial("SHC")+DataPln+CodProd+NumPln+Rev
        SHC->(DbOrderNickName("HCDATAPROD"))
	    if DbSeek(ChaveSHC) .and. !Empty(aDados[i][1])
			AADD(Adver,{"Esse produto já está cadastrado no plano",aDados[i][1],aDados[i][2],adados[i][3]})
	    Else   
	        //Verifica se o produto é valido//
	        DbSelectArea("SB1")
	        DbSetOrder(1)
			if  DbSeek(xFilial("SB1")+aDados[I][2])
				RecLock("SHC",.T.)
				SHC->HC_FILIAL:=xFilial("SHC")
				SHC->HC_PRODUTO:=Alltrim(adados[i][2])
				SHC->HC_DATA:=ctod(adados[i][1])
				SHC->HC_QUANT:=Val(adados[i][3])
				SHC->HC_DTVIGEN:=dDatabase
				SHC->HC_PERIODO:="M"
				SHC->HC_NUMPLAN:=Alltrim(adados[i][4])
				SHC->HC_REVISAO:=Alltrim(adados[i][5])
				msunlock()
		    Else                                                          
		       /*
		          @nLin,00 PSAY Adver[i][1] //Erro
   			      @nLin,40 PSAY Adver[i][3] //Produto
				   @nLin,60 PSAY Adver[i][2] //Data
		       */
    			AADD(Adver,{"Esse produto não está foi cadastrado",aDados[i][1],aDados[i][2],adados[i][3]})
			Endif 	
		Endif	
	Next i
End Transaction
if Len(Adver) > 0
   RelatoDiv(Adver)

EndIF
FT_FUSE()
 
ApMsgInfo("Importação do Plano concluída com sucesso!","[PLANO DE PRODUCAO] - SUCESSO")
 
Return

/*****************************************************************************************/
Static Function ForTexto(VarTexto,Tam)
//Local VarTexto:=""
   VarTexto:=VarTexto+Space(Tam-Len(VarTexto))	
Return VarTexto
/*****************************************************************************************/
Static Function showDLGImp()
   Local nCol   := 10
   Local nLinha := 10                                   
   Local oDlg                          
   Local lRet := .F.
   Local bOk := {|| lRet := .T.,oDlg:End()}    
                                                          
   DEFINE MSDIALOG oDlg TITLE "Importação de Dados" From 0,0 to 150,500 PIXEL 
      @ nLinha, nCol Say "Caminho do CSV" of oDlg Pixel 
      nLinha += 10
      @ nLinha, nCol MsGet cOrigPath  Size 200,10 Valid() of oDlg Pixel                                                                                     
      nLinha += 20                                                                                                                        
      @ nLinha, nCol+123 Button "OK" Size 50,15 Action(if(valFile(),eval(bOk),)) of oDlg Pixel 
      @ nLinha, nCol+178 Button "Cancelar" Size 50,15 Action(lRet := .F., oDlg:End()) of oDlg Pixel 

      Define SBUTTON From 20, 212 Type 14 Action(selXLS()) enable of oDlg Pixel     
      
   ACTIVATE MSDIALOG oDlg Centered
    
return lRet

/*------------------------------------------------------------------------------------
Funcao      : selXLS
Parametros  : 
Retorno     : 
Objetivos   : Apresentar Dialog para o usuário selecionar o arquivo XLS
Autor       : Anderson Soares Toledo
Data/Hora   : 
Revisao     :
Obs.        :
*------------------------------------------------------------------------------------*/
Static Function selXLS()
   Local cTitle:= "Selecione o processo"
   Local cMask := "Arquivo CSV|*.CSV" 
   Local nDefaultMask //:= 0
   Local cDefaultDir  := GetTempPath()
   Local nOptions:= GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE
   Local cOrig                   
                  
   cOrig := cGetFile(cMask,cTitle,nDefaultMask,cDefaultDir,,nOptions)

   If Empty(cOrig)
      Return cOrigPath
   Else
      cOrigPath := cOrig + space(len(cOrigPath) - len(cOrig)) // mantem o tamanho da msGet de 150 caracteres 
   EndIf
Return 

/*------------------------------------------------------------------------------------
Funcao      : valFile
Parametros  : 
Retorno     : Valor lógico informando se o arquivo é válido
Objetivos   : Válidar se o arquivo selecionado é válido
Autor       : Anderson Soares Toledo
Data/Hora   : 
Revisao     :
Obs.        :
*------------------------------------------------------------------------------------*/
Static Function valFile()
   Local lRet := .F.           
   Local aDir
   
   //Obtem informações do arquivo
   aDir := Directory(cOrigPath)
   
   If len(aDir) > 0
      //Armazena o nome
      cFile := aDir[1][1]
      //Verifica a extensão do arquivo
      If subStr(cFile,AT(".",cFile),len(cFile)) <> ".CSV"
         Alert("Extensão do arquivo inválida.") 
         Return lRet
      EndIf
      //Armazena o caminho
      cOrigPath := subStr(cOrigPath,1,RAT("\",cOrigPath))   
      //Armazena o nome do arquivo sem a extensão
      cDBF := subStr(cFile,1,AT(".",cFile)-1)
      lRet := .T.
   Else
      Alert("Arquivo não encontrado!") 
   EndIf

Return lRet

/******************************************************************************************/
Static Function RelatoDiv(Adver)           
Local Titulo:="Log de Erro na Importação CSV "
Local Cabec1:=" Erro                          Produto                        Data        Qtd"
Local Cabec2:=""
Local NomeProg:="ImpPln"    
Local nLin:=80                 
Local nOrdem:=0          
Local CDesc1 :="Divergencia de Importacao do Plano"
Local CDesc2 :=""
Local CDesc3 :=""
Local aOrd := {}
Private tamanho          := "P"
Private nTipo            := 18
Private lAbortPrint  := .F.  
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}

//SetRegua(Len(Adver))  
wnrel := SetPrint("",NomeProg,"","",cDesc1,cDesc2,cDesc3,.f.,aOrd,.f.,Tamanho,,.f.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"")

If nLastKey == 27
   Return
Endif

For i:=1 to len (Adver)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   @nLin,00 PSAY Adver[i][1] //Erro
   @nLin,40 PSAY '|'+Adver[i][3] //Produto
   @nLin,60 PSAY '|'+Adver[i][2] //Data
   @nLin,72 PSAY '|'+Adver[i][4] //Quant

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
Next 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/******************************************************************************************/
