#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

User Function FINA01()        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�


SetPrvt("_NMODULO,_CCHAR,_NMULTINI,_NMULTFIM,_NMULT,_CSTR")
SetPrvt("_NI,_NREST,_NOSSONUM")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    � FINA01   � Autor � JORGE SILVEIRA        � Data � 15.03.01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � Geracao do Nosso Numero.                                   낢�
굇�          �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Gera豫o Nosso Numero"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("FINA01")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Esta rotina tem como objtivo, gerar o Nosso Numero, para controle"
@ 33,14 SAY "dos Boletos Bancario impressos pela NIPPON"
@ 43,14 SAY ""
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿚kProc    � Autor � JORGE SILVEIRA        � Data � 15.03.01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿎onfirma o Processamento                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  

Static Function OkProc()
Close(oDlg5)
Processa( {|| RunProc() } )
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝unProc   � Autor � JORGE SILVEIRA        � Data � 15.03.01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿐xecuta o Processamento                                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
Static Function RunProc()

// PARAMENTROS
// MV_PAR01            DO BORDERO
// MV_PAR02            ATE O BORDERO
// MV_PAR03            NOSSO NUMERO

dbSelectArea("SEA")
dbSetOrder(1)
ProcRegua(RecCount())

_NossoNum := Val(Mv_par03)
dbSeek(xFilial("SEA")+MV_Par01,.T.)
While !Eof() .And. EA_Numbor <= Mv_par02

      IncProc()
      
      dbSelectArea("SE1")
      dbSetOrder(1)
      dbSeek(xFilial("SE1")+SEA->EA_Prefixo+SEA->EA_Num+SEA->EA_Parcela+SEA->EA_Tipo)
          
      _nModulo  := 0
      _cChar    := ""
      _nMultIni := 2
      _nMultFim := 7
      _nMult    := _nMultIni
      _cStr     := "090320"+StrZero(_NossoNum,7)
      
      For _ni := Len(_cStr) to 1 Step -1
          _cChar   := Substr(_cStr,_ni,1)
          _nModulo := _nModulo + Val(_cChar)*_nMult
          _nMult   := Iif(_nMult==_nMultfim,2,_nMult+1)
      Next _ni

      _nRest := _nModulo % 11  
      _nRest := IIF(_nRest==0 ,"0",IIF(_nRest==1,"P",Str(11-_nRest,1)))
      
      RecLock("SE1",.F.)
      If SE1->E1_CLIENTE $ "000001/000002/000235"
         SE1->E1_NUMBCO := "00"
      Else
         SE1->E1_NUMBCO := Substr(_cStr,3,11) + _nRest
         _NossoNum := _NossoNum + 1
      EndIF   
      SE1->(MsUnlock())
            
      dbSelectArea("SEA")
      dbSkip()
EndDo

Return
/*
Static Function RunProc()

_nModulo  := 0
_cChar    := ""
_nMultIni := 2
_nMultFim := 7
_nMult    := _nMultIni
_cStr     := _NossoNum

For _ni := Len(_cStr) to 1 Step -1
   _cChar   := Substr(_cStr,_ni,1)
   _nModulo := _nModulo + Val(_cChar)*_nMult
   _nMult   := IIf(_nMult==_nMultfim,2,_nMult+1)
Next _ni

_nRest := _nModulo % 11
_nRest := IIF(_nRest==0 ,"0",IIF(_nRest==1,"P",Str(11-_nRest,1)))

Return(_nRest) 
*/
