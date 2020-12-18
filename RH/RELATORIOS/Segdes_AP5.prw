#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function SegDesem()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CTIT,CDESC1,CDESC2,CDESC3,CSTRING,CALIAS")
SetPrvt("AORD,WNREL,CPERG,CFILANTE,LEND,LFIRST")
SetPrvt("ARETURN,AINFO,NLASTKEY,NSALARIO,NSALHORA,NSALDIA")
SetPrvt("NSALMES,AREGS,NORDEM,CFILDE,CFILATE,CMATDE")
SetPrvt("CMATATE,CCCDE,CCCATE,NVIAS,DDTBASE,CVERBAS")
SetPrvt("DDEMIDE,DDEMIATE,CNOME,CEND,CCEP,CUF")
SetPrvt("CFONE,CMAE,CTPINSC,CCGC,CCNAE,CPIS")
SetPrvt("CCTPS,CCTSERIE,CCTUF,CCBO,COCUP,DADMISSAO")
SetPrvt("DDEMISSAO,CSEXO,DNASCIM,CHRSEMANA,CMAT,CFIL")
SetPrvt("CCC,CNMESES,C6SALARIOS,CINDENIZ,CGRINSTRU,DDTULTSAL")
SetPrvt("DDTPENSAL,DDTANTSAL,CTIPO,CVALOR,NVALULT,NVALPEN")
SetPrvt("NVALANT,AVALSAL,NLUGAR,NVALULTSAL,NVALPENSAL,NVALANTSAL")
SetPrvt("NX,SALMES,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==> #INCLUDE 'SEGDES.CH'
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � SegDes   � Autor � R.H. - Fernando Joly  � Data � 10.10.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Requerimento de Seguro-Desemprego - S.D.                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Clientes MicroSiga                         ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Aldo        �10/09/97�xxxxxx�Acerto nos valores dos tres ult.aumentos. ���
���Cristina    �02/06/98�xxxxxx�Conversao para outros idiomas.            ���
���Fernando J. �30/06/98�14205a�Inclusao da fun��o fSomaAcl para a soma   ���
���            �        �      �de verbas do acumulado dos 3 �ltimos      ���
���            �        �      �meses ao Salario.                         ���
���Kleber      �24/09/98�XXXXXX�Criada um novo grupo de perguntas(SEGDES).���
���Kleber      �07/10/98�XXXXXX�Acerto do acumulados de verbas.           ���
���Kleber      �19/02/99�XXXXXX�Na perg GPR30A Imprimir uma via do Form.  ���
���Mauro       �05/07/99�17893a�Apos Impress�o posicionar SRA no Inicio.  ���
���Kleber      �02/08/99�18632b�Alt.Param. Ano (p/4dig.) Funcao FSomaACL. ���
���Marina      �13/12/99�23656a�Acerto data/salario dos 3 ultimos meses de���
���            �        �      �acordo com a data de admissao.            ���
���Marina      �14/12/99�24546a�Acerto do campo grau de instrucao de acor-���
���            �        �      �do com a tabela de INSS(1 a 9).           ���
���Marina      �15/12/99�XXXXXX�Inclusao dos parametros Data Demissao De e���
���            �        �      �Data Demissao Ate.                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
cTit     :=  ' REQUERIMENTO DE SEGURO-DESEMPREGO - S.D. '
cDesc1   :=  'Requerimento de Seguro-Desemprego - S.D.'
cDesc2   :=  'Ser� impresso de acordo com os parametros solicitados pelo'
cDesc3   :=  'usuario.'
cString  := 'SRA'
cAlias   := 'SRA'
aOrd     := {'Matricula','Centro de Custo'}
WnRel    := 'SEGDES'
cPerg    := 'SEGDES'                    
cFilAnte := '��'
lEnd     := .F.
lFirst   := .T.
aReturn  := { 'Zebrado',1,'Administracao',2,2,1,'',1 }	
aInfo    := {}
nLastKey := 0
nSalario := 0 
nSalHora := 0
nSalDia  := 0
nSalMes  := 0
aRegs    := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/XF3
aAdd(aRegs,{cPerg,'10', 'Data Demissao De   ?', 'mv_cha', 'D', 8,	0, 0, 'G', 'naovazio', 'mv_par10', '', '01/01/99', '', '', '', '', '', '', '', '', '', '', '', '', ''})
aAdd(aRegs,{cPerg,'11', 'Data Demissao Ate  ?', 'mv_chb', 'D', 8,	0, 0, 'G', 'naovazio', 'mv_par11', '', '30/12/99 ', '', '', '', '', '', '', '', '', '', '', '', '', ''})

ValidPerg(aRegs,cPerg)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte('SEGDES',.F.)
   
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  FiLial De                                �
//� mv_par02        //  FiLial Ate                               �
//� mv_par03        //  Matricula De                             �
//� mv_par04        //  Matricula Ate                            �
//� mv_par05        //  Centro De Custo De                       �
//� mv_par06        //  Centro De Custo Ate                      �
//� mv_par07        //  N� de Vias                               �
//� mv_par08        //  Data Base                                �
//� mv_par09        //  Verbas a serem somadas ao Salario        �
//� mv_par10        //  Data Demissao De                         �
//� mv_par11        //  Data Demissao Ate                        �
//����������������������������������������������������������������
   
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,'P')

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem  := aReturn[8]
cFilDe  := If(!Empty(mv_par01), mv_par01 ,'00')
cFilAte := If(!Empty(mv_par02), mv_par02 ,'99')
cMatDe  := If(!Empty(mv_par03), mv_par03,'00000')
cMatAte := If(!Empty(mv_par04), mv_par04,'99999')
cCCDe   := If(!Empty(mv_par05), mv_par05,'0        ')
cCCAte  := If(!Empty(mv_par06), mv_par06,'999999999')
nVias   := If(!Empty(mv_par07), If(mv_par07<=0,1,mv_par07),1)
dDtBase := If(!Empty(mv_par08), If(Empty(mv_par08),dDataBase,mv_par08),dDataBase)
cVerbas := mv_par09
dDemiDe  := If(!Empty(mv_par10), mv_par10 ,'01/01/99')
dDemiAte := If(!Empty(mv_par11), mv_par11 ,'30/12/99')
   
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| fSegDes()})// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> 	RptStatus({|| Execute(fSegDes)})
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> 	Function fSegDes
Static Function fSegDes()
#ENDIF

