#INCLUDE "rwmake.ch"
#Include "TOPCONN.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  28/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function imporpc_


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "ACESSO"
Private oLeTxt
Private aPC := {}
lEnd      := .F.
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa tem o objetivo de ler o conteudo do arquivo texto"
@ 18,018 Say " Gerado pelos relogios controladores dos port�es e emitir um "
@ 26,018 Say " Relatorio conforme parametros do usuario"

@ 60,118 BMPBUTTON TYPE 01 ACTION IPC()
@ 60,148 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  28/04/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

//Private cType   := "Acesso Port�o | *.TXT"
//Private cArqTxt := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,13)))

Private cArqTxt := "C:\Documents and Settings\jmoreira\Desktop\Parts.TXT"
Private nHdl    := fOpen(cArqTxt,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont () },"Lendo...") 
Processa({|| RunCont_() },"Gravando...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  28/04/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� ??_FILIAL     � 01     � 02                                    �
//�����������������������������������������������������������������ͼ

nTamFile := fSeek(nHdl,0,2)
//MSGSTOP(nTamFile)
fSeek(nHdl,0,0)
nTamLin  := 2+Len(cEOL)//2+40//2+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/42) // Numero de registros a processar

//SetRegua(RecCount())
While nBtLidos >= nTamLin

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������
//   IncRegua()
    IncProc()

    //���������������������������������������������������������������������Ŀ
    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
    //�����������������������������������������������������������������������
MSGSTOP(cBuffer)
xCC    := Substr(cBuffer,01,03)
xConta := Substr(cBuffer,04,08)
//xMat     := Substr(cBuffer,28,06)
//xRelogio := Substr(cBuffer,39,02)

   nPos := ASCAN(aPC,{|x| x[1] == xCC .and. x[2] == xConta })     
   IF nPos == 0   
      AAdd(aPC,{xCC,xConta})
   endif
    //���������������������������������������������������������������������Ŀ
    //� Leitura da proxima linha do arquivo texto.                          �
    //�����������������������������������������������������������������������

    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    If lEnd
       @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
       lContinua := .F.
       Exit
    Endif
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oLeTxt)

Return


Static Function RunCont_

Return    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPORTPC  �Autor  �Jefferson Moreira   � Data �  12/28/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importacao de dados para o sistema                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function imporpc  
Private cArq    := "C:\Documents and Settings\jmoreira\Meus documentos\Parts.TXT" //cGetFile()
oProcess := MsNewProcess():New({|| Processa(oProcess)},"","",.F.)
oProcess:cTitle:="Importa��o... "
oProcess:Activate()

return

Static Function Processa()
oProcess:SetRegua1(len(ft_freadln()))

ft_fuse(cArq)
xCount    := 0
aNE       := {}
While ! ft_feof()
     
     cBuff := ft_freadln()
     xCount++
     
     xCodPro   := subs(cBuff,03,15)
     xPriceCeF := STRTRAN(subs(cBuff,24,6),",",".")
     xPriceFOB := STRTRAN(subs(cBuff,32,6),",",".")
     //xQuant1   := STRTRAN(xQuant,".","") 
     //xQuant2   := STRTRAN(xQuant1,",",".")
     
    // MSGSTOP(xCodPro)
    // MSGSTOP(Val(xPriceCeF))
    //  MSGSTOP(Val(xPriceFOB))
     
     DbSelectArea("AIB")
     DbSetOrder(2)
     if !DbSeek(xFilial('AIB')+'111'+'01'+'002'+xCodPro)
     
        RecLock("AIB",.T.)
        
        AIB_FILIAL   := '01'
        AIB_CODFOR   := '111'
        AIB_LOJFOR   := '01'
        AIB_CODTAB   := '002'
        AIB_ITEM     := StrZero(xCount,4)
        AIB_CODPRO   := xCodPro
        AIB_PRCCOM   := Val(xPriceFOB)
        AIB_QDTLOT   := 999999.99
        AIB_DATVIG   := CTOD('01/09/08') 
     
        MsUnlock()
     
     Else 
        MSGSTOP('Codigo J� cadrastado...  '+xCodPro )
     Endif
    */ 
     //xQuant    := subs(cBuff,23,03)
     /*
     xQuant1   := STRTRAN(xQuant,".","") 
     xQuant2   := STRTRAN(xQuant1,",",".")
     */
     
  //  MSGSTOP(xEnd1+xEnd2+xEnd3)
    
  //   xCC        := subs(cBuff,69,03)
  //   xLote      := subs(cBuff,78,08)
 //    xData      := CtOd(subs(cBuff,84,02)+'/'+subs(cBuff,82,02)+'/'+subs(cBuff,78,04))     //CtoD("30/04/2008")
     //xPriCon    := Val(StrTran(Alltrim(subs(cBuff,101,17)),",",""))
     //xSegCon    := Val(StrTran(ALltrim(subs(cBuff,118,13)),",",""))
 //    xTerCon    := Val(StrTran(Alltrim(subs(cBuff,114,14)),",",""))
     
