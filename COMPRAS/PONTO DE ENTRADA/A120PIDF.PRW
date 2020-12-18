/*BEGINDOC
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁPonto de Entrada executado no filtro das solicitacoes  Ё
//ЁDesenvolvedor : Rodovaldo                              Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ENDDOC*/
USER FUNCTION A120PIDF
cFilSC1   := {'C1_FILIAL == "'+xFilial('SC1')+'".And. C1_QUJE < C1_QUANT .And. C1_TPOP<>"P" .And. C1_APROV$"S,L" .And.( C1_COTACAO == "'+Space(Len(SC1->C1_COTACAO))+'" .Or. C1_COTACAO == "'+Replicate("X",Len(SC1->C1_COTACAO))+'")'+IIF(SC1->(FieldPos("C1_FLAGGCT"))>0.And.nTipoPed!=2,' .And. ((SC1->C1_QUJE > 0 .And. SC1->C1_FLAGGCT == " ") .Or. (SC1->C1_QUJE == 0 ))','')}
RETURN ({},cFilSC1)