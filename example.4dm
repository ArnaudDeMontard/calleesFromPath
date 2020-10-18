
$chemint_t:="methodName"  //appel en partant d'une méthode
$result_o:=Doa_calleesFromPath (New object("path";$chemint_t))

$chemint_t:=METHOD Get path(Path database method;"onStartup")  //méthode base
$result_o:=Doa_calleesFromPath (New object("path";$chemint_t))

$chemint_t:=METHOD Get path(Path table form;[A_TABLE];"input")  //méthode form
$result_o:=Doa_calleesFromPath (New object("path";$chemint_t))