/*     
         
     DbSelectArea("SB1")
     DbSetOrder(1)
     if DbSeek(xFilial('SB1')+xCod)
     //   Alert('Gravar')
        
        
        RecLock("SB1",.f.)
        
        B1_QE2 := Val(xQuant)
     
        MsUnlock()
        
     Else
        //Alert('Produto n�o encontrado!!')
        aadd(aNE,xCod)
     Endif
 
 */  
   //  MSGSTOP(xCC)
   //  MSGSTOP(xData)
   //  MSGSTOP(xTerCon)
     //MSGSTOP(xSegCon) 
     //MSGSTOP(xTerCon)
     /*     
     DbSelectArea("CV1")
        
      For x:=1 to 12
          RecLock("CV1",.T.)
            CV1_FILIAL   := "01"
            CV1_ORCMTO   := "2007"
            CV1_DESCRI   := "PLANO ORCAMENTARIO 2007"
            CV1_STATUS   := "2"
            CV1_CALEND   := "007" 
            CV1_MOEDA    := "01"
            CV1_REVISA   := "001"
            CV1_SEQUEN   := StrZero(xCount,4)
            CV1_CT1INI   := xConta
            CV1_CT1FIM   := xConta
            CV1_CTTINI   := xCC
            CV1_CTTFIM   := xCC
            CV1_PERIOD   := StrZero(x,2) 
            CV1_DTINI    := CtoD("01/"+StrZero(x,2)+"/2007")
            IF x==1.or.x==3.or.x==5.or.x==7.or.x==8.or.x==10.or.x==12
            CV1_DTFIM    := CtoD("31/"+StrZero(x,2)+"/2007")
            elseif x==4.or.x==6.or.x==9.or.x==11
            CV1_DTFIM    := CtoD("30/"+StrZero(x,2)+"/2007")
            elseif x==2
            CV1_DTFIM    := CtoD("28/"+StrZero(x,2)+"/2007")
            endif
            CV1_VALOR    := 0
            CV1_APROVA   := "Victor"
          MsUnlock()
      Next
     */
     oProcess:IncRegua1("Atualizando... "+cBuff)//: "+xDoc+"-"+xProduto)
     ft_fskip()
EndDo
ft_fuse()
ApMsgInfo("Atualizacao Ok")
//PRINTIMPORT(aNE)
Return  



User Function PlContas
DbSelectArea("CV1")
DbSetOrder(1)
dbSeek (xFilial() + "2008")

  While !EOF() .And. ALLTRIM(CV1_ORCMTO)  == "2008"

  RecLock("CV1",.F.)

  //IF CV1_PERIOD=="01".or.CV1_PERIOD=="03".or.CV1_PERIOD=="05".or.CV1_PERIOD=="07".or.CV1_PERIOD=="08".or.CV1_PERIOD=="10".or.CV1_PERIOD=="12"
     CV1_DTINI    := CtoD("01/"+CV1_PERIOD+"/2008")
 // elseif CV1_PERIOD=="04".or.CV1_PERIOD=="06".or.CV1_PERIOD=="09".or.CV1_PERIOD=="11"
 //    CV1_DTINI    := CtoD("30/"+CV1_PERIOD+"/2008")
 // elseif CV1_PERIOD=="02"
 //    CV1_DTINI    := CtoD("29/"+CV1_PERIOD+"/2008")
 // endif
  MsUnlock()
  Dbskip()
  loop
  Enddo


Return

Static Function PRINTIMPORT(aNE)

SetPrvt("CSTRING,CABEC1,CABEC2,NOMEPROG")
SetPrvt("NLASTKEY,CDESC2,CDESC3,TAMANHO")
SetPrvt("WNREL,CDESC1,LEND,CPERG,LIMITE")
SetPrvt("AORD,LCONTINUA,ARETURN,TITULO,")
 
titulo    := PADC("RELA��O DE C�DIGOS N�O ATUALIZADOS",25)
cDesc1    := PADC("Este programa tem com objetivo imprimir a rela��o de Materiais",64)
cDesc2    := PADC("transferidos para outros c�digod por documento.",27)
cDesc3    := ""
tamanho   := "P"
limite    := 80  // 80=P 132=M 220=G          
cString   := "SD3"
aOrd      := {}
lContinua := .T.
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PRINTIMPORT"
nLastKey  := 0
cPerg     := "TRANSF"
pergunte(cPerg,.F.)
WnRel     := "PRINTIMPORT"
WnRel  	  := SetPrint(cString,WnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.t.,,.T.,tamanho)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01
aTrans := {}
titulo := "RELA��O DE CODIGOS N�O ATUALIZADOS A QDT POR EMBALAGEM"
cabec1 := "                    "
cabec2 := "It  Produto         "
//		   999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XX XXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XX  
//		   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//		   0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

Alert(Len(aNE))
_nCont := 1
for x:=1 to len(aNE)
 
	
	@ li,000      PSAY StrZero(_nCont,3)
	@ li,PCOL()+1 PSAY aNE[X]  // Quantidade
/*	@ li,PCOL()+1 PSAY aTrans[x][02]                                    // Codigo Origem
	@ li,PCOL()+1 PSAY SUBSTR(aTrans[x][03],1,30)                       // Descricao Origem
	@ li,PCOL()+1 PSAY aTrans[x][04]                                    // UM Origem
	@ li,PCOL()+1 PSAY aTrans[x][05]                                    // Local Origem
	@ li,PCOL()+1 PSAY aTrans[x][06]                                    // Lote
	@ li,PCOL()+1 PSAY aTrans[x][07]                                    // Codigo Destino
	@ li,PCOL()+1 PSAY SUBSTR(aTrans[x][08],1,30)                       // Descricao Destino
	@ li,PCOL()+1 PSAY aTrans[x][09]                                    // UM Destino
	@ li,PCOL()+1 PSAY aTrans[x][10]                                    // Local Destino
*/	  If li > 55
         cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      End
 li++
 _nCont++
next

If li != 80
	roda(cbcont,cbtxt,tamanho)
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return