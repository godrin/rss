// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showDiv(id) {
	var e;
	e=document.getElementById(id);
	e.style.display = "block";
}
function hideDiv(id) {
	var e;
	e=document.getElementById(id);
	e.style.display = "none";
}

function toggleParentsChildren(which) {
	var i;
	var elements;
	var name;
	elements = ["children", "parents"];
	for(i=0;i<elements.length;i+=1) {
		name=elements[i];
		if(which==name) {
			showDiv(name);
		} else {
			hideDiv(name);
		}
	}
}