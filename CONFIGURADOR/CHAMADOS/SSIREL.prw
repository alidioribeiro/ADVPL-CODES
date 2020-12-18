#INCLUDE "rwmake.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |SSIREL    º Autor ³ Jefferson Moreira  º Data ³  10/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP8 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SSIREL


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Solicitação de Serviços de Informativa ( SSI )"
Local cPict        := ""
Local titulo       := "Solicitação de Serviços de Informativa ( SSI )"
Local nLin         := 80
Local Cabec1       := "SEQ.  SSI     DESCRIÇÃO                                          TIPO                 EMISSÃO  STATUS     CC  SOLICITANTE          APROVADOR            DT APROV  DT ENTRE  TECNICO             DT ENCER CLASSEFICAÇÃO  TG"
//                     9999  999999  AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEE AAAAAAAAAABBBBBBBBBB 22/22/22 AAAAAAAAAA 123 AAAAAAAAAABBBBBBBBBB AAAAAAAAAABBBBBBBBBB 22/22/22  22/22/22  AAAAAAAAAABBBBBBBBB 22/22/22 AAAAAAAAAABBBB HH:MM
Local Cabec2       := ""
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789  
//                     0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
Local imprime      := .T.
Local aOrd         := {"Sintético","Analítico"}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "SSIREL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "SSIREL" // Coloque aqui o nome do arquivo usado para impressao em disco
Private CPERG      := "SSIREL"
Private cString    := "SZH"

dbSelectArea("SZH")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,CPERG,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif                           

nOrdem := aReturn[8]
nTipo := If(aReturn[4]==1,15,18)
titulo += "   "+ aOrd[nOrdem]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//Local nOrdem
Private	aAberOcor	:= {},;
		aComentar	:= {},;
		aSolucao	:= {}

dbSelectArea("SZH")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
Item:=0
TotSSI:={}
While !EOF()
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif 
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Filtra parametros do usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
   If ZH_NUMCHAM < Mv_Par01 .Or. ZH_NUMCHAM > Mv_Par02
      dbSkip()
      Loop
   End
       
   If MV_PAR14=1   //tipo de filtro emissao ou abertura
	   If ZH_DTABERT < Mv_Par03 .Or. ZH_DTABERT > Mv_Par04
	      dbSkip()
	      Loop
	   End
  Else
	   If ZH_DTENTRE< Mv_Par03 .Or. ZH_DTENTRE > Mv_Par04
	      dbSkip()
	      Loop
	   End
  EndIf 	


   If ZH_SOLCHAM < Mv_Par05 .Or. ZH_SOLCHAM > Mv_Par06
      dbSkip()
      Loop
   End
   
   If ZH_TIPO < Mv_Par07 .Or. ZH_TIPO > Mv_Par08
      dbSkip()
      Loop
   End
   
   If ZH_CC < Mv_Par09 .Or. ZH_CC > Mv_Par10
      dbSkip()
      Loop
   End

   If ZH_TECNICO < Mv_Par11 .Or. ZH_TECNICO > Mv_Par12
      dbSkip()
      Loop
   End 
    Do case 
       case ZH_STATUS == "0"
//           xStatus := "Aberto    "
            xStatus := "Aguar. Aprovação "
       case ZH_STATUS == "1"
           xStatus := "Andamento "
       case ZH_STATUS == "2"
           xStatus := "Aprovado  "
       case ZH_STATUS == "8"
           xStatus := "Cancelado "
       case ZH_STATUS == "9"
           xStatus := "Encerrado "
    Endcase        

//   If (Mv_Par13 == 1 .AND. ZH_STATUS <> "0") .OR. (Mv_Par13 == 2 .AND. ZH_STATUS <> "2"  ).OR. (Mv_Par13 ==3 .AND. ZH_STATUS <> "9") .OR. (Mv_Par13 == 4 .AND. ZH_STATUS <> "1") 
   If (Mv_Par13 == 1 .AND. ZH_STATUS <> "0") .OR. (Mv_Par13 == 2 .AND. ZH_STATUS <> "2"  ).OR. (Mv_Par13 ==3 .AND. ZH_STATUS <> "9") .OR. (Mv_Par13 == 4 .AND. ZH_STATUS <> "1") 
      dbSkip()
      Loop                                                     
   End
   PosAt:=AScan(TotSSI,{|x|Alltrim(x[1])=ZH_STATUS})
   If PosAt#0 
   	  TotSSI[PosAt][3]:=TotSSI[PosAt][3]+1
   Else
	 AAdd(TotSSI,{Alltrim(ZH_STATUS),xStatus,1})
   EndIf
