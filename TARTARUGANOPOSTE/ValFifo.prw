#include "rwmake.ch"
#include "topconn.ch"
#Include "Protheus.ch" 
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"  



User Function ValFifo
Local Lote

/*	PCod:=ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_COD" }) //Preço Unitário
	PLocal:=ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOCAL" }) //Preço Unitário
	PLote :=ASCAN(aHeader, {|x| Alltrim(x[2]) == "D3_LOTECTL" }) //Preço Unitário
	
	ContLote:=Posicione("SB1",1,xFilial("SB1")+aCols[n][PCod],"B1_RASTRO")
	If ContLote <>'N'
	If GetMv("MV_AFIFO")  .and. funname()="MATA241"  .and. CTM $ '600/610' //Requisicoes para a producao
	Lote:=U_ChecaLote(aCols[n][PCod],aCols[n][PLocal])
	If Lote # M->D3_LOTECTL
	Alert("O Lote a ser movimentado pelo FIFO é "+Lote+". Informe o lote do FIFO.")
	EndIf
	
	EndIF
	EndIF  */
	
Return .T.
//
//


/************************************/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,¿
//³Função que checa o Lote da Vez. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ,Ù
/************************************/
User Function ChecaLote(_cProduto,_cLocal,_cLotectl,_aTmpEtiq)
Local Lote:=""

/*
DbSelectArea("SB8")
DbSetOrder(1)
If DbSeek(xFilial("SB8")+CodPro+CodArm)
While !Eof()
if SB8->B8_PRODUTO=CodPro .and. SB8->B8_LOCAL=CodArm
if SB8->B8_SALDO>0
Lote:=SB8->B8_LOTECTL
Exit
EndIf
Else
Exit
EndIf
DbSelectArea("SB8")
DbSkip()
EndDo
EndIf
*/

Return  Lote

//
//
/*
User Function QuebraFifoLib(_cProduto, _cLocal, _cLocali, _cLotectl, _cNumLote, _nQtde, _cEtiqueta )
Local aTela    := VtSave()
Local cUsuario := Space(10)
Local cPassword:= Space(10)
Local cNome    := Space(20)
Local cMotivo  := Space(06)
Local lSair    := .F.
Local lRet     := .F.
Local cCont    := Space(01)

Private cMotDesc := Space(20)

VtClear
//vtreverso(.T.)
@ 00,02 vtsay 'Quebra FIFO'
//@ 01,02 vtsay ' Liberacao '
//vtreverso(.F.)
//
@ 02,00 vtsay 'Usuario:'
@ 02,10 vtget cUsuario  picture '@!' valid  !empty(cUsuario)  .and. ValidUsr(Left(cUsuario,6), "QuebraFifoLib") F3 'US2'
@ 03,00 vtsay 'Senha:'
@ 03,10 vtget cPassword picture '@!' valid  !empty(cPassword) //.and. ValidUsr(cUsuario)  //f3 'US2'
@ 04,00 vtsay 'Motivo:'
@ 04,10 vtget cMotivo   picture '@!' valid  !empty(cMotivo)  .and. ValidMot(cMotivo)  F3 'ZZ2'
@ 05,00 vtget cMotDesc  picture '@!' when .f.
vtread
If VtLastKey() == 27
	vtClear
	vtrestore(,,,,aTela)
	Return(.F.)
Endif    
//
cCont := Space(01)
While !lSair
	@ 06,00 vtsay 'Confirma? (1=S/0=N)'
	@ 06,20 vtget cCont 	Picture '9' valid cCont $ "01"
	vtread
	If cCont $ "1"
	   lRet := .T.	        
	Endif
    lSair := .T. 	   	
Enddo
//
vtClear
vtrestore(,,,,aTela)
Return(lRet)
*/
