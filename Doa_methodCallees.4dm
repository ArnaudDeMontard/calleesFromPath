  //%attributes = {"lang":"en"} comment added and reserved by 4D.
  //Doa_methodCallees (chemin_t) -> obj
C_OBJECT:C1216($0;$out_o)
C_OBJECT:C1216($1;$in_o)

C_LONGINT:C283($i_l;$start_l;$pos_l;$len_l)

If (False:C215)  //exemples d'appel
	  //  //METHOD Get path ( typeMéthode {; laTable}{; nomObjet{; nomObjetForm}}{; *} ) 
	  //$chemint_t:="shiva_partagesWindowsVerif_srv"  //appel en partant d'une méthode
	  //$chemint_t:=METHOD Get path(Path database method;"onStartup")  //méthode base
	  //$chemint_t:=METHOD Get path(Path table form;[DSN_ETABLISSEMENT];"T51entree")  //méthode form
	  //$result_o:=Doa_methodesAppelees (New object("chemin";$chemint_t))
End if 

$out_o:=New object:C1471
$in_o:=$1

If ($in_o.recursif=Null:C1517)
	$in_o.recursif:=0
	  //Else 
	  //$in_o.recursif:=$in_o.recursif+1
End if 
If ($in_o.recursifMax=Null:C1517)
	$in_o.recursifMax:=3
End if 

$out_o.path:=$in_o.chemin
METHOD GET CODE:C1190($in_o.chemin;$code_t)
$rx:="\\\\\r\t{0,10}"  //ruptures ligne
$start_l:=1
While (Match regex:C1019($rx;$code_t;$start_l;$pos_l;$len_l))
	$code_t:=Substring:C12($code_t;1;$pos_l-1)+Substring:C12($code_t;$pos_l+$len_l)
End while 
  //$code_t:=xxDoa_codeClean ($code_t)
$code_t:=Doa_commentsRemove ($code_t)
SET TEXT TO PASTEBOARD:C523($code_t)
ARRAY TEXT:C222($nomMethode_at;0)
METHOD GET NAMES:C1166($nomMethode_at)
C_COLLECTION:C1488($nomMethode_c)
$nomMethode_c:=New collection:C1472
ARRAY TO COLLECTION:C1563($nomMethode_c;$nomMethode_at)

C_TEXT:C284($nomMethode_t)
  //C_TEXT($calleesLevel_t)
  //$calleesLevel_t:="callees_"+String($in_o.recursif)
$out_o.callees:=New collection:C1472()
For each ($nomMethode_t;$nomMethode_c)
	$rx:="\\b"+$nomMethode_t+" "  //toujours suivie d'un espace
	$start_l:=1
	While (Match regex:C1019($rx;$code_t;$start_l;$pos_l;$len_l))
		$indice_c:=$out_o.callees.indices("nomMethode =:1";$nomMethode_t)
		If ($indice_c.length>0)  //déjà trouvé dans la méthode
			$out_o.callees[$indice_c[0]].ligne:=\
				$out_o.callees[$indice_c[0]].ligne+\
				", "+\
				String:C10(Str_count ("\r";Substring:C12($code_t;1;$pos_l);"*"))
		Else   //trouvé pour la 1ère fois
			$out_o.callees.push(New object:C1471)
			$i_l:=$out_o.callees.length-1
			$out_o.callees[$i_l].path:=$nomMethode_t
			$out_o.callees[$i_l].ligne:=String:C10(Str_count ("\r";Substring:C12($code_t;1;$pos_l);"*"))
			If ($in_o.recursif<$in_o.recursifMax)
				$in_o.chemin:=$nomMethode_t
				$in_o.recursif:=$in_o.recursif+1
				$temp_o:=Doa_methodesAppelees ($in_o)
				If ($temp_o.callees#Null:C1517)
					$out_o.callees[$i_l].level:=$in_o.recursif
					$out_o.callees[$i_l].callees:=$temp_o.callees
				End if 
				$in_o.recursif:=$in_o.recursif-1
			End if 
			  //$out_o.callees.push($temp_o)
		End if 
		$start_l:=$pos_l+$len_l
	End while 
End for each 

If ($out_o.callees.length=0)
	OB REMOVE:C1226($out_o;"callees")
	$out_o:=Null:C1517
End if 

$0:=$out_o
