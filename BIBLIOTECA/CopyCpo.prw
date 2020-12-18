#INCLUDE "RWMAKE.CH"


User Function CopyCpo(_cAlias, _cCodigo)

If n > 1	
	If _cAlias == "SC7" .AND. Alltrim(Posicione("SB1",1,xFilial("SB1")+_cCodigo,"B1_GRUPO")) == "MPI"
	
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "C7_DTEMBAR"}) ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "C7_DTCHEGA"}) ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "C7_DATPRF"})  ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		
	ElseIf _cAlias == "SD1"  .AND. Alltrim(Posicione("SB1",1,xFilial("SB1")+_cCodigo,"B1_GRUPO")) == "MPI"
	
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_INVOICE"}) ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_DI"})      ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_BL"})      ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_TX"})      ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_DATADI"})  ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]
		nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_DATADES"}) ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]

		If aCols[n, ascan(aHeader, {|x| Alltrim(x[2]) == "D1_COD"})] == _cCodigo
			nPosCpo := ascan(aHeader, {|x| Alltrim(x[2]) == "D1_FABRIC"}) ; aCols[n, nPosCpo] := aCols[n - 1, nPosCpo]		
		Endif
		
	Endif
Endif
Return(_cCodigo)
