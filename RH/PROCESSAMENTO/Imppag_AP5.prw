#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Imppag()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCA,ODLG,CMENS,CGRV,CGRVF1,CGRVD1")
SetPrvt("XOCORR,CTYPE,CARQUIVO,ACPO,CTRB,CSTRING")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG")
SetPrvt("LCONTINUA,ALINHA,NLASTKEY,LEND,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,LI,M_PAG,WNREL,TVALDOC")
SetPrvt("TVALPAG,TTOTAL,NTIPO,XVALDOC,XVALPAG,XPOS")
SetPrvt("XTIPMOV,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPPAG   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de arquivo de retorno. (Pagto a Fornecedores)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

nOpca  := 0
oDlg   := ""
cMens  := ""
cGrv   := ""
cGrvF1 := ""
cGrvD1 := ""

xOcorr := {} // TABELA DE CODIGO DE RETORNO - (Pagto a Fornecedores).
AADD(xOcorr,{"AA" , "ARQUIVO DUPLICADO."})                              // 01
AADD(xOcorr,{"AB" , "DATA LIMITE P/DESCONTO SEM VALOR"})                // 02
AADD(xOcorr,{"AC" , "TIPO DE SERVICO INVALIDO."})                       // 03
AADD(xOcorr,{"AD" , "MODALIDADE DE PAGTO INVALIDA"})                    // 04
AADD(xOcorr,{"AE" , "TIPO DE INSCR. DO CLIENTE IMCOPATIVEL."})          // 05
AADD(xOcorr,{"AF" , "VALORES NAO NUMERICOS."})                          // 06
AADD(xOcorr,{"AG" , "TIPO DE INSCR. DO FAVORECIDO."})                   // 07
AADD(xOcorr,{"AJ" , "TIPO DE MOVIMENTO INVALIDO."})                     // 08
AADD(xOcorr,{"AL" , "BANCO,AGENCIA OU CONTA INVALIDOS."})               // 09
AADD(xOcorr,{"AM" , "AGENCIA DO FAVORECIDO INVALIDA."})                 // 10
AADD(xOcorr,{"AN" , "CONTA CORRENTE DO FAVORECIDO INVALIDA."})          // 11
AADD(xOcorr,{"AO" , "NOME DO FAVORECIDO NAO INFORMADO."})               // 12
AADD(xOcorr,{"AQ" , "TIPO DE MOEDA INVALIDO."})                         // 13
AADD(xOcorr,{"AT" , "CNPJ/CPF D0 FAVORECIDO INVALIDO."})                // 14
AADD(xOcorr,{"AU" , "END. DO FAVORECIDO NAO INFORMADO."})               // 15
AADD(xOcorr,{"AX" , "CEP DO FAVORECIDO INVALIDO."})                     // 16
AADD(xOcorr,{"AY" , "ALTERACAO INVALIDO..."})                           // 17
AADD(xOcorr,{"AZ" , "CODIGO DO BANCO FAVORECIDO INVALIDO."})            // 18

AADD(xOcorr,{"BD" , "PAGAMENTO AGENDADO."})                             // 19
AADD(xOcorr,{"BE" , "HORA DE GRAVACAO INVALIDA."})                      // 20
AADD(xOcorr,{"BF" , "IDENT. EMPRESA NO BANCO INVALIDO."})               // 21
AADD(xOcorr,{"BG" , "CNPJ/CPF D0 PAGADOR INVALIDO."})                   // 22
AADD(xOcorr,{"BH" , "TIPO DE INSCR. FAVORECIDO INVALIDO."})             // 23
AADD(xOcorr,{"BI" , "DATA VENCTO INVALIDA OU NAO PREENCHIDA."})         // 24
AADD(xOcorr,{"BJ" , "DATA DE EMISSAO DO DOCUMENTO INVALIDA."})          // 25
AADD(xOcorr,{"BL" , "DATA LIMITE P/ DESCONTO INVALIDA."})               // 26
AADD(xOcorr,{"BM" , "DATA P/ EFETIVACAO DO PGTO INVALIDA."})            // 27
AADD(xOcorr,{"BN" , "DATA P/ EFETIVACAO ANTERIOR A PROC."})             // 28
AADD(xOcorr,{"BO" , "CLIENTE NAO CADASTRADO."})                         // 29
AADD(xOcorr,{"BP" , ""})                                                // 30
AADD(xOcorr,{"BQ" , ""})                                                // 31
AADD(xOcorr,{"BT" , ""})                                                // 15
AADD(xOcorr,{"BU" , ""})                                                // 15
AADD(xOcorr,{"BV" , ""})                                                // 15
AADD(xOcorr,{"BW" , "PAGAMENTO EFETUADO."})                             // 15

AADD(xOcorr,{"FA" , "CODIGO DE ORIGEM INVALIDO."})                      // 15
AADD(xOcorr,{"FB" , "DATA DE GRAVACAO DO ARQ. INVALIDO."})              // 15
AADD(xOcorr,{"FC" , "TIPO DE DOCUMENTO INVALIDO."})                     // 15
AADD(xOcorr,{"FE" , "NUMERO DE PAGAMENTO INVALIDO."})                   // 15
AADD(xOcorr,{"FF" , "VALOR DE DESCONTO SEM DATA LIMITE."})              // 15
AADD(xOcorr,{"FG" , "Data limite para desconto posterior ao vencimento"}) // 15
AADD(xOcorr,{"FH" , "Falta número e/ou série do documento "})           // 15
AADD(xOcorr,{"FI" , "Exclusão de agendamento não disponível "})         // 15
AADD(xOcorr,{"FJ" , "SOMA DOS VALORES NAO CONFERE."})                   // 15
AADD(xOcorr,{"FK" , "FALTA VALOR DE PAGAMENTO."})                       // 15
AADD(xOcorr,{"FL" , "MODALIDADE DE PAGTO INVALIDA."})                   // 15
AADD(xOcorr,{"FM" , "CODIGO DO MOVIMENTO INVALIDO"})                    // 15
AADD(xOcorr,{"FN" , "Tentativa de inclusão de registro existente"})     // 15
AADD(xOcorr,{"FO" , "TENTATIVA DE REGISTRO INEXISTENTE"})  // 15
AADD(xOcorr,{"FP" , "Tentativa de efetivação de agendamento não disponível"}) // 15
AADD(xOcorr,{"FQ" , "Tentativa de desautorização de agendamento não disponível"})// 15
AADD(xOcorr,{"FR" , "Autorização de agendamento sem data de efetivação e sem data de vencimento"})                                                // 15
AADD(xOcorr,{"FS" , "TITULO EM ANDAMENTO. PED. DE CONFIRMACAO."})       // 15
AADD(xOcorr,{"FT" , "TIPO DE INSCR. DO CLIENTE INVALIDO."})             // 15
AADD(xOcorr,{"FU" , ""})                                                // 15
AADD(xOcorr,{"FV" , ""})                                                // 15
AADD(xOcorr,{"FW" , ""})                                                // 15
AADD(xOcorr,{"FX" , ""})                                                // 15
AADD(xOcorr,{"FZ" , ""})                                                // 15
AADD(xOcorr,{"F0" , "AGENDAMENTO EM ATRASO; NAO PERMITIDO PELO CONVENIO"}) // 15
AADD(xOcorr,{"F3" , ""})                                                // 15
AADD(xOcorr,{"F4" , ""})                                                // 15
AADD(xOcorr,{"F5" , "VALOR DO TRAILLDER NAO CONFERE."})                 // 15
AADD(xOcorr,{"F6" , "QUANT. REG. DO TRAILLER NAO CONFERE."})            // 15
AADD(xOcorr,{"F7" , ""})                                                // 15
AADD(xOcorr,{"F8" , ""})                                                // 15
AADD(xOcorr,{"F9" , ""})                                                // 15

AADD(xOcorr,{"GA" , "TIPO DE DOCUMENTO INVALIDO."})                     // 15
AADD(xOcorr,{"GB" , "NUMERO DOCUMENTO INVALIDO."})                      // 15
AADD(xOcorr,{"GC" , ""})                                                // 15
AADD(xOcorr,{"GD" , "CONTA CORRENTE DO FAVORECIDO INVALIDO."})          // 1
AADD(xOcorr,{"GE" , "CONTA CORRENTE DO FAVORECIDO NAO CADASTRADA."})    // 15
AADD(xOcorr,{"GF" , ""})   // 15
AADD(xOcorr,{"GG" , "CAMPO LIVRE DO COD. BARRAS (LINHA DIGIT) INVALIDO."}) // 15
AADD(xOcorr,{"GH" , "DIG. VERIFICADOR DO COD. BARRAS INVALIDO."})        // 15
AADD(xOcorr,{"GI" , "COD. DA MOEDA DA LINHA DIGITAVEL INVALIDO"})        // 15
AADD(xOcorr,{"GJ" , ""})                                                 // 15
AADD(xOcorr,{"GK" , ""})                                                 // 15                    
AADD(xOcorr,{"GL" , ""})                                                 // 15                                        
AADD(xOcorr,{"GM" , ""})                                                 // 15
AADD(xOcorr,{"GN" , "CONTA COMPLEMENTAR INVALIDA."})                     // 15
AADD(xOcorr,{"GO" , ""})                                                 // 15
AADD(xOcorr,{"GP" , ""})                                                 // 15
AADD(xOcorr,{"GQ" , ""})                                                 // 15
AADD(xOcorr,{"GR" , ""})                                                 // 15
AADD(xOcorr,{"GS" , ""})                                                 // 15
AADD(xOcorr,{"GT" , "TIPO DE INSCR. DO CLIENTE INVALIDO."})              // 15
AADD(xOcorr,{"GU" , ""})                                                 // 15
AADD(xOcorr,{"GV" , ""})                                                 // 15
AADD(xOcorr,{"GW" , ""})                                                 // 15
AADD(xOcorr,{"GX" , ""})                                                 // 15
AADD(xOcorr,{"GY" , ""})                                                 // 1
                                                                   
AADD(xOcorr,{"HA" , "AGENDADO, DEBITO SOB CONSULTA DE SALDO."})          // 15
AADD(xOcorr,{"HB" , "PAGAMENTO NAO EFETUADO, SALDO INSUFICIENTE."})      // 15
AADD(xOcorr,{"HC" , ""})                                                 // 15
AADD(xOcorr,{"HD" , ""})                                                 // 15
AADD(xOcorr,{"HE" , ""})                                                 // 1

AADD(xOcorr,{"JA" , "CODIGO DE LANCAMENT0 INVALIDO."})                   // 15
AADD(xOcorr,{"JB" , "DOC DEVOLVIDO E ESTORNADO."})                       // 15

@ 96,13 To 310,592 DIALOG oDlg TITLE "Leitura do Arquivo Retorno - (Pagto a Fornecedores)"
@ 18, 6 To 66, 287
@ 29, 15 SAY OemToAnsi("Este programa tem como objetivo Importar dados dos arquivos selecionados.")
@ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION PG010I()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> @ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION Execute(PG010I)
@ 80, 220 BMPBUTTON TYPE 2 ACTION PG010Fim()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> @ 80, 220 BMPBUTTON TYPE 2 ACTION Execute(PG010Fim)
ACTIVATE DIALOG oDlg
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PG010I   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao de dados                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function PG010I
Static Function PG010I()
nOpca    := 0
cType    := "Retorno PAGFOR | ??*.RET"
cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Left(cType,7)))
If !Empty( cArquivo )
    If File( cArquivo) 
             nOpca := 1
    Else  
             MsgAlert("Arquivo nao encontrado")
    Endif
