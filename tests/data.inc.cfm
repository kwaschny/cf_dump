<cfset boolY = (0 lt 1)>
<cfset boolN = (0 gt 1)>

<cfset char = javaCast("char", "A")>

<cfset stringE = "">
<cfset stringF = repeatString("lorem ipsum dolor sit amet", 10)>

<cfset integer = javaCast("int", 0)>
<cfset long    = javaCast("long", 0)>
<cfset numeric = (0 + 0)>

<cfset componentA    = new assets.ComponentA( new assets.ComponentB() )>
<cfset componentB    = new assets.ComponentB( new assets.ComponentA() )>
<cfset componentDump = new assets.ComponentDump()>
<cfset object        = createObject("java", "java.lang.Object").init()>

<cfset queryE = queryNew("")>
<cfset queryC = queryNew("ColLeft,ColCenter,ColRight")>
<cfset queryF = queryNew("ColLeft,ColCenter,ColRight")>
<cfset queryAddRow(queryF, 2)>
<cfset querySetCell(queryF, "ColLeft",   boolY,   1)>
<cfset querySetCell(queryF, "ColCenter", stringE, 1)>
<cfset querySetCell(queryF, "ColRight",  integer, 1)>
<cfset querySetCell(queryF, "ColLeft",   boolN,   2)>
<cfset querySetCell(queryF, "ColCenter", stringF, 2)>
<cfset querySetCell(queryF, "ColRight",  numeric, 2)>

<cfset arrayE = []>
<cfset arrayX = createObject("java", "java.util.ArrayList").init()>

<cfset structE = {}>

<cfset xmlDoc = xmlParse('<!-- test --><root><parent count="3"><child>A</child><child attr="B" /><child>C</child></parent></root>')>

<cftry>
	<cfset void()>
	<cfcatch>
		<cfset exceptionCF = CFCATCH>
	</cfcatch>
</cftry>

<cftry>
	<cfthrow object="#createObject("java", "java.lang.Exception").init("This is a Java Exception.")#">
	<cfcatch>
		<cfset exceptionJava = CFCATCH>
	</cfcatch>
</cftry>

<cfset arrayF = [
	javaCast("null", ""),
	boolY,
	char,
	stringE,
	integer,
	long,
	numeric,
	componentA,
	object,
	queryE,
	arrayE,
	structE,
	xmlDoc,
	exceptionCF
]>
<cfset structF = {
	"null":      javaCast("null", ""),
	"bool":      boolN,
	"char":      char,
	"string":    stringF,
	"integer":   integer,
	"long":      long,
	"numeric":   numeric,
	"component": componentB,
	"object":    object,
	"query":     queryC,
	"array":     arrayE,
	"struct":    structE,
	"xml":       xmlDoc,
	"exception": exceptionCF
}>