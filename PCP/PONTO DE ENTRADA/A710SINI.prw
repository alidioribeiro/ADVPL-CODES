#Include "rwmake.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ A710SINI   ¦ Wermeson Gadelha do Canto    ¦ Data ¦ 21/04/2017             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para modificar o saldo em estoque no MRP                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A710SINI()
 Local cArea       := GetArea()
 Local cwProd      := ParamIxb[1]
 Local nwEst       := ParamIxb[2]

  	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(xFilial("SB2") + cwProd + "21"))
		nwEst := nwEst + SB2->B2_QATU
	EndIf 
	
	RestArea(cArea)
	                	
Return (nwEst)

/************************************************************************************
*        AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*       AAAA       LL         LL         EE         CC        KK    KK   SS         *
*      AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*     AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*    AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*   AA        AA   LL         LL         EE         CC        KK    KK          SS  *
*  AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
***********************************************************************************-*
*         I want to change the world, but nobody gives me the source code!          *
*************************************************************************************/