Endif
If nOpca == 1
   Processa({|| ProcImp()})// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    Processa({|| EXECUTE(ProcImp)})
EndIf
Close(oDlg)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcImp   ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento de Importacao dos Dados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function ProcImp
Static Function ProcImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  IF "fp"$cArquivo
  
	 aCpo := {}
  	 AADD(aCpo,{"TIPO"     ,"C",001,0}) 
  	 AADD(aCpo,{"RESERV1"  ,"C",061,0})   	 
  	 AADD(aCpo,{"AGENCIA"  ,"C",005,0})   	 
  	 AADD(aCpo,{"RZCONTA"  ,"C",005,0})   	   	 
   	 AADD(aCpo,{"NRCONTA"  ,"C",007,0})   	 
   	 AADD(aCpo,{"DGCONTA"  ,"C",001,0})   	 
   	 AADD(aCpo,{"RESERV2"  ,"C",002,0})   	    	 
   	 AADD(aCpo,{"NOME"     ,"C",038,0})   	    	    	 
   	 AADD(aCpo,{"MATRIC"   ,"C",006,0})   	    	    	 
   	 AADD(aCpo,{"VALOR"    ,"C",013,0})   	    	    	 
   	 AADD(aCpo,{"CODSRV"   ,"C",003,0})   	    	    	    	 
   	 AADD(aCpo,{"RESERV3"  ,"C",008,0})   	    	    	    	 
   	 AADD(aCpo,{"RESERV4"  ,"C",044,0})   	    	    	    	 
   	 AADD(aCpo,{"NRSEQ"    ,"C",006,0})   	    	    	    	 

  	 cTRBFP   := CriaTrab(aCpo,.T.)
     dbUseArea(.T.,,cTRBFP,"TRBFP",.T.,.F.)
     // IndRegua( "TRB", cTRB, "TR_DOC",,,"Criando Indice ..." )
     Append From &(cArquivo) SDF // DELIMITED
     
  	 dbSelectArea("TRBFP")
  	 dbGotop() 
  	 
     cDatadoDebito := SUBSTR(TRBFP->NOME,13,8)
     cDatadoDebito := SUBSTR(cDatadoDebito,1,2)+"/"+SUBSTR(cDatadoDebito,3,2)+"/"+SUBSTR(cDatadoDebito,5,4)

  ENDIF

  aCpo := {}
  AADD(aCpo,{"TR_TIPO"    ,"C",001,0})  ;  AADD(aCpo,{"TR_INSCR"   ,"C",002,0})  // 02
  AADD(aCpo,{"TR_CNPJ"    ,"C",014,0})  
  AADD(aCpo,{"TR_NOME"    ,"C",030,0})  ;  AADD(aCpo,{"TR_FILER01" ,"C",048,0})  // 05
  AADD(aCpo,{"TR_BANCO"   ,"C",009,0})  ;  AADD(aCpo,{"TR_FILER02" ,"C",025,0})  // 08
  AADD(aCpo,{"TR_NUMPAG"  ,"C",006,0})  ;  AADD(aCpo,{"TR_FILER03" ,"C",030,0})  // 08
  AADD(aCpo,{"TR_DTVCTO"  ,"C",008,0})  ;  AADD(aCpo,{"TR_FILER04" ,"C",023,0})  // 10
  AADD(aCpo,{"TR_VALDOC"  ,"C",008,0})  
  AADD(aCpo,{"TR_VALPAG"  ,"C",015,0})  ;  AADD(aCpo,{"TR_FILER05" ,"C",030,0})  // 10
  AADD(aCpo,{"TR_TIPDOC"  ,"C",002,0})  
  AADD(aCpo,{"TR_NUMDOC"  ,"C",010,0})  ; AADD(aCpo,{"TR_FILER06" ,"C",002,0})  // 10
  AADD(aCpo,{"TR_MODALID" ,"C",002,0})  
  AADD(aCpo,{"TR_DATPAG"  ,"C",008,0})  ; AADD(aCpo,{"TR_FILER07" ,"C",003,0})  // 10
  AADD(aCpo,{"TR_SITAGEN" ,"C",002,0})  
  AADD(aCpo,{"TR_CODRET"  ,"C",002,0})  
  

  cTRB   := CriaTrab(aCpo,.T.)
  dbUseArea(.T.,,cTRB,"TRB",.T.,.F.)
 // IndRegua( "TRB", cTRB, "TR_DOC",,,"Criando Indice ..." )
 
  dbSelectArea("TRB")  

  IF "fp"$cArquivo

  	 dbSelectArea("TRBFP")
