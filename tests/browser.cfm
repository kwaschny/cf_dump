﻿<cfsetting enableCFoutputOnly="true">

<cfinclude template="data.inc.cfm">

<cfoutput>

	<!DOCTYPE html>
	<style>

		body {
			background-color: ##404040;
			color: ##FFFFFF;
			font-family: sans-serif;
			padding-bottom: 64px;
		}

		h1:first-child {
			color: ##FFFF00;
		}

	</style>

	<h1>&lt;cf_dump&gt;</h1>

	<h1>single dump</h1>

		<h2>null</h2>
		<cf_dump>

		<h2>bool</h2>
		<cf_dump var="#boolY#">
		<cf_dump var="#boolN#">

		<h2>char</h2>
		<cf_dump var="#char#"> <!--- LDEV-3598 --->

		<h2>string</h2>
		<cf_dump var="#stringE#">
		<cf_dump var="#stringF#">
		<cf_dump var="a¢฿𝄞">
		<!---
			(assuming UTF-8)
			a = 1 Byte  (1 char)
			¢ = 2 Bytes (1 char)
			฿ = 3 Bytes (1 char)
			𝄞 = 4 Bytes (2 chars)
		--->

		<h2>integer/long/numeric</h2>
		<cf_dump var="#integer#">
		<cf_dump var="#long#">
		<cf_dump var="#numeric#">

		<h2>array</h2>
		<cf_dump var="#arrayE#">
		<cf_dump var="#arrayX#">
		<cf_dump var="#arrayF#">

		<h2>struct</h2>
		<cf_dump var="#structE#">
		<cf_dump var="#structF#">

		<h2>xml</h2>
		<cf_dump var="#xmlDoc#">

		<h2>query</h2>
		<cf_dump var="#queryE#">
		<cf_dump var="#queryC#">
		<cf_dump var="#queryF#">

		<h2>component</h2>
		<cf_dump var="#componentA#">
		<cf_dump var="#[ componentA, componentA ]#">

		<cf_dump var="#componentB#">
		<cf_dump var="#[ componentB, componentB ]#">

		<h2>component dump()</h2>
		<cf_dump var="#componentDump#">
		<cf_dump var="#[ componentDump ]#">

		<h2>object</h2>
		<cf_dump var="#object#">
		<cf_dump var="#[ object, object ]#">

	<h1>exception dump</h1>

		<cf_dump var="#exceptionCF#">
		<cf_dump var="#exceptionJava#">

	<h1>circular dump</h1>

		<!--- struct circle --->
		<cfset x   = {}>
		<cfset y   = { x: x }>
		<cfset z   = { x: x, y: y }>
		<cfset x.z = z>
		<cf_dump var="#x#">

		<!--- array circle --->
		<cfif SERVER.ColdFusion.ProductName neq "Lucee"> <!--- [LDEV-3333] --->

			<cfset x = createObject("java", "java.util.ArrayList").init()>
			<cfset y = createObject("java", "java.util.ArrayList").init()>
			<cfset z = createObject("java", "java.util.ArrayList").init()>
			<cfset y.add(x)>
			<cfset z.add(x)>
			<cfset z.add(y)>
			<cfset x.add(z)>
			<cf_dump var="#x#">

		</cfif>

	<h1>label</h1>

		<cf_dump label="I am label">

	<h1>top</h1>

		<cfset x = {
			x1: {
				x2: {
					x3: {}
				}
			}
		}>

		<h2>struct</h2>
		<cf_dump top="2" var="#x#">

		<cfset y = [
			[
				[
					[
						[],
						41,
						42,
						43,
						44
					],
					31,
					32,
					33
				],
				21,
				22
			],
			11
		]>

		<h2>array</h2>
		<cf_dump top="2" var="#y#">

		<cfset z = queryNew("A,B")>
		<cfset queryAddRow(z, 4)>
		<cfset querySetCell(z, "A", "A1", 1)>
		<cfset querySetCell(z, "B", "B1", 1)>
		<cfset querySetCell(z, "A", "A2", 2)>
		<cfset querySetCell(z, "B", "B2", 2)>
		<cfset querySetCell(z, "A", "A3", 3)>
		<cfset querySetCell(z, "B", "B3", 3)>
		<cfset querySetCell(z, "A", "A4", 4)>
		<cfset querySetCell(z, "B", "B4", 4)>

		<h2>query</h2>
		<cf_dump top="2" var="#z#">

	<h1>break long strings</h1>

		<cf_dump var="#repeatString("W", 1000)#">

	<h1>embed</h1>

		<cf_dump embed var="embed style/script">

	<h1>pre</h1>

		<cfset s = arrayToList([
			"spaces: 2  3   END",
			"tabs: 1#chr(9)#2#chr(9)##chr(9)#3#chr(9)##chr(9)##chr(9)#END",
			"newline: 1#chr(13)##chr(10)#2#chr(13)##chr(10)##chr(13)##chr(10)#3#chr(13)##chr(10)##chr(13)##chr(10)##chr(13)##chr(10)#END"
		], chr(10))>

		<cf_dump pre var="#s#">

	<h1>wsWarning</h1>

		<!--- blank keys --->
		<cf_dump var="#{ "": { " ": " " } }#">

		<!--- ASCII excerpt --->
		<cf_dump var="#chr(9)#x">           <!--- horizontal tab --->
		<cf_dump var="x#chr(13)##chr(10)#"> <!--- carriage return --->
		<cf_dump var="#chr(32)#">           <!--- space --->

		<!--- Unicode excerpt --->
		<cf_dump var="#chr(160)##chr(32)#x">    <!--- non-breaking space --->
		<cf_dump var="x#chr(173)#">             <!--- soft hyphen --->
		<cf_dump var="#chr(8194)#x#chr(8195)#"> <!--- en/em space --->
		<cf_dump var="x#chr(8232)#">            <!--- line separator --->
		<cf_dump var="x#chr(8233)#">            <!--- paragraph separator --->

		<!--- Emoji --->
		<cf_dump var="😃">
		<cf_dump var=" 😃">
		<cf_dump var="😃 ">
		<cf_dump var=" 😃 ">
		<cf_dump var="😃 😃">
		<cf_dump var=" 😃 😃 ">
		<cf_dump var="#{ " 😃 ": " 😃 " }#">

		<h2>key only</h2>
		<cf_dump wsWarning="key" var="#{ " 😃 ": " 😃 " }#">

		<h2>value only</h2>
		<cf_dump wsWarning="value" var="#{ " 😃 ": " 😃 " }#">

		<h2>no warning</h2>
		<cf_dump wsWarning="false" var=" | ">
		<cf_dump wsWarning="false" var="#{ " 😃 ": " 😃 " }#">

	<h1>blacklist</h1>

		<cf_dump blacklist="#[ "a", "B" ]#" var="#{ A: 1, "b": 2, c: 3 }#">
		<cf_dump blacklist="publicVarA,REFERENCE" var="#[ componentA, componentB ]#">

		<h2>empty</h2>
		<cf_dump blacklist var="#{ A: 1, "b": 2, c: 3 }#">

	<h1>byteEncoding</h1>

		<cfset bytesCP1252 = binaryDecode("61E480", "HEX")> <!--- aä€ --->
		<cfset bytesUTF8   = binaryDecode("61C3A4E282ACF09F9889", "HEX")> <!--- aä€😉 --->
		<cfset bytesUTF16  = binaryDecode("006100E420ACD83DDE09", "HEX")> <!--- aä€😉 --->

		<h2>CP1252</h2>
		<cf_dump byteEncoding="#[ "CP1252" ]#" var="#bytesCP1252#">

		<h2>UTF-8</h2>
		<cf_dump var="#bytesUTF8#">

		<h2>UTF-16</h2>
		<cf_dump byteEncoding="UTF-16" var="#bytesUTF16#">

		<h2>No Encoding</h2>
		<cf_dump byteEncoding var="#bytesUTF8#">

	<h1>abort / reset</h1>

		<cf_dump abort>

		<cfthrow message="[abort] attribute DID NOT WORK">

</cfoutput>
