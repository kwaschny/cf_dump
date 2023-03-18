<cfsetting enableCFoutputOnly="true">

<cfset TEST_MAIL = "">

<cfif not len(TEST_MAIL)>
	<cfoutput>Set variable <code>TEST_MAIL</code> and try again.</cfoutput>
	<cfexit>
</cfif>

<cfinclude template="data.inc.cfm">

<cfmail from="#TEST_MAIL#" to="#TEST_MAIL#" subject="Testing cf_dumpmail" type="html">

	<h1>Array</h1>
	<cf_dumpmail var="#arrayF#">

	<h1>Struct</h1>
	<cf_dumpmail var="#structF#">

	<h1>Query</h1>
	<cf_dumpmail label="Custom Label" var="#queryF#">

	<h1>Exception</h1>
	<cf_dumpmail var="#exceptionCF#">

</cfmail>

<cfoutput>SENT #now()#</cfoutput>