//  	 Count to nQreg
//     SetRegua(nQreg)
     dbGoTop()
     While !EOF() 
   
      	 dbSelectArea("TRB")      	 
	     RecLock("TRB",.T.)
  	 	 TRB->TR_TIPO  := TRBFP->TIPO
  	 	 TRB->TR_BANCO := TRBFP->AGENCIA
   	 	 TRB->TR_NUMDOC := TRBFP->NRCONTA+"-"+TRBFP->DGCONTA
   	 	 TRB->TR_NOME := TRBFP->NOME
   	 	 TRB->TR_CNPJ := TRBFP->MATRIC
   	 	 TRB->TR_VALDOC :=TRBFP->VALOR
   	 	 TRB->TR_VALPAG :=TRBFP->VALOR   	 	 
      	 MSUNLOCK()
   	   	 dbSelectArea("TRBFP")
   	   	 
   	   	 DbSkip()
   	   	 
     End
	 dbSelectArea("TRBFP")   
     
  ELSE   
  
     Append From &(cArquivo) SDF // DELIMITED
     
  ENDIF   

  PG020I()  // Impressao do Relatorio.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PG020I  ³ Autor ³ Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Arq. de Retorno ( Cartao Salario ).            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function PG020I
Static Function PG020I()
cString :="TRB"
cDesc1  := OemToAnsi("Este programa tem como objetivo, demostrar as ocorrencias")
cDesc2  := OemToAnsi("apresentadas no Arquivo de Retorno, do Pagto a Fornecedores.")
cDesc3  := ""
tamanho := If( "fp"$cArquivo, "P" , "G" )
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="IMPPAG"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd := .f.

