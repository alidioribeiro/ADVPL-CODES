#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.Ch"
#Include "TBICONN.CH"
//
//
********************************
User Function WFCTRL04()
********************************
Local aEnvia := {}
Local cProd,cMen
Local lRet := .T.
//
//Prepare Environment Empresa "01" Filial "01" Tables "ZZ6"  // Usado apenas quando o uso for por agendamento                                                         JJ
//
If day(ddatabase) <> 1
	conout('Não é dia 01 do mês')
	Return
Endif
//
dDataFim := dDatabase-1
dDataIni := CTOD('01/'+Str(month(dDataFim))+"/"+Str(year(dDataFim)))
//
dbSelectarea("ZZ6")
aStruZZ6 := ZZ6->(dbStruct())
//
cQuery := " "
cQuery += " SELECT ZZ6_OK=SPACE(02), * "
cQuery += " FROM "+RetSqlName("ZZ6")+" AS A "
cQuery += " WHERE A.D_E_L_E_T_<>'*' "
cQuery += " AND ZZ6_FILIAL   = '"+xFilial("ZZ6")+"' "
cQuery += " AND ZZ6_STATUS = 'T' "
cQuery += " AND ZZ6_DTAUT <> '' "
cQuery += " AND ZZ6_DTCQL <> '' "
cQuery += " AND (    (ZZ6_DTAUT >= ZZ6_DTCQL AND ZZ6_DTAUT BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"') "
cQuery += "       OR (ZZ6_DTCQL >= ZZ6_DTAUT AND ZZ6_DTCQL BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"') )
cQuery += " ORDER BY ZZ6_LOCAL, ZZ6_LOCDES, ZZ6_PRODUT, ZZ6_DTAUT, ZZ6_DTCQL "
TCQUERY cQuery NEW ALIAS "ZZ6WFT"
//
For nX := 1 To Len(aStruZZ6)
	If ( aStruZZ6[nX][2] <> "C" ) .And. FieldPos(aStruZZ6[nX][1]) > 0
		TcSetField("ZZ6WFT",aStruZZ6[nX][1],aStruZZ6[nX][2],aStruZZ6[nX][3],aStruZZ6[nX][4])
	EndIf
Next nX
//
nCusTot := 0
cTpDesc := ""
dbSelectArea("ZZ6WFT")
dbGoTop()
Do While ZZ6WFT->(!Eof())
	//
	nCusItem:= 0
	nCusLoc := 0
	cLocal  := ZZ6WFT->ZZ6_LOCAL
	Do While ZZ6WFT->(!Eof()) .AND. ZZ6WFT->ZZ6_LOCAL == cLocal
		//
		If 	   ZZ6WFT->ZZ6_TIPO	== 'R' //R=Refugo;S=Scrap;D=Devolucao;T=Retrabalho
			cTpDesc := "Refugo"
		Elseif ZZ6WFT->ZZ6_TIPO == 'S'
			cTpDesc := "Scrap"
		Elseif ZZ6WFT->ZZ6_TIPO == 'D'
			cTpDesc := "Devolucao"
		Elseif ZZ6WFT->ZZ6_TIPO == 'T'
			cTpDesc := "Retrabalho"
		Endif
		//
		nCusItem := 0
		aSaldo   := CalcEst(ZZ6WFT->ZZ6_PRODUT, ZZ6WFT->ZZ6_LOCORI, dDatabase+1)
		nCusItem += (ZZ6WFT->ZZ6_QUANT * (aSaldo[2]/aSaldo[1]))
		//
		aadd(aEnvia, {dToc(ZZ6WFT->ZZ6_DTRM)+" "+ZZ6WFT->ZZ6_HORA,;
						ZZ6WFT->ZZ6_NOMEUS,;
						cTpDesc,;
						ZZ6WFT->ZZ6_PRODUT,;
						Posicione("SB1",1,xFilial("SB1")+ZZ6WFT->ZZ6_PRODUT,"B1_DESC"),;
						ZZ6WFT->ZZ6_LOCALI,;
						ZZ6WFT->ZZ6_LOTECT,;
						Transform(ZZ6WFT->ZZ6_QUANT,"@E 9,999,999.99"),;
						Transform(nCusItem         ,"@E 9,999,999.99"),;
						ZZ6WFT->ZZ6_LOCAL,;
						ZZ6WFT->ZZ6_LOCDES,;
						ZZ6WFT->ZZ6_OP,;
						ZZ6WFT->ZZ6_NOMEAU,;
						ZZ6WFT->ZZ6_NOMCQL,;
						Posicione("ZZ2",1,xFilial("ZZ2")+ZZ6WFT->ZZ6_CODMOT,"ZZ2_DESCRI"),;
						"PRODUÇÃO: "+Alltrim(ZZ6WFT->ZZ6_OBSERV)+" C.Q.: "+Alltrim(ZZ6WFT->ZZ6_OBSCQL),;
						u_ZZ6ChkStatus(ZZ6WFT->ZZ6_STATUS) })
		//
		nCusLoc += nCusItem
		//
		ZZ6WFT->(dbSkip())
	Enddo
	nCusTot += nCusLoc
	If Len(aEnvia) > 0
		aadd(aEnvia, {"","","","","SUBTOTAL R$","","","",Transform(nCusLoc,"@E 9,999,999.99"),"","","","","","","",""})
	Endif
