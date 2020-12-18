#INCLUDE "URZUM.CH"

/*/{Protheus.doc} UZIMPPO
Impressão do PO
@author Armando
@since 21/07/2009
@version 1.0
@return ${return}, ${return_description}
@param xRl, , descricao
@param cxHtm, characters, descricao
@param xPc, , descricao
@type function
/*/
User Function UZIMPPO(xRl,cxHtm,xPc)

	Local oGrp    := Nil
	Local cPC     := Space(U_UZX3("C7_NUM","X3_TAMANHO"))
	Local nOpcao  := 0
	Private oDlgPO  := Nil

	If Empty(xPc)

		While .T.

			DEFINE MSDIALOG oDlgPO TITLE "Impressão de PO" From 1,1 to 100,240 of oMainWnd PIXEL

			oGrp  := TGroup():New( 5,5,38,80,"Seleção",oDlgPO,CLR_BLACK,CLR_WHITE,.T.,.F. )

			@ 17,10 SAY "Pedido" SIZE 30,7 PIXEL OF oDlgPO
			@ 17,32 MSGET cPC PICTURE "@!" VALID ExistCpo(cXAPC,cPC) F3 "X"+cXAPC SIZE 40,7 PIXEL OF oDlgPO

			DEFINE SBUTTON FROM 09,90 TYPE 19 OF oDlgPO ACTION (nOpcao:=1, oDlgPO:End()) ENABLE
			DEFINE SBUTTON FROM 27,90 TYPE 2  OF oDlgPO ACTION (nOpcao:=0, oDlgPO:End()) ENABLE

			ACTIVATE MSDIALOG oDlgPO CENTER

			If nOpcao == 1
				If Empty(Alltrim(cPc))
					MsgInfo("Numero do Pedido deve ser informado")
					Loop
				Else
					Processa({ || ImpresPC(xRl,cPC,cxHtm) })
					Exit
				EndIf
			Else
				Exit
			EndIf

		EndDo
	Else
		Processa({ || ImpresPC(xRl,xPc,cxHtm) })
	EndIf

Return