IF "fp"$cArquivo

	titulo      :="Pagamento Escritural a Colaboradores"
	cabec1      :="Agencia Conta       Nome                            Matric                 Valor"
	cabec2      :="Arquivo: "+cArquivo
	             //XXXXX   XXXXXXX-X   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999999   999,999,999.99   999999
	             //1       9           22                                       62       71               88
ELSE
	titulo      :="Pagamento Escritural a Fornecedores."
	cabec1      :="Nr.Pgto Docto   Fornecedor                      Inscricao           TP  Bco/Agenc    Dt.Vencto   Dt.Pagto     Val.Docto   Val.Pagto  Ocorrencias"
	cabec2      :="Arquivo: "+cArquivo
ENDIF	

cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel:="IMPPAG"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To 
    Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> RptStatus({|| Execute(RptDetail) })
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

tValDoc := 0
tValPag := 0
tTotal  := 0

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
dbSelectArea("TRB")
//Count to nQreg 
//SetRegua(nQreg)
dbGoTop()

While !EOF() .And. lContinua                      

//      IncRegua()

      #IFNDEF WINDOWS
                    If LastKey() == 286
                       lEnd := .t.
                    End
      #ENDIF

      If lEnd
                    @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
                    lContinua := .F.
                    Exit
      Endif
      
  IF "fp"$cArquivo

	      If TRB->TR_TIPO == "1"
	
	         xVALDOC := VAL(TR_VALPAG) / 100
	         xVALPAG := VAL(TR_VALPAG) / 100
	         
	         @ li,000      PSAY SUBSTR(TR_BANCO,1,5)
	         @ li,PCOL()+3 PSAY TR_NUMDOC
	         @ li,PCOL()+2 PSAY SUBSTR(TR_NOME,1,38)
	         @ li,PCOL()+2 PSAY SUBSTR(TR_CNPJ,1,12)
	         @ li,PCOL()+2 PSAY TRANSFORM(xVALPAG,"@E 999,999,999.99")
	         
	         li := li + 1
	
	         tValDoc := tValDoc + xVALPAG
  	         tValPag := tValPag + xVALPAG
	         tTotal := tTotal + 1
	
	      END
	
	      If li > 55
         	 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          End
      ELSE
	      If TRB->TR_TIPO == "1"
	
	         xVALDOC := VAL(TR_VALDOC) / 100
	         xVALPAG := VAL(TR_VALPAG) / 100
	
	         xPos := aScan(xOcorr,{ |X| X[1] == TR_CODRET })
	                  
	         If TR_SITAGEN == "01"
	            xTIPMOV := "NAO PAGO                "
	         ElseIf TR_SITAGEN == "05"
	            xTIPMOV := "BAIXA C0BR. SEM PAGAMENTO"
	         ElseIf TR_SITAGEN == "06"
	            xTIPMOV := "BAIXA C0BR. COM PAGAMENTO"
	         ElseIf TR_SITAGEN == "07"
	            xTIPMOV := "COM INSTR. DE PROTESTO   "
	         ElseIf TR_SITAGEN == "08"
	            xTIPMOV := "TRANSFERENCIA P/ CARTORIO"
	         ElseIf TR_SITAGEN == "09"
	            xTIPMOV := "BAIXADO PELO DESCONTO    "
	         ElseIf TR_SITAGEN == "11"
	            xTIPMOV := "CHEQUE OP ESTPORNADO     "
	         ELSE
	            xTIPMOV := SPACE(20)
	         End
	
	         @ li,000      PSAY TR_NUMPAG
	         @ li,PCOL()+2 PSAY SUBS(TR_NUMDOC,5,6)
	         @ li,PCOL()+2 PSAY SUBS(TR_NOME,1,30)                                          
	         @ li,PCOL()+2 PSAY TRANSFORM(TR_CNPJ,"@r !!.!!!.!!!/!!!!-!!")
	         @ li,PCOL()+2 PSAY TR_TIPDOC
	         @ li,PCOL()+2 PSAY TRANSFORM(TR_BANCO,"@R !!!/!!!!1-!")
	         @ li,PCOL()+2 PSAY RIGHT(TR_DTVCTO,2)+"/"+SUBS(TR_DTVCTO,5,2)+"/"+LEFT(TR_DTVCTO,4)
	         @ li,PCOL()+2 PSAY RIGHT(TR_DATPAG,2)+"/"+SUBS(TR_DATPAG,5,2)+"/"+LEFT(TR_DATPAG,4)
	         @ li,PCOL()+2 PSAY TRANSFORM(xVALDOC,"@E 999,999.99")
	         @ li,PCOL()+2 PSAY TRANSFORM(xVALPAG,"@E 999,999.99")
	         If xPos > 0 
	            @ li,PCOL()+2 PSAY xOcorr[xPos][1]+" "+xOcorr[xPos][2]
	         Else
	            @ li,PCOL()+2 PSAY "Ocorrencia: "+TR_CODRET+" Nao identificada."
	         End 
	         
	           
	         li := li + 1
	
	         tValDoc := tValDoc + xVALDOC
	         tValPag := tValPag + xVALPAG
	         tTotal := tTotal + 1
	
	      END
	
	      If li > 55
         	 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          End
      
      ENDIF    

      dbSkip()
