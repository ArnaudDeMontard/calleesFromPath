  //Doa_commentsRemove (code_t) -> txt
  //$0 : code $1 sans commentaires 
  //  indentations conservées
  //  nombre de ligne en sortie inchangé (théoriquement, y'a bug…)
  //  mais à faire pour les comments v18 /* */

  //µ Arnaud * 10/09/2020 * debug regex commentaire monoligne, ajout à basicStuff
  //µ Arnaud * 15/08/2020 * adapté 4d version < v18
  //© Arnaud * 13/08/2020 21:02:54

C_TEXT($0)
C_TEXT($1)

  //C_OBJECT($out_o)
C_TEXT($code_t)

  //C_LONGINT($i_l)
C_TEXT($rx_t)
C_LONGINT($pos_l)
C_LONGINT($len_l)
  //ARRAY LONGINT($pos_al;0)
  //ARRAY LONGINT($len_al;0)

$code_t:=$1

  //commentaires monoligne //...
$rx_t:="  //([^\r]+)?\r"  //tout ce qui est entre "  //" et le 1er retour rencontré
  //#commentaire en fin de méthode non suivi de retour :
  // il faut peut-être ajouter "$" comme fin alternative
While (Match regex($rx_t;$code_t;1;$pos_l;$len_l))
	$code_t:=Delete string($code_t;$pos_l;$len_l-1)  //on laisse le retour
End while 

  //commentaires multilignes /* ... */
If ((Num(Application version)>=1800))  //pas avant la v18
	$rx_t:="/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/"  //celle-là, je risque pas de l'expliquer
	While (Match regex($rx_t;$code_t;1;$pos_l;$len_l))
		$code_t:=Delete string($code_t;$pos_l;$len_l)
	End while 
	  //#TODO remettre le nombre de retours supprimés pour préserver le nbre de lignes
End if 

ASSERT(Str_count ($1;"\r";"*")=Str_count ($code_t;"\r";"*");Current method name+" number of lines is changed!")

$0:=$code_t
