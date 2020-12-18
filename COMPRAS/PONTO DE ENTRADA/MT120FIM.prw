#include "rwmake.ch"
#include "TOPCONN.CH"

User function MT120FIM
    Local _nPosTran := aScan(aHeader, {|x| Alltrim(x[2]) == "C7_TRANSP" } )
    Local cTransp   := ""
    Local cQuery    := ""
    Local nx 

    for nx := 1 to len(aCols)
        if !Empty(aCols[ nx, _nPosTran])
            cTransp := aCols[ nx, _nPosTran]
        Endif
    next

    if !Empty(cTransp)
        cQuery  += " UPDATE " + RETSQLNAME("SC7") + " SET  C7_TRANSP= '"+cTransp+"' "
        cQuery  +=  " WHERE C7_NUM = '" + cA120Num + "'  AND "
        cQuery  +=  " D_E_L_E_T_ = ' ' AND C7_FILIAL = '" + XFILIAL("SC7") +  "'  "
        TcSqlExec(cQuery)
    Endif

return
