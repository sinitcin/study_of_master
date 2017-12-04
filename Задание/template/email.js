function email() { // try to avoid spam trollers, intentionally complex
	var a = "john.";
	var b = "smith";
	var c = "@exam";
	var d = "ple.com";
	
	e_string = "<a href=\"ma" + "ilto:" + a + b + c + d + "\">" + a + b + c + d + "</a>";
	document.write(e_string);
}