Enddo
If Len(aEnvia) > 0
	aadd(aEnvia, {"","","","","TOTAL GERAL R$","","","",Transform(nCusTot,"@E 9,999,999.99"),"","","","","","","",""})
Endif
ZZ6WFT->(dbClosearea())
//
If Len(aEnvia) > 0
	oProcess := TWFProcess():New( "000030", "WFCTRL04 - ITENS APROVADOS")
	oProcess :NewTask( "100030", "\WORKFLOW\WFCTRL04.HTM" )
	oProcess :cSubject := "WFCTRL04 - Monitoramento Mensal de Perdas no processo"
	oHTML    := oProcess:oHTML
	//
	//Qout("Entrou no Html")
	cMen := " <html>"
	cMen += " <body>"
	cMen += ' <table border="1" width="950">'
	cMen += ' <tr width="800" align="center" >'
	//   cMen += ' <TD ><IMG src="\\Nsbsrv01\CORREIO\Workflow\Imagens\LogoNSB.JPG"></TD>'
	cMen += ' <td colspan=15 >Relação de Lotes com apontamento de Perda aprovados no periodo '+dToc(dDataIni)+' a '+dToc(dDataFim)+' </td></tr>'
	cMen += ' <tr >'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Data    </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Usuario  </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Tipo    </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Produto  </Blink></font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Descricao</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>End.Orig.</Blink></font></td>'
	cMen += ' <td align="right"  width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Lote    </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Quant.  </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Cust.Tot.</Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Loc.Dest </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>End.Dest </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>  O.P.   </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Aut.Prd. </Blink></font></td>'
	cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Aut.C.Q. </Blink></font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Motivo  </Blink></font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>Observacao</Blink></font></td>'
	cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink> Status   </Blink></font></td>'
	cMen += ' </tr>'
	//
	//Qout("Len: "+Str(Len(aEnvia)))
	For x:= 1 to Len(aEnvia)
		cMen += ' <tr>'
		cMen += ' <td align="left"   width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,01] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,02] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,03] +'</Blink></font></td>'
		cMen += ' <td align="left"   width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,04] +'</Blink></font></td>'
		cMen += ' <td align="right"  width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,05] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,06] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,07] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,08] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,09] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,10] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,11] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,12] +'</Blink></font></td>'
		cMen += ' <td align="center" width="05%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,13] +'</Blink></font></td>'
		cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,14] +'</Blink></font></td>'
		cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,15] +'</Blink></font></td>'
		cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,16] +'</Blink></font></td>'
		cMen += ' <td align="center" width="15%" bgcolor="#FFFFFF"><font size="1" face="Times New Roman"><Blink>'+ aEnvia[x,17] +'</Blink></font></td>'
		cMen += ' </tr>'
	Next
	//
	cMen += ' </table>'
	cMen += " </body>"
	cMen += " </html>"
	//
	oHtml:ValByName("MENS", cMen)
	CodRot := "WFCTRL04"  //tabela ZWF
	Mto := u_MontaRec(CodRot)
	oProcess:cTo := Mto
	//oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
	cMailId := oProcess:Start()
	Qout("WFCTRL04 - E-mail enviado com sucesso!!!")
EndIf
//
Return(lRet)