End
IF "fp"$cArquivo
   li := li + 1
   @ li,001 PSay "Data do Debito"
   @ li,030 PSAY "     Qtde. Total:"
   @ li,049 PSAY TRANSFORM(tTotal,"@E 999,999")
   li := li + 1
   @ li,001 PSay cDatadoDebito
   @ li,030 PSAY "     Valor Total:"
   @ li,049 PSAY TRANSFORM(tVALPAG,"@E 999,999,999.99")
ELSE		
   li := li + 1
   @ li,030 PSAY "Quantidade Total:"
   @ li,049 PSAY TRANSFORM(tTotal,"@E 999,999")
   @ li,085 PSAY "Valor Total:"
   @ li,107 PSAY TRANSFORM(tVALPAG,"@E 999,999.99")
ENDIF

Roda(0,"","M")
Set Filter To

IF "fp"$cArquivo                          
   dbSelectArea("TRBFP")
   dbCloseArea()
   fErase( cTRBFP )
Endif

dbSelectArea("TRB")
dbCloseArea()
fErase( cTRB )
// Ferase( cTRB+OrdBagExt() )

If aReturn[5] == 1
    Set Printer To
    Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PG010Fim ³ Autor ³Jorge Silveira da Silva³ Data ³ 12.10.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de finalizacao da rotina                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function PG010Fim
Static Function PG010Fim()
Close(oDlg)
Return