dbSelectArea('SRA')
dbSetOrder(nOrdem)
SetRegua(RecCount())

Do While !Eof()	
	//��������������������������������������������������������������Ŀ
	//� Incrementa Regua de Processamento.                           �
	//����������������������������������������������������������������
	IncRegua()

	//��������������������������������������������������������������Ŀ
	//� Processa Quebra de Filial.                                   �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL #cFilAnte
		If	!fInfo(@aInfo,SRA->RA_FILIAL)
			dbSkip(1)
			Loop
		Endif		
		cFilAnte := SRA->RA_FILIAL		
	Endif		
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impres�o ao se pressionar <ALT> + <A>.               �
	//����������������������������������������������������������������
	#IFNDEF WINDOWS
		Inkey()
		If Lastkey() == 286
			lEnd := .T.
		EndIf	
	#ENDIF        
	If lEnd
		@ pRow()+ 1, 00 PSAY ' CANCELADO PELO OPERADOR . . . '
		Exit
	EndIF
	
	//��������������������������������������������������������������Ŀ
	//� Consiste Parametriza��o do Intervalo de Impress�o.           �
	//����������������������������������������������������������������
	If (SRA->RA_Filial < cFilDe) .Or. (SRA->RA_FILIAL > cFilAte)
		SRA->(dbSkip())
		Loop
	EndIf	
	If	(SRA->RA_MAT < cMatDe) .Or. (SRA->RA_MAT > cMatAte)
		SRA->(dbSkip())
		Loop
	EndIf		
	If	(SRA->RA_CC < cCcDe) .Or. (SRA->RA_CC > cCCAte) 
		SRA->(dbSkip())
		Loop
	EndIf
	If	(SRA->RA_DEMISSA < dDemiDe) .Or. (SRA->RA_DEMISSA > dDemiAte) 
		SRA->(dbSkip())
		Loop
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Utiliza somente funcionarios Excluidos ou Demitidos.         �
	//����������������������������������������������������������������
	If !SRA->RA_SitFolha $ 'D�E'
		dbSkip(1)
		Loop
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas na impressao.                           �
	//����������������������������������������������������������������
	cNome      := Left(SRA->RA_Nome,30)
	cEnd       := AllTrim(Left(SRA->RA_Endereco,30)) + ' ' + AllTrim(Left(SRA->RA_Complem,15)) + ' , ' + AllTrim(Left(SRA->RA_Bairro,15))
	cEnd       := cEnd + Space(60-Len(cEnd))				  
	cCep       := Transform(Left(SRA->RA_Cep,8),'@R #####-###')	
	cUF        := Left(SRA->RA_Estado,2)
	cFone      := Left(SRA->RA_Telefon,8)
	cMae       := Left(SRA->RA_Mae,40)
	cTpInsc    := If(aInfo[15]==1,'2','1') //-- 1=C.G.C. 2=C.E.I.
	cCgc       := Transform(Left(aInfo[8],14),If(cTpInsc=='1','@R ##.###.###/####-##','@R '))
	cCNAE      := Left(aInfo[16],5)
	cPis       := Left(SRA->RA_Pis,11)
	cCTPS      := Left(SRA->RA_NumCp,7)
	cCTSerie   := Left(SRA->RA_SerCp,5)		
	cCTUF      := Left(SRA->RA_UFCP,2)
	cCBO       := Left(SRA->RA_CBO,5)
	cOcup      := DescFun(SRA->RA_CodFunc,SRA->RA_Filial)
	dAdmissao  := SRA->RA_Admissa
	dDemissao  := SRA->RA_Demissa
	cSexo      := If(Sra->RA_Sexo=='M','1','2')
	dNascim    := SRA->RA_Nasc
	cHrSemana  := StrZero(Int(SRA->RA_HrSeman),2)
	cMat       := Left(SRA->RA_Mat,6)
	cFil       := Left(SRA->RA_Filial,2)
	cCC        := Left(SRA->RA_CC,9)
	If Val(SRA->RA_MesTrab)> 0
		cNMeses    := If(Val(SRA->RA_MesTrab)<=36,Left(SRA->RA_MesTrab,2),'36')
	Else
		cNMeses    := INT((SRA->RA_DEMISSA-SRA->RA_ADMISSA)/30)
		cNMeses    := If(cNMeses<=36,StrZero(cNMeses,2),'36')
	Endif
	c6Salarios := If(Val(cNMeses)+SRA->RA_MesesAnt>=6,'1','2')
	
	//��������������������������������������������������������������Ŀ
	//� Pesquisando o Tipo de Rescisao ( Indenizada ou nao )         �
	//����������������������������������������������������������������
	cAlias := Alias()
	dbSelectArea('SRG')
	If dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.)
		cIndeniz   := fPHist82(SRA->RA_Filial,'32',SRG->RG_TipoRes,32,1)
	Else
		cIndeniz   := ' '	
	EndIf
	dbSelectArea(cAlias)

	If cIndeniz == "I"
	   cIndeniz := "1"
	Else
	   cIndeniz := "2"
	Endif
	
	//
	cGrInstru := "1"
	If SRA->RA_GRINRAI == "10"
		cGrInstru := "1"
	Elseif SRA->RA_GRINRAI == "20"
		cGrInstru := "2"					
	Elseif SRA->RA_GRINRAI == "25"
		cGrInstru := "3"					
	Elseif SRA->RA_GRINRAI == "30"
		cGrInstru := "4"					
	Elseif SRA->RA_GRINRAI == "35"
		cGrInstru := "5"					
	Elseif SRA->RA_GRINRAI == "40"
		cGrInstru := "6"					
	Elseif SRA->RA_GRINRAI == "45"
		cGrInstru := "7"					
	Elseif SRA->RA_GRINRAI == "50"
		cGrInstru := "8"					
	Else
		cGrInstru := "9"					
	Endif

	//��������������������������������������������������������������Ŀ
	//� Pesquisando os Tres Ultimos Salarios ( Datas e Valores )     �
	//����������������������������������������������������������������	
	//-- Data do Ultimo Salario.
	dDTUltSal := dDemissao

	//-- Data do Penultimo Salario.
	dDTPenSal := If(Month(dDemissao)-1#0,CtoD(StrZero(Day(dDemissao),2)+'/'+StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD(StrZero(Day(dDemissao),2)+'/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )
	If MesAno(dDtPenSal) < MesAno(dAdmissao)
	  dDTPenSal := CTOD("  /  /  ")
   Endif

	//-- Data do Antepenultimo Salario.	
	dDTAntSal := If(Month(dDtPenSal)-1#0,CtoD(StrZero(Day(dDtPenSal),2)+'/'+StrZero(Month(dDtPenSal)-1,2)+'/'+Right(StrZero(Year(dDtPenSal),4),2)),CtoD(StrZero(Day(dDtPenSal),2)+'/12/'+Right(StrZero(Year(dDtPenSal)-1,4),2)) )	
	If MesAno(dDtAntSal) < MesAno(dAdmissao)
	  dDTAntSal := CTOD("  /  /  ")
   Endif
	
	cTipo   := "A"
	cValor  := SRA->RA_SALARIO
	nSalario:= 0

	fCalcSal()
	
	nValUlt := 0
	nValPen := 0
	nValAnt := 0
	fSomaAcl(StrZero(Year(dDTUltSal),4), StrZero(Month(dDTUltSal),2), cVerbas, @nValUlt)
	If !Empty(dDTPenSal)
		fSomaAcl(StrZero(Year(dDTPenSal),4), StrZero(Month(dDTPenSal),2), cVerbas, @nValPen)
	Endif
	If !Empty(dDTAntSal)
		fSomaAcl(StrZero(Year(dDTAntSal),4), StrZero(Month(dDTAntSal),2), cVerbas, @nValAnt)
	Endif
	
	aValSal:={}
	Aadd(aValSal,{Right(StrZero(Year(dDTUltSal),4),2)+StrZero(Month(dDTUltSal),2) ,nSalario+nValUlt,"A"})
	If !Empty(dDTPenSal)
		Aadd(aValSal,{Right(StrZero(Year(dDTPenSal),4),2)+StrZero(Month(dDTPenSal),2) ,nSalario+nValPen," "})
	Endif
	If !Empty(dDTAntSal)
		Aadd(aValSal,{Right(StrZero(Year(dDTAntSal),4),2)+StrZero(Month(dDTAntSal),2) ,nSalario+nValAnt," "})
	Endif
	
	cAlias := Alias()
	dbSelectArea('SR3')	
	dbSeek(SRA->RA_Filial+SRA->RA_Mat,.f.)
	While !Eof() .And. SRA->RA_Filial+SRA->RA_Mat == SR3->R3_Filial+SR3->R3_Mat
		nLugar:=aScan(aValSal,{ |x| x[1] == Right(StrZero(Year(SR3->R3_DATA),4),2)+StrZero(Month(SR3->R3_DATA),2)} )
		cValor  := SR3->R3_VALOR
		fCalcSal()
		If nLugar > 0
			If nLugar == 1 
			   aValSal[nLugar,2] := nSalario + nValUlt
			ElseIf nLugar == 2
			   aValSal[nLugar,2] := nSalario + nValPen
			ElseIf nLugar == 3
			   aValSal[nLugar,2] := nSalario + nValAnt
			EndIf
		Endif
		dbSkip()
	EndDo	

	nValUltSal := aValSal[1,2]	
	If Len(aValSal) >= 2
		nValPenSal := aValSal[2,2]
	Else 
	   nValPenSal := 0
	Endif
	If Len(aValSal) >= 3
		nValAntSal := aValSal[3,2]
	Else 
	   nValAntSal := 0
	Endif

	dbSelectArea(cAlias)

	//��������������������������������������������������������������Ŀ
	//�** Inicio da Impressao do Requerimento de Seguro-Desemprego **�
	//����������������������������������������������������������������	
	For Nx := 1 to nVias
		fImpSeg()
		If lFirst .And. aReturn[5] == 2
			Pergunte("GPR30A",.T.)
			If mv_Par01 == 2
				Nx := 0
			Else
				lFirst := .F.
			EndIf
		EndIf
	Next Nx

	//��������������������������������������������������������������Ŀ
	//�** Final  da Impressao do Requerimento de Seguro-Desemprego **�
	//����������������������������������������������������������������
	dbSkip()	

EndDo	

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio.                                        �
//����������������������������������������������������������������
dbSelectArea( 'SRA' )
RetIndex('SRA')
dbSetOrder(1)   
dbGoTop()
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(WnRel)
Endif

MS_Flush()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fImpSeg  � Autor � Kleber D. Gomes       � Data � 19.02.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Requerimento de Seguro-Desemprego             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fImpSeg()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> Function fImpSeg
Static Function fImpSeg()

//��������������������������������������������������������������Ŀ
//�** Inicio da Impressao do Requerimento de Seguro-Desemprego **�
//����������������������������������������������������������������	
@ 10, 09 PSAY cNome
@ 13, 09 PSAY cEnd 
@ 16, 09 PSAY Space(35) + cCep + Space(12) + cUF
@ 19, 09 PSAY cMae 
@ 22, 09 PSAY Space(08) + cTpInsc + Space(5) + cCgc + Space(12) + cCNAE
@ 25, 09 PSAY cPIS + Space(13) + cCTPS + Space(5) + cCTSerie + Space(5) + cCTUF
@ 28 ,09 PSAY cCBO + Space(6) + cOcup
@ 33, 09 PSAY StrZero(Day(dAdmissao),2) + Space(3) + StrZero(Month(dAdmissao),2) + Space(2) + Right(StrZero(Year(dAdmissao),4),2) + Space(5) + StrZero(Day(dDemissao),2) + Space(3) + StrZero(Month(dDemissao),2) + Space(2) + Right(StrZero(Year(dDemissao),4),2) + Space(13) + cSexo + Space(4) + Chr(15) + Space(1) + cGrInstru+Space(9) + StrZero(Day(dNascim),2) + Space(3) + StrZero(Month(dNascim),2) + Space(2) + Right(StrZero(Year(dNascim),4),2) + Space(5) + cHrSemana
@ 36, 09 PSAY StrZero(Month(dDtAntSal),2) + Space(7) + Transform(nValAntSal,'@E 999,999,999.99') + Space(3) + StrZero(Month(dDtPenSal),2) + Space(7) + Transform(nValPenSal,'@E 999,999,999.99') + Space(3) + StrZero(Month(dDtUltSal),2) + Space(7) + Transform(nValUltSal,'@E 999,999,999.99')
@ 39, 09 PSAY Space(6) + Transform(nValAntSal+nValPenSal+nValUltSal,'@E 999,999,999.99')
@ 42, 09 PSAY Space(26) + cNMeses + Space(26) + c6Salarios + Space(25) + cIndeniz  	
@ 63, 09 PSAY cPis
@ 66, 09 PSAY cNome		
@ 79, 00 PSAY ' '
SetPrc(0,0)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fCalcSal � Autor � Mauro                 � Data � 29.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Salario Dia Hora e Mes                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fSalario(Salario,Salhora,Saldia,Salmes,Tipo)               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Codigo = Codigo da Verba que deseja                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> Function fCalcSal
Static Function fCalcSal()

If SRA->RA_TIPOPGT == "M" .And. SRA->RA_CATFUNC $ "M�C"
	SalMes  := cValor
ElseIf SRA->RA_TIPOPGT == "S" .And. SRA->RA_CATFUNC $ "S�T"
	SalMes  := cValor / 7 * 30
ElseIf SRA->RA_CATFUNC $ "H�T"
	SalMes  := cValor * If(cTipo #Nil .And. cTipo == "A",SRA->RA_HRSMES,(Normal + Descanso))
ElseIf SRA->RA_CATFUNC $ "D"
	SalMes  := ( cValor * 30 )
EndIf

nSalario  := SalMes

Return
