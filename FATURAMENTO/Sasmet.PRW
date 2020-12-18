#include "rwmake.ch"

User Function SASMET()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ODLG,_CPERG,CARQTXT,NHDLARQ,CARQSE2")
SetPrvt("CKEYSE2,CFILSE2,NINDEX1,_CGRAVA,MES01,MES02")
SetPrvt("MES03,MES04,MES05,MES06,MES07,MES08")
SetPrvt("MES09,MES10,MES11,MES12,XTGFOR,XFORNEC")
SetPrvt("XLOJA,XMES,XANO,XTOTVAL,XTOTIRF,XVAL01")
SetPrvt("XVAL02,XVALOR,XIRRF,XDED,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JSOXEXP  ³ Autor ³ Jorge Silveira        ³ Data ³ 13.05.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao de arquivos magneticos para J-SOX.                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RDMAKE Sasmet -X                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Revisoes  ³ 1a. Revisao - 21/05/2009                                   ³±±
±±³          ³ Ajuste na Tabela 01 - Produtos. Foram incluidos os campos: ³±±
±±³          ³                  01 - Saldo em Estoque                     ³±±
±±³          ³                  02 - Saldo de Fechamento                  ³±±
±±³          ³                  03 - Data da Ultima Compra                ³±±
±±³Revisoes  ³ 2a. Revisao - 26/05/2009                                   ³±±
±±³          ³ Ajuste na Tabela 06 - Dev. Compras. Foram incl. os campos: ³±±
±±³          ³                  01 - N.Fiscal de Origem                   ³±±
±±³          ³                  02 - Serie da N.Fiscal de Origem          ³±±
±±³          ³                  03 - Inclusao do Status "BX. PARCIAL"     ³±±
±±³Revisoes  ³ 3a. Revisao - 12/08/2009                                   ³±±
±±³          ³ Ajuste na Tabela 08 - Nota Fiscal de Veendas               ³±±
±±³          ³                  01 - D2_CF - CFOP                         ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Perguntas ( SOXEXP )
// ------------------------------------------------
// Data Inicial                mv_par01    D  8
// Data Final                  mv_par02    D  8
// 01) Cad. de Fornecedores    mv_par03    N  1   0
// 02) Cad. de Produtos        mv_par04    N  1   0   
// 03) Cad. de Servicos        mv_par05    N  1   0
// 04) Pedido de Compras       mv_par06    N  1   0
// 05) N.F. de Compras         mv_par07    N  1   0
// 06) Dev. de Compras (NDF)   mv_par08    N  1   0
// 07) Cad. de Clientes        mv_par09    N  1   0
// 08) N.F. de Vendas          mv_par10    N  1   0
// 09) Titulos Aberto (CP)     mv_par11    N  1   0
// 10) Titulos Baixados (CP)   mv_par12    N  1   0
// 11) Titulos Aberto (CR)     mv_par11    N  1   0
// 12) Titulos Baixados (CR)   mv_par12    N  1   0
// 13) Cad. de Itens           mv_par15    N  1   0
// 14) Mov. de Estoque         mv_par16    N  1   0
// ------------------------------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDlg   := ""
_cPerg     := "SASMET"
Pergunte(_cPerg, .F.)

@ 96,13 To 310,592 DIALOG oDlg TITLE "Geracao de Arquivos Magneticos para  Sasmet "
@ 06,6 To 66,284
@ 13,15 SAY OemToAnsi("Este programa tem como objetivo gerar os arquivos magneticos para Sasmet.")
@ 23,15 SAY OemToAnsi("Conforme Lay Out fornecido pela Auditoria da Sasmet . Crie o diretorio C:\SASMET\ ")
                                      
@ 090,185 BUTTON "Exportar" SIZE 34,11 ACTION TabExp()
@ 090,225 BMPBUTTON TYPE 5             ACTION Pergunte(_cPerg)
@ 090,260 BMPBUTTON TYPE 2             ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TabExp   ³ Autor ³ Jorge S.da Silva      ³ Data ³ 19/02/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Processamento.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TabExp()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TabExp()

// Close(oDlg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nome e Diretorio dos Arquivos que devem ser gravados.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        
cArqTxt := ""
xSeq    := 0
//If Mv_par01 == 1
     cArqTxt := "C:\SASMET\FUNCIONA"
     Processa( { || GerTab01() }, "01)Dados dos Funcionarios.")
//End      	

Return

***************************
Static Function GerTab01() // 01) Fornecedores
***************************

 _cGrava  := ""
 cArqTxt := "C:\SASMET\FUNCIONA.TXT"
 nHdlArqFun := FCreate(cArqTxt)

 cArqTxt := "C:\SASMET\SETOR.TXT"
 nHdlArqSet := FCreate(cArqTxt)

 cArqTxt := "C:\SASMET\FUNCAO.TXT"
 nHdlArqF := FCreate(cArqTxt)


 _CCusto:={}
 _CFunc :={}
 dbSelectArea("SRA")
 dbSetOrder(1)

 ProcRegua(RecCount())
 dbGoTop()        
 
 While !Eof()

      IncProc("Exportando Tabelas dos Funcionários...")
      If Empty(SRA->RA_DEMISSA) .and. Val(RA_MAT)<=800000
         //Verifica se já existe a ocorrência do CCusto
       _cGrava:=AjuTam(RA_MAT,8)		
	   _cGrava+=AjuTam(RA_NOME,172)   
       _cGrava+=RA_SEXO 				
 	   _cGrava+=StodCust(RA_NASC)      
	   _cGrava+=StodCust(RA_ADMISSA)	
	   _cGrava+=AjuTam(RA_CODFUNC,4)   
	   _cGrava+=StodCust(RA_ADMISSA)	
	   _cGrava+=AjuTam(RA_CC,24)	
	   _cGrava+=AjuTam(RA_RG,73)	
	   _cGrava+=StodCust(RA_DTRGEXP)	
       _DescOrg:=Posicione("SX5",1,xFilial("SX5")+'64'+RA_RGORG,"X5_DESCRI")
	   _cGrava+=AjuTam(_DescOrg,50)
       _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
       FWrite( nHdlArqFun ,_cGrava,Len(_cGrava))
       If AScan(_CCusto,{|x|x=RA_CC})=0
             AAdd(_CCusto,RA_CC)
       End                     
       If AScan(_CFunc,{|x|x=RA_CODFUNC})=0
            AAdd(_CFunc,RA_CodFunc)
       End                     

	EndIF		
    DbSelectArea("SRA")
    dbSkip()
     
 EndDo

 FClose(nHdlArqFun)   

 DbSelectArea("CTT")
 DbSetOrder(1)

 For i:=1 to Len(_CCusto)
    If DbSeek(xFilial("CTT")+_CCusto[i])
	  _cGrava :=SUBSTR(CTT_CUSTO,1,9)							//		TAMANHO TOTAL		461	
      _cGrava +=SUBSTR(CTT_DESC01,1,50)
      _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
      FWrite( nHdlArqSet ,_cGrava,Len(_cGrava))
    EndIf
 Next 
                                    
 FClose(nHdlArqSet)    

 DbSelectArea("SRJ")
 DbSetOrder(1)

 For i:=1 to Len(_CFunc)
    If DbSeek(xFilial("SRJ")+_CFunc[i])
	  _cGrava :=SUBSTR(RJ_FUNCAO,1,4)							//		TAMANHO TOTAL		461	
      _cGrava +=SUBSTR(RJ_DESC,1,25)
      _cGrava := _cGrava + Chr(13) + Chr(10)                      // Caracteres de Fim de Linha
      FWrite( nHdlArqF ,_cGrava,Len(_cGrava))
    EndIf
 Next 
                                    
 FClose(nHdlArqF)    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim de geração das Tabelas.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsgBox ("Tabelas geradas com sucesso!","Informaçäo","INFO")
Return

Return Nil

Static Function TiraCarac(cCarac)
   Local cRet := cCarac, nTam := Len(cCarac)
   
   cRet := StrTran(cRet,"-","")
   cRet := StrTran(cRet,"/","")
   cRet := StrTran(cRet,".","")
   cRet := StrTran(cRet,"(","")
   cRet := StrTran(cRet,")","")
   cRet := cRet + Space(nTam - Len(cRet))

Return(cRet)

Static Function RetCampo(cCampo,nTam)
   Local cRet
   
   cRet := SubStr(AllTrim(cCampo),1,nTam)
   cRet := cRet + Space(nTam-Len(cRet))

Return(cRet)

Static Function RetNum(nCampo,nTam,nDec)
   Local cRet
   
   cRet := StrZero(nCampo * If(nDec==Nil,1,10**nDec),nTam)

Return(cRet)

Static Function StodCust(cData)
   Local dRet
   xRet := DtoS(cData)
   dRet := SubStr(xRet,7,2)+"/"+SubStr(xRet,5,2)+"/"+SubStr(xRet,1,4)

Return(dRet)         

Static Function AjuTam(Campo,QtdC)
Local cCampo

if Len(Alltrim(Campo))<QtdC
	CampoAj:=Alltrim(Campo)+Replicate(" ",QtdC-len(alltrim(campo)))
Else
	CampoAj:=Substr(Campo,1,QtdC)	
EndIf

Return CampoAj 