/*/{Protheus.doc} ImpresPC
Imprime PC
@author Armando M. Urzum
@since 01/07/2009
@version 1.0
@return ${return}, ${return_description}
@param xRl, , descricao
@param cxPC, characters, descricao
@param cxHtm, characters, descricao
@type function
/*/
Static Function ImpresPC(xRl,cxPC,cxHtm)

	Local bOk     := {||nOpcao:=1, oDlgPO:End() }
	Local bCancel := {||nOpcao:=0, oDlgPO:End() }
	Local aVetRel := {}
	Local aVetFim := {}
	Local aVetIts := {}
	Local aPosi   := {}
	Local aDir    := {}
	Local cRet    := ""
	Local cCodD	  := ""
	Local cDesc	  := ""
	Local cPC     := Space(U_UZX3("C7_NUM","X3_TAMANHO"))
	Local cMsg    := Space(3)
	Local nTot    := 0
	Local nOpcao  := 0
	Local oGrp    := Nil
	Local lxSeg   := GetMV("MV_XUZSEGU",.F.)

	Private oDlgPO:= Nil
	Private oObs  := Nil
	Private cObs  := &(cxAPC)->(&(cXIniPC+"OBS"))

	DEFINE MSDIALOG oDlgPO TITLE "Remarks" From 1,1 to 300,500 of oMainWnd PIXEL

	aPosi := U_UZTELA(oDlgPO,"TOT","BAR")

	oGrp  := TGroup():New( aPosi[1],aPosi[2]+=2,aPosi[3]-=2,aPosi[4]-=2,"Insira o texto",oDlgPO,CLR_BLACK,CLR_WHITE,.T.,.F. )

	@ aPosi[1]+=10,aPosi[2]+=5 GET oObs VAR cObs MEMO SIZE aPosi[4]-=13,(aPosi[3]-aPosi[1])-6 PIXEL OF oDlgPO

	ACTIVATE MSDIALOG oDlgPO ON INIT EnchoiceBar(oDlgPO,bOk,bCancel) Centered

	SC7->(dbSetOrder(1))
	SA1->(dbSetOrder(1))
	SA2->(dbSetOrder(1))
	SB1->(dbSetOrder(1))
	&(cXAPC)->(dbSetOrder(1))

	If SC7->(dbSeek(xFilial("SC7")+cxPC))
		aAdd(aVetRel,{"%cp.pedido%",cxPC})
		cRet := U_UzData(SC7->C7_EMISSAO,"DMESAING")
		aAdd(aVetRel,{"%cp.dtped%",cRet})

		If SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
			aAdd(aVetRel,{"%cp.nomeforn%",Alltrim(SA2->A2_NOME)})
			cRet := Alltrim(SA2->A2_END)+" - "
			cRet += Alltrim(SA2->A2_BAIRRO)+" - "
			cRet += Alltrim(SA2->A2_MUN)+" - "
			cRet += Alltrim(SA2->A2_CEP)+" - "
			cRet += Alltrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR"))
			aAdd(aVetRel,{"%cp.endforn%",Alltrim(cRet)})
		EndIf

		cMoedaUso := Alltrim(GetMV("MV_SIMB"+Alltrim(Str(SC7->C7_MOEDA))))

		While SC7->(!EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == (xFilial("SC7")+cxPC)

			//Busca da descrição em ingles do item
			If SB1->(FieldPos("B1_XDESIN")) > 0
				cCodD := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_XDESIN")
			EndIf

			cDesc := Iif(Empty(cCodD),Alltrim(SC7->C7_DESCRI),cCodD)

			aAdd(aVetIts,{"%it.item%",SC7->C7_ITEM})
			aAdd(aVetIts,{"%it.descr%",cDesc})
			aAdd(aVetIts,{"%it.ncm%"  ,Alltrim(TransForm(SC7->C7_XTEC,PIC_NCM))})
			If lxSeg .AND. !Empty(SC7->C7_SEGUM) .AND. !Empty(SC7->C7_QTSEGUM)
				aAdd(aVetIts,{"%it.qtde%" ,Alltrim(TransForm(SC7->C7_QTSEGUM,PIC12_2))})
				aAdd(aVetIts,{"%it.uni%"  ,Alltrim(SC7->C7_SEGUM)})
				aAdd(aVetIts,{"%it.preco%",Alltrim(TransForm(SC7->(C7_TOTAL/C7_QTSEGUM),PIC14_2))})
			Else
				aAdd(aVetIts,{"%it.qtde%" ,Alltrim(TransForm(SC7->C7_QUANT,PIC12_2))})
				aAdd(aVetIts,{"%it.uni%"  ,Alltrim(SC7->C7_UM)})
				aAdd(aVetIts,{"%it.preco%",Alltrim(TransForm(SC7->C7_PRECO,PIC14_2))})
			EndIf
			aAdd(aVetIts,{"%it.total%",Alltrim(TransForm(SC7->C7_TOTAL,PIC14_2))})
			nTot += SC7->C7_TOTAL
			SC7->(dbSkip())
		EndDo

	EndIf

	If &(cXAPC)->(dbSeek(xFilial(cXAPC)+cxPC))

		aEntImp := U_ENTISearch("01",Alltrim(cxPC),cXAPC) //VERIFICA IMPORTADOR
		If SA1->(dbSeek(xFilial("SA1")+aEntImp[1,1]+aEntImp[1,2] ))
			aAdd(aVetRel,{"%cp.nomeimp%",Alltrim(SA1->A1_NOME)})
			aAdd(aVetRel,{"%cp.imp2%",Alltrim(SA1->A1_END) })
			aAdd(aVetRel,{"%cp.imp3%",Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_CEP)  })
			aAdd(aVetRel,{"%cp.imp4%",Alltrim(SA1->A1_DDD)+" "+Alltrim(SA1->A1_TEL)  })
		EndIf

		aAdd(aVetRel,{"%cp.proform%",Alltrim(&(cxAPC)->(&(cXIniPC+"PROFOR")))  })
		cRet := U_UzData(&(cxAPC)->(&(cXIniPC+"DT_PRO")),"DMESAING")
		aAdd(aVetRel,{"%cp.dtpro%",cRet})
		cRet := Posicione(cXAC4,1,xFilial(cXAC4)+&(cxAPC)->(&(cXIniPC+"CONDPG")),cXIniC4+"DEINGL")
		aAdd(aVetRel,{"%cp.condpg%",Alltrim(cRet)})
		aAdd(aVetRel,{"%cp.incoterm%",Alltrim(&(cxAPC)->(&(cXIniPC+"INCOTE")))  })

		If &(cxAPC)->(&(cXIniPC+"TIPOVI")) 		== "01"
			cRet := "Sea"
		ElseIf &(cxAPC)->(&(cXIniPC+"TIPOVI")) 	== "04"
			cRet := "Air"
		ElseIf &(cxAPC)->(&(cXIniPC+"TIPOVI")) 	== "07"
			cRet := "Road"
		Else
			cRet := "Others"
	    EndIf

		aAdd(aVetRel,{"%cp.viatrans%",cRet})

		cRet := Alltrim(Posicione(cXAC5,1,xFilial(cXAC5)+&(cxAPC)->(&(cXIniPC+"DESTIN")),cXIniC5+"SIGLA"))+" - "
		cRet += Alltrim(Posicione(cXAC5,1,xFilial(cXAC5)+&(cxAPC)->(&(cXIniPC+"DESTIN")),cXIniC5+"DESCR"))
		aAdd(aVetRel,{"%cp.destino%",cRet})
		aAdd(aVetRel,{"%cp.moe%" ,cMoedaUso})

		aAdd(aVetFim,{"%rp.moe%" ,cMoedaUso})

		nTot += (&(cxAPC)->(&(cXIniPC+"PACKIN"))+&(cxAPC)->(&(cXIniPC+"INLAND"))+&(cxAPC)->(&(cXIniPC+"VLFRET")))-&(cxAPC)->(&(cXIniPC+"DESCON"))
		aAdd(aVetFim,{"%rp.total%" ,Alltrim(TransForm(nTot,PIC14_2))})
		aAdd(aVetFim,{"%rp.inland%",Alltrim(TransForm(&(cxAPC)->(&(cXIniPC+"INLAND")),PIC14_2))})
		aAdd(aVetFim,{"%rp.pack%"  ,Alltrim(TransForm(&(cxAPC)->(&(cXIniPC+"PACKIN")),PIC14_2))})
		aAdd(aVetFim,{"%rp.frete%" ,Alltrim(TransForm(&(cxAPC)->(&(cXIniPC+"VLFRET")),PIC14_2))})
		aAdd(aVetFim,{"%rp.descon%",Alltrim(TransForm(&(cxAPC)->(&(cXIniPC+"DESCON")),PIC14_2))})

		aAdd(aVetFim,{"%rp.obs%",StrTran(cObs,XENTER,"<br>")})

	EndIf

	For hj := 1 To Len(aVetIts)
		aAdd(aVetRel,aVetIts[hj])
	Next

	For hj := 1 To Len(aVetFim)
		aAdd(aVetRel,aVetFim[hj])
	Next

	aDir := U_UZXDIRARQ(xRl,xRl+"_PC"+Alltrim(cxPC))
	aSel := U_UzxEmImp()

	If !Empty(aDir[1]) .AND. !Empty(aDir[2])
		If U_UZXRELHTML(aVetRel,aDir[1],cxHtm,aDir[2],aSel[1]) .AND. aSel[2]
			cEmFrom  := U_UZXInfUser(1,14)
			cEmDes   := Alltrim(SA2->A2_EMAIL)
			cSubj    := "Purchase Order No.: "+cxPC+" - "+Alltrim(&(cXAC1)->(&(cXIniC1+"NOME")))
			cObs     := ""
			cTiti    := "Envio de Purchase Order"
			cArqEnv  := ""
			cArqUs   := Alltrim(aDir[1])+Alltrim(aDir[2])+".HTML"
			cBoby    := U_UzxGBody(cArqUs,"LOCAL")
			U_UZxEmail(.T.,cTiti,cEmFrom,cEmDes,"",cSubj,cObs,cBoby,cArqEnv,"LOCAL",.T.)
		EndIf
	EndIf

Return

//U_UZIMPPO("UZIMPPO.HTML")
