#include "rwmake.ch"
//
//Para todos o pedido de faturamento o campo de Inss deve estar preenchido SB5//
//
//

User Function M410STTS
Local NumPed:="",Chave:="",InssFolha:="2"
NumPed:=SC6->C6_NUM
Chave:=xFilial("SC6")+NumPed
DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("SB5")
DbSetOrder(1)
DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(Chave)
While !Eof()
	If Chave==xFilial("SC6")+SC6->C6_NUM
		DbSelectArea("SB1")
		DbSeek(xFilial("SC6")+SC6->C6_PRODUTO)
		
		/*
		BEGINDOC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³NCM'S que devem ser utilizadas para calculo do INSS sobre o faturameno³
		//Conforme informado pelo  do Sr. Eliel Contador em 08/2012
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ENDDOC
		*/
		if Alltrim(SB1->B1_POSIPI) $ ('85443000/85444200/85444900/87141000/87141900/90292010/90299010/85392910')
			InssFolha:="1"
		EndIf
		DbSelectArea("SB5")
		if (DbSeek(xFilial("SC6")+SC6->C6_PRODUTO)		)
			RecLock("SB5",.F.)
			SB5->B5_CODATIV:=SB1->B1_POSIPI
			SB5->B5_INSPAT:=InssFolha
			MsUnLock()
		Else
			RecLock("SB5",.T.)
			SB5->B5_FILIAL  := xFilial("SB5")
			SB5->B5_COD     := SB1->B1_COD
			SB5->B5_CEME    := SB1->B1_DESC
			SB5->B5_CODATIV := SB1->B1_POSIPI
			SB5->B5_INSPAT  := InssFolha
			MsUnLock()
			MsgAlert("Complemento de Produto: " +SB1->B1_COD +" Adcionado automaticamente."+chr(13)+"Favor atualizar os campos obrigatorios no Cadastro de Complemento.")
		Endif
		
	Else
		Exit
	EndIF
	InssFolha:="2"
	DbSelectArea("SC6")
	DbSkip()
EndDO
//
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
// EXCLUIR AS OCORRENCIAS DE FIFO QUANDO FOR ESTORNADA A LEITURA DE ETIQUETAS.
//
If INCLUI == .F. .AND. ALTERA == .F.

	cQuery  :=  " UPDATE " + RETSQLNAME("ZZ3") + " "
	cQuery  +=  " SET D_E_L_E_T_ = '*' "
	cQuery  +=  " WHERE ZZ3_FILIAL = '"+ xFilial("ZZ3") +"' "
	cQuery  +=  "   AND D_E_L_E_T_ <> '*' "
	cQuery  +=  "   AND ZZ3_ETIQ   = '"+ NumPed +"'"
	cQuery  +=  "   AND ZZ3_ORIGEM = 'SC6' "
	cQuery  +=  "   AND ZZ3_DTAUT  = '' "
	cQuery  +=  "   AND ZZ3_HRAUT  = '' "
	cQuery  +=  "   AND ZZ3_CODAUT = '' "
	TcSqlExec(cQuery)
	//
	SC5->(dbgotop())
	SC5->(dbgobottom())
	//
	MSGINFO("Ocorrencias de quebra de FIFO foram excluidas!","M410STTS")
Endif
//
// ******************** IMPLEMENTAÇÃO P/ OBRIGATORIEDADE DO FIFO ******************************
// EM: 19/08/2013 BY ALEX ALMEIDA
// ********************************************************************************************
//
Return