//TESTE
//FIM TESTE


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   item++
   dbSelectArea("SX5")
   dbSeek(xFilial("SX5")+"ZF"+SZH->ZH_TIPO)
   xTipo := Subs(X5_DESCRI,1,20)
   dbSeek(xFilial("SX5")+"ZH"+SZH->ZH_CLASSIF)
   xClass := Subs(X5_DESCRI,1,14)
  

   dbSelectArea("SZH")
    xSolici	    := IIF(!Empty(ZH_SOLCHAM),Upper(UsrFullName(ZH_SOLCHAM)),Space(30))
    xAprova	    := IIf(!Empty(ZH_APROVA) ,Upper(UsrFullName(ZH_APROVA)) ,Space(30))
    xTecnico    := IIF(!Empty(ZH_TECNICO),Upper(UsrFullName(ZH_TECNICO)),Space(30))
   	xEmissao    := IIF(!Empty(ZH_DTABERT),Subs(DtoS(ZH_DTABERT),7,2) + "/" + Subs(DtoS(ZH_DTABERT),5,2)+ "/" + Subs(DtoS(ZH_DTABERT),3,2),Space(8))
   	xDtAprov    := IIF(!Empty(ZH_DTAPROV),Subs(DtoS(ZH_DTAPROV),7,2) + "/" + Subs(DtoS(ZH_DTAPROV),5,2)+ "/" + Subs(DtoS(ZH_DTAPROV),3,2),Space(8))
   	xDtentre    := IIF(!Empty(ZH_DTENTRE),Subs(DtoS(ZH_DTENTRE),7,2) + "/" + Subs(DtoS(ZH_DTENTRE),5,2)+ "/" + Subs(DtoS(ZH_DTENTRE),3,2),Space(8))
   	xDtEncer    := IIF(!Empty(ZH_DTFECHA),Subs(DtoS(ZH_DTFECHA),7,2) + "/" + Subs(DtoS(ZH_DTFECHA),5,2)+ "/" + Subs(DtoS(ZH_DTFECHA),3,2),Space(8))
   	
   	
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    @nlin,000      Psay Strzero(item,4)
    @nLin,Pcol()+2 PSAY SUBSTR(ZH_NUMCHAM,3,6)
    @nLin,PCOL()+2 PSAY SUBSTR(ZH_DESC,1,50)
    @nLin,PCOL()+1 PSAY xTipo
    @nLin,PCOL()+1 PSAY xEmissao
    @nLin,PCOL()+1 PSAY xStatus
    @nLin,PCOL()+1 PSAY SUBSTR(ZH_CC,1,3)
    @nLin,PCOL()+1 PSAY SUBSTR(xSolici,1,20)
    
    //nLin := nLin + 1 // Avanca a linha de impressao

    @nLin,PCOL()+1 PSAY SUBSTR(xAprova,1,20)
    @nLin,PCOL()+1 PSAY xDtAprov
    @nLin,PCOL()+1 PSAY xDtentre
    @nLin,PCOL()+1 PSAY SUBSTR(xTecnico,1,20)
    @nLin,PCOL()+1 PSAY xDtEncer
    @nLin,PCOL()+1 PSAY SUBSTR(xClass,1,14)
    @nLin,PCOL()+1 PSAY ZH_TMPEXEC
    
    if nOrdem == 2
    
     nLin++
     @nLin,000 PSAY "Ocorrência: " 
     nLin++
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
     Endif  
     cMemo1  := ZH_OCORREN
     //cMemAux := ""
     nLinhas := MlCount( cMemo1,200) 
     For nCntFor := 1 to nLinhas 
          cMemo1 += MemoLine( ZH_OCORREN, nCntFor )
     Next nCntFor
     
    // For nCntFor:=1 to nLinhas
    //   @ nLin+nCntFor-1,001 PSAY memoline(AllTrim(cMemo1),220,nCntFor)
    // Next 

     @nLin,000 PSAY cMemo1
     nLin++
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
     Endif
     @nLin,000 PSAY "Solução: " 
     nLin++
    
     cMemo2  := ZH_SOLUCAO
     cMemAux := ""
     nLinhas := MlCount( cMemAux,200) 
     For nCntFor := 1 to nLinhas 
          cMemo2 += MemoLine( cMemAux, 100, nCntFor )
     Next nCntFor 

     @nLin,000 PSAY cMemo2
    
    endif
    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
    Endif
    nLin++ // Avanca a linha de impressao
    @ nLin,000 PSAY Replicate("-",Limite)
    nLin++ // Avanca a linha de impressao
    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
    Endif
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
nlin+=2
If nLin+5> 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 8
Endif 


@nLin,000      PSAY "TOTAIS DE ATENDIMENTO POR PERÍODO"
nlin++ 
@nLin,000 PSAY Replicate("-",40)
If nLin> 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 8
Endif 
nlin++
@nLin,000      PSAY "STATUS"
@nLin,030      PSAY "|QUANTIDADE"
nlin++
//@nLin,000 PSAY Replicate("-",40)
//nlin++ 
If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 8
Endif 
TotSSI:=ASORT(TotSSI,,,{ |x,y| x[1] < x[2] })
TotGer:=0
For i:=1 to len (TotSSI)
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
	     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	     nLin := 8
	Endif
	TotGer+=TotSSI[i][3]
    @nLin,000      PSAY TotSSI[i][2]
    @nLin,030      PSAY "|"+Strzero(TotSSI[i][3],4)
    nlin++ 

Next
If nLin > 60 // Salto de Página. Neste caso o formulario tem 60 linhas...
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     nLin := 8
Endif

@nLin,000      PSAY "Geral"
@nLin,030      PSAY "|"+Strzero(TotGer,4)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
 dbSelectArea("TZH")
 dbClearFil(NIL)
 dbCloseArea("TZH")
 dbCloseArea()
*/ 
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
          
