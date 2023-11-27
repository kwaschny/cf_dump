<cfsetting enableCFoutputOnly="true">

<cfif (
	(not structKeyExists(VARIABLES, "THISTAG")) or
	(THISTAG.executionMode neq "start")
)>
	<cfsetting enableCFoutputOnly="false"><cfexit>
</cfif>

<cfset VARIABLES.isLucee = structKeyExists(SERVER, "lucee")>

<!--- BEGIN: attributes --->

	<!--- abort --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "abort")) and
		structKeyExists(REQUEST, "__cf_dump_abort") and
		isBoolean(REQUEST["__cf_dump_abort"])
	)>
		<cfset ATTRIBUTES.abort = REQUEST["__cf_dump_abort"]>
	</cfif>
	<cfparam name="ATTRIBUTES.abort" type="boolean" default="false">

	<!--- blacklist --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "blacklist")) and
		structKeyExists(REQUEST, "__cf_dump_blacklist")
	)>
		<cfset ATTRIBUTES.blacklist = REQUEST["__cf_dump_blacklist"]>
	</cfif>
	<cfparam name="ATTRIBUTES.blacklist" type="any" default="">
	<cfif isBoolean(ATTRIBUTES.blacklist)>
		<cfset ATTRIBUTES.blacklist = []>
	</cfif>
	<cfif isSimpleValue(ATTRIBUTES.blacklist)>
		<cfset ATTRIBUTES.blacklist = listToArray(ATTRIBUTES.blacklist)>
	</cfif>
	<cfif not isArray(ATTRIBUTES.blacklist)>
		<cfset ATTRIBUTES.blacklist = []>
	</cfif>

	<!--- byteEncoding --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "byteEncoding")) and
		structKeyExists(REQUEST, "__cf_dump_byteEncoding")
	)>
		<cfset ATTRIBUTES.byteEncoding = REQUEST["__cf_dump_byteEncoding"]>
	</cfif>
	<cfparam name="ATTRIBUTES.byteEncoding" type="any" default="#[ "UTF-8" ]#">
	<cfif isBoolean(ATTRIBUTES.byteEncoding)>
		<cfset ATTRIBUTES.byteEncoding = []>
	</cfif>
	<cfif isSimpleValue(ATTRIBUTES.byteEncoding)>
		<cfset ATTRIBUTES.byteEncoding = listToArray(ATTRIBUTES.byteEncoding)>
	</cfif>
	<cfif not isArray(ATTRIBUTES.byteEncoding)>
		<cfset ATTRIBUTES.byteEncoding = []>
	</cfif>

	<!--- label --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "label")) and
		structKeyExists(REQUEST, "__cf_dump_label") and
		isSimpleValue(REQUEST["__cf_dump_label"])
	)>
		<cfset ATTRIBUTES.label = REQUEST["__cf_dump_label"]>
	</cfif>
	<cfparam name="ATTRIBUTES.label" type="string" default="">

	<!--- pre --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "pre")) and
		structKeyExists(REQUEST, "__cf_dump_pre") and
		isBoolean(REQUEST["__cf_dump_pre"])
	)>
		<cfset ATTRIBUTES.pre = REQUEST["__cf_dump_pre"]>
	</cfif>
	<cfparam name="ATTRIBUTES.pre" type="boolean" default="false">

	<!--- reset --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "reset")) and
		structKeyExists(REQUEST, "__cf_dump_reset") and
		isBoolean(REQUEST["__cf_dump_reset"])
	)>
		<cfset ATTRIBUTES.reset = REQUEST["__cf_dump_reset"]>
	</cfif>
	<cfparam name="ATTRIBUTES.reset" type="boolean" default="false">

	<!--- top --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "top")) and
		structKeyExists(REQUEST, "__cf_dump_top") and
		isNumeric(REQUEST["__cf_dump_top"])
	)>
		<cfset ATTRIBUTES.top = REQUEST["__cf_dump_top"]>
	</cfif>
	<cfparam name="ATTRIBUTES.top" type="numeric" default="-1">

	<!--- BEGIN: wsWarning --->

		<cfif (
			(not structKeyExists(ATTRIBUTES, "wsWarning")) and
			structKeyExists(REQUEST, "__cf_dump_wsWarning") and
			isSimpleValue(REQUEST["__cf_dump_wsWarning"])
		)>
			<cfset ATTRIBUTES.wsWarning = REQUEST["__cf_dump_wsWarning"]>
		</cfif>
		<cfparam name="ATTRIBUTES.wsWarning" type="string" default="true">

		<cfset VARIABLES.wsInspectKey = false>
		<cfset VARIABLES.wsInspectVal = false>

		<cfif ATTRIBUTES.wsWarning contains "key">
			<cfset VARIABLES.wsInspectKey = true>
		</cfif>
		<cfif ATTRIBUTES.wsWarning contains "value">
			<cfset VARIABLES.wsInspectVal = true>
		</cfif>
		<cfif isBoolean(ATTRIBUTES.wsWarning) and ATTRIBUTES.wsWarning>
			<cfset VARIABLES.wsInspectKey = true>
			<cfset VARIABLES.wsInspectVal = true>
		</cfif>

	<!--- END: wsWarning --->

<!--- END: attributes --->

<cfset VARIABLES.System = createObject("java", "java.lang.System")>
<cfset VARIABLES.String = createObject("java", "java.lang.String")>

<!--- track already resolved variables to prevent infinite recursion --->
<cfset VARIABLES.resolvedVars = {}>

<cfif ATTRIBUTES.reset>
	<cfcontent reset="true">
</cfif>

<cfsavecontent variable="VARIABLES.output">
	<cfoutput>

		<div style="background-color: ##FFFFFF; border-spacing: 0; box-sizing: border-box; color: ##000000; display: table; font-family: 'Segoe UI', sans-serif; font-size: 14px; margin-bottom: 8px; margin-top: 8px;">

			<cfif len(ATTRIBUTES.label)>
				<div style="background-color: ##E91E63; box-sizing: border-box; color: ##FFFFFF; font-size: inherit; padding: 4px;">
					#encodeForHtml(ATTRIBUTES.label)#
				</div>
			</cfif>

			<cfif structKeyExists(ATTRIBUTES, "var")>
				#renderDump(ATTRIBUTES.var)#
			<cfelse>
				#renderDump()#
			</cfif>

		</div>

	</cfoutput>
</cfsavecontent>

<cfoutput>#trimOutput(VARIABLES.output, ATTRIBUTES.pre)#</cfoutput>

<cfif ATTRIBUTES.abort>
	<cfsetting enableCFoutputOnly="false"><cfabort>
</cfif>

<cffunction name="renderDump" accessor="private" output="true" returnType="void">

	<cfargument name="var"   type="any"     required="false">
	<cfargument name="depth" type="numeric" default="-1">

	<cfset ARGUMENTS.depth++>

	<cfoutput>

		<!--- null --->
		<cfif (
			(not structKeyExists(ARGUMENTS, "var")) or
			isNull(ARGUMENTS.var)
		)>

			<cfset LOCAL.cssDeepColor = "##000000">
			<cfset LOCAL.cssForeColor = "##FFFFFF">

			<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; font-size: inherit; width: 100%; white-space: nowrap;">
				<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
					<span style="font-weight: bold;">null</span>
				</div>
				<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
					<div style="border: 1px solid; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
						[undefined]
					</div>
				</div>
			</div>

		<!--- simple --->
		<cfelseif isSimpleValue(ARGUMENTS.var)>

			<cfset LOCAL.rawType = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.type    = LOCAL.rawType>
			<cfset LOCAL.subType = "">

			<cfset LOCAL.cssDeepColor = "##FF4444">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssInline    = "">
			<cfset LOCAL.showAlert    = false>

			<cfswitch expression="#LOCAL.type#">

				<cfcase value="java.lang.Boolean">

					<cfset LOCAL.type         = "boolean">
					<cfset LOCAL.cssDeepColor = "##673AB7">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

					<cfset ARGUMENTS.var = ( ARGUMENTS.var ? "true" : "false" )>

				</cfcase>

				<cfcase value="java.lang.Byte">

					<cfset LOCAL.type         = "byte">
					<cfset LOCAL.subType      = "HEX">
					<cfset LOCAL.cssDeepColor = "##FFCC44">
					<cfset LOCAL.cssForeColor = "##000000">

					<cfset ARGUMENTS.var = VARIABLES.String.format("%02X", [ ARGUMENTS.var ])>

				</cfcase>

				<cfcase value="java.lang.Double">

					<cfset LOCAL.type         = "numeric">
					<cfset LOCAL.subType      = "double">
					<cfset LOCAL.cssDeepColor = "##2196F3">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfcase>

				<cfcase value="java.lang.String">

					<cfset LOCAL.len = len(ARGUMENTS.var)>
					<cfset LOCAL.cps = ARGUMENTS.var.codePointCount(0, LOCAL.len)>

					<cfif LOCAL.len eq LOCAL.cps>
						<cfset LOCAL.type = "string [#LOCAL.len#]">
					<cfelse>
						<cfset LOCAL.type = "string [chars: #LOCAL.len#, codepoints: #LOCAL.cps#]">
					</cfif>

					<cfset LOCAL.cssDeepColor = "##FF8000">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

					<cfif LOCAL.len>

						<!--- whitespace warning --->
						<cfif (
							(not ATTRIBUTES.pre) and
							VARIABLES.wsInspectVal
						)>

							<cfset LOCAL.val = replaceWS(ARGUMENTS.var)>

							<cfif not isNull(LOCAL.val)>

								<cfset LOCAL.showAlert = true>

								<cfset ARGUMENTS.var = LOCAL.val>

							</cfif>

						</cfif>

					<cfelse>

						<cfset LOCAL.cssInline = "color: ##A0A0A0; white-space: nowrap;">
						<cfset ARGUMENTS.var   = "[empty string]">

					</cfif>

				</cfcase>

				<cfcase value="java.lang.Integer">

					<cfset LOCAL.type         = "numeric">
					<cfset LOCAL.subType      = "integer">
					<cfset LOCAL.cssDeepColor = "##2196F3">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfcase>

				<cfcase value="java.lang.Long">

					<cfset LOCAL.type         = "numeric">
					<cfset LOCAL.subType      = "long">
					<cfset LOCAL.cssDeepColor = "##2196F3">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfcase>

			</cfswitch>

			<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%; #LOCAL.cssInline#">
				<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
					<cfif LOCAL.showAlert>⚠️</cfif>
					<span style="font-weight: bold;">#encodeForHtml(LOCAL.type)#</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span>
				</div>
				<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
					<div style="border: 1px solid; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top; #( (LOCAL.rawType eq "java.lang.String") ? "word-break: break-all;" : "" )# #( LOCAL.showAlert ? "color: ##F00000; font-family: Consolas, monospace; letter-spacing: 1px;" : "" )#">
						<cfif ATTRIBUTES.pre>
							<pre style="margin: 0"><cfif VARIABLES.isLucee>#encodeForHtml(ARGUMENTS.var)#<cfelse>#htmlEditFormat(ARGUMENTS.var)#</cfif></pre>
						<cfelse>
							<cfif VARIABLES.isLucee>
								#encodeForHtml(ARGUMENTS.var)#
							<cfelse>
								#htmlEditFormat(ARGUMENTS.var)#
							</cfif>
						</cfif>
					</div>
				</div>
			</div>

		<!--- array --->
		<cfelseif isArray(ARGUMENTS.var)>

			<cfset LOCAL.cssDeepColor = "##009900">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##CCFFCC">

			<cfset LOCAL.subType  = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = arrayLen(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">array</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%; white-space: nowrap;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">array [0]</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							[empty array]
						</div>
					</div>
				</div>

			<cfelse>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">

					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">array [#LOCAL.len#]</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
					</div>

					<!--- Byte[] --->
					<cfif LOCAL.subType eq "[B">

						<cfloop array="#ATTRIBUTES.byteEncoding#" index="LOCAL.encoding">

							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									#encodeForHtml( replace(uCase(LOCAL.encoding), "-", "‑", "ALL") )# <!--- force non-breaking hyphen --->
								</div>
								<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top;">
									<div style="box-sizing: border-box;">
										<cftry>
											#charsetEncode(ARGUMENTS.var, LOCAL.encoding)#
											<cfcatch>
												[encoding failed]
											</cfcatch>
										</cftry>
									</div>
								</div>
							</div>

						</cfloop>

					</cfif>

					<cfloop from="1" to="#LOCAL.len#" index="LOCAL.i">

						<!--- top (maximum elements) --->
						<cfif (ATTRIBUTES.top gte 0) and (LOCAL.i gt ATTRIBUTES.top)>

							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									#LOCAL.i#
								</div>
								<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top;">
									<div style="box-sizing: border-box;">
										[top reached]
									</div>
								</div>
							</div>

							<cfbreak>

						</cfif>

						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								#LOCAL.i#
							</div>
							<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
								<cfif arrayIsDefined(ARGUMENTS.var, LOCAL.i)>
									#renderDump(ARGUMENTS.var[LOCAL.i], ARGUMENTS.depth)#
								<cfelse>
									#renderDump()#
								</cfif>
							</div>
						</div>

						<cfset LOCAL.i++>
					</cfloop>

				</div>

			</cfif>

		<!--- component, object --->
		<cfelseif isObject(ARGUMENTS.var)>

			<cfset LOCAL.meta     = getMetaData(ARGUMENTS.var)>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>

			<!--- component --->
			<cfif (
				structKeyExists(LOCAL.meta, "Type") and
				(LOCAL.meta.Type eq "component")
			)>

				<cfset LOCAL.cssDeepColor = "##1C434A">
				<cfset LOCAL.cssForeColor = "##B6DCE3">
				<cfset LOCAL.cssSoftColor = "##B6DCE3">

				<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

					<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%;">
						<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
							<span style="font-weight: bold;">component</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.meta.FullName)#</span>
						</div>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
								[references @#encodeForHtml(LOCAL.identity)#]
							</div>
						</div>
					</div>

				<cfelse>

					<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.meta.FullName>

					<!--- extends --->
					<cfset LOCAL.extends = "">
					<cfif structKeyExists(LOCAL.meta, "extends")>

						<!--- ignore default inheritance --->
						<cfif (
							(LOCAL.meta.extends.FullName does not contain "cftags.component") and
							(LOCAL.meta.extends.FullName does not contain "lucee.Component")
						)>
							<cfset LOCAL.extends = LOCAL.meta.extends.FullName>
						</cfif>

					</cfif>

					<!--- implements --->
					<cfset LOCAL.implements = []>
					<cfif structKeyExists(LOCAL.meta, "implements")>

						<cfloop collection="#LOCAL.meta.implements#" item="LOCAL.key">
							<cfset LOCAL.implements.add(LOCAL.meta.implements[LOCAL.key].FullName)>
						</cfloop>
						<cfset arraySort(LOCAL.implements, "TEXTnoCASE", "ASC")>

					</cfif>

					<!--- BEGIN: public fields --->

						<cfset LOCAL.publicFields = []>

						<cfloop collection="#ARGUMENTS.var#" item="LOCAL.field">

							<!--- skip functions --->
							<cfif isCustomFunction(ARGUMENTS.var[LOCAL.field])>
								<cfcontinue>
							</cfif>

							<cfset LOCAL.publicFields.add(LOCAL.field)>

						</cfloop>
						<cfset arraySort(LOCAL.publicFields, "TEXTnoCASE", "ASC")>

					<!--- END: public fields --->

					<!--- BEGIN: private fields --->

						<cfset LOCAL.privateFields = []>

						<cfif (
							structKeyExists(ARGUMENTS.var, "dump") and
							isCustomFunction(ARGUMENTS.var.dump)
						)>

							<cfset LOCAL.privateScope = ARGUMENTS.var.dump()>

							<cfloop collection="#LOCAL.privateScope#" item="LOCAL.field">

								<cfif not structKeyExists(LOCAL.privateScope, LOCAL.field)>
									<cfcontinue>
								</cfif>

								<!--- skip functions --->
								<cfif isCustomFunction(LOCAL.privateScope[LOCAL.field])>
									<cfcontinue>
								</cfif>

								<cfset LOCAL.privateFields.add(LOCAL.field)>

							</cfloop>
							<cfset arraySort(LOCAL.privateFields, "TEXTnoCASE", "ASC")>

						</cfif>

					<!--- END: private fields --->

					<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">

						<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
							<span style="font-weight: bold;">component</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.meta.FullName)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span><br>
							<cfif len(LOCAL.extends)>
								<span style="margin-left: 7px;"><span style="color: ##FFFFFF;">extends</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.extends)#</span></span><br>
							</cfif>
							<cfloop array="#LOCAL.implements#" index="LOCAL.className">
								<span style="margin-left: 15px;"><span style="color: ##FFFFFF;">implements</span> <span style="font-size: 9px;">#encodeForHtml(className)#</span></span><br>
							</cfloop>
						</div>

						<cfloop array="#LOCAL.publicFields#" index="LOCAL.field">

							<!--- skip fields starting with an underscore --->
							<cfif find("_", LOCAL.field) eq 1>
								<cfcontinue>
							</cfif>

							<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.field)>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = ARGUMENTS.var[LOCAL.field]>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										<cfif isNull(LOCAL.element)>
											#renderDump()#
										<cfelse>
											#renderDump(LOCAL.element, ARGUMENTS.depth)#
										</cfif>
									</div>
								</div>

							</cfif>

						</cfloop>

						<cfloop array="#LOCAL.privateFields#" index="LOCAL.field">

							<!--- skip fields starting with an underscore --->
							<cfif find("_", LOCAL.field) eq 1>
								<cfcontinue>
							</cfif>

							<!--- skip public scope --->
							<cfif LOCAL.field eq "THIS">
								<cfcontinue>
							</cfif>

							<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.field)>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										<span>👁&nbsp;#encodeForHtml(LOCAL.field)#</span>
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = LOCAL.privateScope[LOCAL.field]>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										<span>👁&nbsp;#encodeForHtml(LOCAL.field)#</span>
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										#renderDump(LOCAL.element, ARGUMENTS.depth)#
									</div>
								</div>

							</cfif>

						</cfloop>

					</div>

				</cfif>

			<!--- object --->
			<cfelse>

				<cfset LOCAL.cssDeepColor = "##FF4444">
				<cfset LOCAL.cssForeColor = "##FFFFFF">
				<cfset LOCAL.cssSoftColor = "##FFDBDB">

				<cfset LOCAL.meta    = ARGUMENTS.var.getClass()>
				<cfset LOCAL.subType = getClassName(ARGUMENTS.var)>

				<cfset LOCAL.docsLink = "">
				<cfif find("java.", LOCAL.subType) eq 1>
					<cfset LOCAL.docsLink = "https://docs.oracle.com/en/java/javase/11/docs/api/java.base/#replace(LOCAL.subType, ".", "/", "ALL")#.html">
				</cfif>

				<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

					<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%;">
						<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
							<cfif len(LOCAL.docsLink)>
								<span style="font-weight: bold;">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" style="color: inherit; font-size: 9px; text-decoration: none;">#encodeForHtml(LOCAL.subType)#</a>
							<cfelse>
								<span style="font-weight: bold;">object</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span>
							</cfif>
						</div>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; font-family: Consolas, monospace; padding: 2px; vertical-align: top;">
								[references @#encodeForHtml(LOCAL.identity)#]
							</div>
						</div>
					</div>

				<cfelse>

					<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

					<!--- check for exception instance (ColdFusion) --->
					<cfif (
						(find("coldfusion", LOCAL.subType) eq 1) and
						isInstanceOf(ARGUMENTS.var, "coldfusion.runtime.NeoException")
					)>

						<cfset LOCAL.cssDeepColor = "##000000">
						<cfset LOCAL.cssForeColor = "##FFFF80">
						<cfset LOCAL.cssSoftColor = "##FFFF80">

						<cfset LOCAL.exceptionFields = [
							"NativeErrorCode",
							"SqlState",
							"Sql",
							"QueryError",
							"Where",
							"ErrNumber",
							"MissingFileName",
							"LockName",
							"LockOperation",
							"ErrorCode",
							"ExtendedInfo"
						]>

						<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
							<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
								ColdFusion Exception
							</div>
							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									Type
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
									#renderDump(ARGUMENTS.var.getType(), ARGUMENTS.depth)#
								</div>
							</div>
							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									Message
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
									#renderDump(ARGUMENTS.var.getMessage(), ARGUMENTS.depth)#
								</div>
							</div>
							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									Detail
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
									#renderDump(ARGUMENTS.var.getDetail(), ARGUMENTS.depth)#
								</div>
							</div>
							<div style="box-sizing: border-box; display: table-row;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									TagContext
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; overflow: auto; padding: 2px; vertical-align: top; white-space: nowrap;">
									<div style="box-sizing: border-box;">

										<span style="font-weight: bold;">
											#encodeForHtml( ARGUMENTS.var.getMessage() )#
										</span>

										<cfloop array="#ARGUMENTS.var.TagContext#" index="LOCAL.entry">
											<br>&nbsp;&nbsp;<span style="opacity: 0.50;">at</span> #encodeForHtml(LOCAL.entry.Template)# <span style="opacity: 0.50;">in Line</span> #LOCAL.entry.Line#
										</cfloop>

									</div>
								</div>
							</div>
							<cfloop array="#LOCAL.exceptionFields#" index="LOCAL.exceptionField">

								<cfif not structKeyExists(ARGUMENTS.var, LOCAL.exceptionField)>
									<cfcontinue>
								</cfif>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										#LOCAL.exceptionField#
									</div>
									<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
									</div>
								</div>

							</cfloop>
							<div style="box-sizing: border-box; display: table-row;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									StackTrace
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; overflow: auto; padding: 2px; vertical-align: top; white-space: nowrap;">
									<div style="box-sizing: border-box;">

										<span style="font-weight: bold;">
											#encodeForHtml( ARGUMENTS.var.toString() )#
										</span>

										<cfset LOCAL.trace = ARGUMENTS.var.getStackTrace()>
										<cfloop array="#LOCAL.trace#" index="LOCAL.entry">
											<br>&nbsp;&nbsp;<span style="opacity: 0.50;">at #encodeForHtml( LOCAL.entry.getClassName() )#</span>.<span>#encodeForHtml( LOCAL.entry.getMethodName() )#</span> <span style="font-size: 11px;">(#encodeForHtml( LOCAL.entry.getFileName() )#:#LOCAL.entry.getLineNumber()#</span>)
										</cfloop>

									</div>
								</div>
							</div>
						</div>

					<!--- check for other exceptions (Java) --->
					<cfelseif isInstanceOf(ARGUMENTS.var, "java.lang.Exception")>

						<cfset LOCAL.cssDeepColor = "##000000">
						<cfset LOCAL.cssForeColor = "##FFFF80">
						<cfset LOCAL.cssSoftColor = "##FFFF80">

						<cfset LOCAL.exceptionFields = [
							"NativeErrorCode",
							"SqlState",
							"Sql",
							"QueryError",
							"Where",
							"ErrNumber",
							"MissingFileName",
							"LockName",
							"LockOperation",
							"ErrorCode",
							"ExtendedInfo"
						]>

						<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
							<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
								Java Exception
							</div>
							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									Message
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
									#renderDump(ARGUMENTS.var.getMessage(), ARGUMENTS.depth)#
								</div>
							</div>
							<div style="box-sizing: border-box; display: table-row;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									TagContext
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; overflow: auto; padding: 2px; vertical-align: top; white-space: nowrap;">
									<div style="box-sizing: border-box;">

										<span style="font-weight: bold;">
											#encodeForHtml( ARGUMENTS.var.getMessage() )#
										</span>

										<cfloop array="#ARGUMENTS.var.TagContext#" index="LOCAL.entry">
											<br>&nbsp;&nbsp;<span style="opacity: 0.50;">at</span> #encodeForHtml(LOCAL.entry.Template)# <span style="opacity: 0.50;">in Line</span> #LOCAL.entry.Line#
										</cfloop>

									</div>
								</div>
							</div>
							<cfloop array="#LOCAL.exceptionFields#" index="LOCAL.exceptionField">

								<cfif not structKeyExists(ARGUMENTS.var, LOCAL.exceptionField)>
									<cfcontinue>
								</cfif>

								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										#LOCAL.exceptionField#
									</div>
									<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
									</div>
								</div>

							</cfloop>
							<div style="box-sizing: border-box; display: table-row;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									StackTrace
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; overflow: auto; padding: 2px; vertical-align: top; white-space: nowrap;">
									<div style="box-sizing: border-box;">

										<span style="font-weight: bold;">
											#encodeForHtml( ARGUMENTS.var.toString() )#
										</span>

										<cfset LOCAL.trace = ARGUMENTS.var.getStackTrace()>
										<cfloop array="#LOCAL.trace#" index="LOCAL.entry">
											<br>&nbsp;&nbsp;<span style="opacity: 0.50;">at #encodeForHtml( LOCAL.entry.getClassName() )#</span>.<span>#encodeForHtml( LOCAL.entry.getMethodName() )#</span> <span style="font-size: 11px;">(#encodeForHtml( LOCAL.entry.getFileName() )#:#LOCAL.entry.getLineNumber()#</span>)
										</cfloop>

									</div>
								</div>
							</div>
						</div>

					<cfelse>

						<!--- BEGIN: prepare constructors --->

							<cfset LOCAL.constructors = []>

							<cfset LOCAL.buffer = LOCAL.meta.getConstructors()>
							<cfloop array="#LOCAL.buffer#" index="LOCAL.method">

								<cfset LOCAL.methodSign = []>

								<cfset LOCAL.params = LOCAL.method.getParameterTypes()>
								<cfloop array="#LOCAL.params#" index="LOCAL.param">

									<cfset LOCAL.typeName = transformClassName( LOCAL.param.getName() )>

									<cfset LOCAL.methodSign.add(
										encodeForHtml(LOCAL.typeName)
									)>

								</cfloop>

								<cfset LOCAL.constructors.add(
									'<span style="color: ##0000FF;">#encodeForHtml( listLast(LOCAL.method.getName(), ".") )#</span>(<span style="font-size: 11px;">#arrayToList(LOCAL.methodSign, ", ")#</span>)'
								)>

							</cfloop>

							<cfset arraySort(LOCAL.constructors, "TEXT", "ASC")>

						<!--- END: prepare constructors --->

						<!--- BEGIN: prepare fields --->

							<cfset LOCAL.fields = []>

							<cfset LOCAL.buffer = LOCAL.meta.getFields()>
							<cfloop array="#LOCAL.buffer#" index="LOCAL.field">

								<cfset LOCAL.fieldType = transformClassName( LOCAL.field.getType().getName() )>

								<cfset LOCAL.fields.add(
									'<span style="font-size: 11px; opacity: 0.50;">#encodeForHtml(LOCAL.fieldType)#</span> <span>#encodeForHtml( LOCAL.field.getName() )#</span>'
								)>

							</cfloop>

							<cfset arraySort(LOCAL.fields, "TEXT", "ASC")>

						<!--- END: prepare fields --->

						<!--- BEGIN: prepare methods --->

							<cfset LOCAL.methods = []>

							<cfset LOCAL.buffer = LOCAL.meta.getMethods()>
							<cfloop array="#LOCAL.buffer#" index="LOCAL.method">

								<cfset LOCAL.returnType = transformClassName( LOCAL.method.getReturnType().getName() )>
								<cfset LOCAL.methodSign = []>

								<cfset LOCAL.params = LOCAL.method.getParameterTypes()>
								<cfloop array="#LOCAL.params#" index="LOCAL.param">

									<cfset LOCAL.typeName = transformClassName( LOCAL.param.getName() )>

									<cfset LOCAL.methodSign.add(
										encodeForHtml(LOCAL.typeName)
									)>

								</cfloop>

								<cfset LOCAL.methods.add(
									'<span style="color: ##0000FF;">#encodeForHtml( LOCAL.method.getName() )#</span>(<span style="font-size: 11px;">#arrayToList(LOCAL.methodSign, ", ")#</span>) <span style="font-size: 11px; opacity: 0.50; ">#encodeForHtml(LOCAL.returnType)#</span>'
								)>

							</cfloop>

							<cfset arraySort(LOCAL.methods, "TEXT", "ASC")>

						<!--- END: prepare methods --->

						<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
							<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
								<cfif len(LOCAL.docsLink)>
									<span style="font-weight: bold;">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" style="color: inherit; font-size: 9px; text-decoration: none;">#encodeForHtml(LOCAL.subType)#</a> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
								<cfelse>
									<span style="font-weight: bold;">object</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
								</cfif>
							</div>
							<cfif not arrayIsEmpty(LOCAL.constructors)>
								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										<span style="font-weight: bold;">constructors</span>
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; font-family: Consolas, monospace; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											<cfloop array="#LOCAL.constructors#" index="LOCAL.method">
												#LOCAL.method#<br>
											</cfloop>
										</div>
									</div>
								</div>
							</cfif>
							<cfif not arrayIsEmpty(LOCAL.fields)>
								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										<span style="font-weight: bold;">fields</span>
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; font-family: Consolas, monospace; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											<cfloop array="#LOCAL.fields#" index="LOCAL.field">
												#LOCAL.field#<br>
											</cfloop>
										</div>
									</div>
								</div>
							</cfif>
							<cfif not arrayIsEmpty(LOCAL.methods)>
								<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
									<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
										<span style="font-weight: bold;">methods</span>
									</div>
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; font-family: Consolas, monospace; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											<cfloop array="#LOCAL.methods#" index="LOCAL.method">
												#LOCAL.method#<br>
											</cfloop>
										</div>
									</div>
								</div>
							</cfif>
						</div>

					</cfif>

				</cfif>

			</cfif>

		<!--- xml --->
		<cfelseif isXmlNode(ARGUMENTS.var)>

			<cfset LOCAL.cssDeepColor = "##808080">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##EEEEEE">

			<cfif isXmlDoc(ARGUMENTS.var)>

				<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">XmlDocument</span> <span style="font-size: 9px;"></span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlRoot, ARGUMENTS.depth)#
						</div>
					</div>
				</div>

			<cfelse>

				<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">#( isXmlRoot(ARGUMENTS.var) ? "XmlRoot" : "XmlNode" )#</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlName
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlName, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlNsPrefix
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlNsPrefix, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlNsURI
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlNsURI, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlText
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlText, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlComment
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlComment, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlAttributes
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlAttributes, ARGUMENTS.depth)#
						</div>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
							XmlChildren
						</div>
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							#renderDump(ARGUMENTS.var.XmlChildren, ARGUMENTS.depth)#
						</div>
					</div>
				</div>

			</cfif>

		<!--- struct --->
		<cfelseif isStruct(ARGUMENTS.var)>

			<!--- top (maximum depth) --->
			<cfif (ATTRIBUTES.top gte 0) and (ARGUMENTS.depth gt ATTRIBUTES.top)>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%;">
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							[top reached]
						</div>
					</div>
				</div>

				<cfreturn>

			</cfif>

			<cfset LOCAL.cssDeepColor = "##4444CC">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##CCDDFF">

			<cfset LOCAL.subType  = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = structCount(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">struct</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; white-space: nowrap; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">struct [0]</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
							[empty struct]
						</div>
					</div>
				</div>

			<cfelse>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<!--- check for exception instance (Lucee) --->
				<cfif (
					(find("lucee.", LOCAL.subType) eq 1) and
					isInstanceOf(ARGUMENTS.var, "lucee.runtime.exp.CatchBlockImpl")
				)>

					<cfset LOCAL.cssDeepColor = "##000000">
					<cfset LOCAL.cssForeColor = "##FFFF80">
					<cfset LOCAL.cssSoftColor = "##FFFF80">

					<cfset LOCAL.exceptionFields = [
						"Type",
						"Message",
						"Detail",
						"TagContext",
						"StackTrace"
					]>

					<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">
						<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; font-weight: bold; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
							Lucee Exception
						</div>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								Type
							</div>
							<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
								#renderDump(ARGUMENTS.var.Type, ARGUMENTS.depth)#
							</div>
						</div>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								Message
							</div>
							<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
								#renderDump(ARGUMENTS.var.Message, ARGUMENTS.depth)#
							</div>
						</div>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								Detail
							</div>
							<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
								#renderDump(ARGUMENTS.var.Detail, ARGUMENTS.depth)#
							</div>
						</div>
						<div style="box-sizing: border-box; display: table-row;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								TagContext
							</div>
							<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; overflow: auto; padding: 2px; vertical-align: top; white-space: nowrap;">
								<div style="box-sizing: border-box;">

									<span style="font-weight: bold;">
										#encodeForHtml( ARGUMENTS.var.Message )#
									</span>

									<cfloop array="#ARGUMENTS.var.TagContext#" index="LOCAL.entry">

										<cfset LOCAL.preserveNL = LOCAL.entry.codePrintHTML>
										<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, chr(9), "&nbsp;&nbsp;&nbsp;&nbsp;", "ALL")>

										<div style="border: 1px solid ##A0A0A0; box-sizing: border-box; margin: 8px; padding: 8px;">
											<span style="opacity: 0.50;">at</span> #encodeForHtml(LOCAL.entry.Template)# <span style="opacity: 0.50;">in Line</span> #LOCAL.entry.Line#
											<div style="box-sizing: border-box; margin-top: 8px;">#LOCAL.preserveNL#</div>
										</div>

									</cfloop>

								</div>
							</div>
						</div>

						<cfset LOCAL.sortedKeys = structKeyArray(ARGUMENTS.var)>
						<cfset arraySort(LOCAL.sortedKeys, "TEXTnoCASE")>

						<cfloop array="#LOCAL.sortedKeys#" index="LOCAL.exceptionField">

							<cfif arrayFindNoCase(LOCAL.exceptionFields, LOCAL.exceptionField)>
								<cfcontinue>
							</cfif>

							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									#LOCAL.exceptionField#
								</div>
								<div style="border: 1px solid; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
									#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
								</div>
							</div>

						</cfloop>

						<div style="box-sizing: border-box; display: table-row;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								StackTrace
							</div>
							<div style="box-sizing: border-box; overflow: auto; white-space: nowrap;">
								<div style="box-sizing: border-box;">

									<cfset LOCAL.preserveNL = encodeForHtml(ARGUMENTS.var.StackTrace)>
									<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##xd;", "", "ALL")>
									<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##xa;", "<br>", "ALL")>
									<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##x9;", "&nbsp;&nbsp;", "ALL")>

									#LOCAL.preserveNL#

								</div>
							</div>
						</div>
					</div>

				<cfelse>

					<cfset LOCAL.showAlert = false>

					<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">

						<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
							<span style="font-weight: bold;">struct [#LOCAL.len#]</span> <span style="font-size: 9px;">#encodeForHtml(LOCAL.subType)#</span> <span style="opacity: 0.50;">@#encodeForHtml(LOCAL.identity)#</span>
						</div>

						<cfloop collection="#ARGUMENTS.var#" item="LOCAL.key">

							<cfset LOCAL.printedKey = LOCAL.key>

							<!--- whitespace warning --->
							<cfif VARIABLES.wsInspectKey>

								<cfset LOCAL.val = replaceWS(LOCAL.key)>

								<cfif not isNull(LOCAL.val)>

									<cfset LOCAL.showAlert = true>

									<cfset LOCAL.printedKey = LOCAL.val>

								</cfif>

							</cfif>

							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">

								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; white-space: nowrap; width: 1%; #( LOCAL.showAlert ? "font-family: Consolas, monospace; letter-spacing: 1px;" : "" )#">
									<cfif LOCAL.showAlert>⚠️</cfif>
									<cfif VARIABLES.isLucee>
										#encodeForHtml(LOCAL.printedKey)#
									<cfelse>
										#htmlEditFormat(LOCAL.printedKey)#
									</cfif>
								</div>

								<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.key)>

									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top;">
										<div style="box-sizing: border-box;">
											[blacklisted]
										</div>
									</div>

								<cfelseif structKeyExists(ARGUMENTS.var, LOCAL.key)>

									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										#renderDump(ARGUMENTS.var[LOCAL.key], ARGUMENTS.depth)#
									</div>

								<!--- null value --->
								<cfelse>

									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top;">
										#renderDump()#
									</div>

								</cfif>

							</div>

						</cfloop>

					</div>

				</cfif>

			</cfif>

		<!--- query --->
		<cfelseif isQuery(ARGUMENTS.var)>

			<cfset LOCAL.cssDeepColor = "##AA66AA">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##FFDDFF">

			<cfif VARIABLES.isLucee>
				<cfset LOCAL.columns = ARGUMENTS.var.columnArray()>
			<cfelse>
				<cfset LOCAL.columns = ARGUMENTS.var.getMetaData().getColumnLabels()>
			</cfif>

			<cfset LOCAL.columnCount = arrayLen(LOCAL.columns)>
			<cfset LOCAL.len         = ARGUMENTS.var.recordCount>

			<cfif LOCAL.columnCount>
				<cfset LOCAL.columnWidth = (99 / LOCAL.columnCount)>
			</cfif>

			<cfif LOCAL.len>

				<div style="border-collapse: collapse; box-sizing: border-box; display: table; width: 100%;">

					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">query [#LOCAL.len#]</span>
					</div>
					<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
						<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
						</div>
						<cfset LOCAL.i = 0>
						<cfloop array="#LOCAL.columns#" index="LOCAL.column">
							<cfset LOCAL.i++>
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; #( (LOCAL.i neq LOCAL.columnCount) ? "border-right: 0;" : "" )# border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: #LOCAL.columnWidth#%;">
								#encodeForHtml(LOCAL.column)#
							</div>
						</cfloop>
					</div>

					<cfloop query="#ARGUMENTS.var#">

						<!--- top (maximum rows) --->
						<cfif (ATTRIBUTES.top gte 0) and (ARGUMENTS.var.currentRow gt ATTRIBUTES.top)>

							<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
									#ARGUMENTS.var.currentRow#
								</div>
								<cfloop array="#LOCAL.columns#" index="LOCAL.column">
									<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; color: ##A0A0A0; display: table-cell; padding: 2px; vertical-align: top; width: #LOCAL.columnWidth#%;">
										<div style="box-sizing: border-box;">
											[top reached]
										</div>
									</div>
								</cfloop>
							</div>

							<cfbreak>

						</cfif>

						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; border-right: 0; border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: 1%;">
								#ARGUMENTS.var.currentRow#
							</div>
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; box-sizing: border-box; display: table-cell; padding: 2px; vertical-align: top; width: #LOCAL.columnWidth#%;">
									#renderDump(ARGUMENTS.var[LOCAL.column][ARGUMENTS.var.currentRow], ARGUMENTS.depth)#
								</div>
							</cfloop>
						</div>

					</cfloop>

				</div>

			<cfelse>

				<div style="border-collapse: collapse; box-sizing: border-box; color: ##A0A0A0; display: table; white-space: nowrap; width: 100%;">
					<div style="background-color: #LOCAL.cssDeepColor#; border: 1px solid #LOCAL.cssDeepColor#; box-sizing: border-box; color: #LOCAL.cssForeColor#; display: table-caption; font-size: 11px; letter-spacing: 1px; padding: 1px 2px 2px 2px; white-space: nowrap;">
						<span style="font-weight: bold;">query [0]</span>
					</div>
					<cfif LOCAL.columnCount>
						<div style="box-sizing: border-box; display: table-row; font-size: inherit;">
							<cfset LOCAL.i = 0>
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<cfset LOCAL.i++>
								<div style="background-color: #LOCAL.cssSoftColor#; border: 1px solid #LOCAL.cssDeepColor#; #( (LOCAL.i neq LOCAL.columnCount) ? "border-right: 0;" : "" )# border-top: 0; box-sizing: border-box; color: #LOCAL.cssDeepColor#; display: table-cell; padding: 2px 4px; vertical-align: top; width: #LOCAL.columnWidth#%;">
									#encodeForHtml(LOCAL.column)#
								</div>
							</cfloop>
						</div>
					</cfif>
					<div style="border: 1px solid #LOCAL.cssDeepColor#; border-top: 0; border-color: #LOCAL.cssDeepColor#; box-sizing: border-box; display: table-caption; caption-side: bottom; padding: 2px; white-space: nowrap;">
						[empty query]
					</div>
				</div>

			</cfif>

		</cfif>

	</cfoutput>

</cffunction>

<cffunction name="getClassName" accessor="private" output="false" returnType="string">

	<cfargument name="obj" type="any" required="true">

	<cftry>

		<cfreturn ARGUMENTS.obj.getClass().getName()>

		<cfcatch>
			<!--- checked "Disable access to internal ColdFusion Java components" setting in CF Admin causes this --->
		</cfcatch>
	</cftry>

	<cfreturn "coldfusion">
</cffunction>

<cffunction name="transformClassName" accessor="private" output="false" returnType="string">

	<cfargument name="className" type="string" required="true">

	<cfif ARGUMENTS.className does not contain "[">
		<cfreturn ARGUMENTS.className>
	</cfif>

	<!--- discard class name encoding --->
	<cfset ARGUMENTS.className = reReplace(ARGUMENTS.className, "^\[+[BCDFIJLSZ]", "")>
	<cfset ARGUMENTS.className = reReplace(ARGUMENTS.className, ";$", "")>

	<!--- multidimensional array is treated as one dimensional array --->
	<cfreturn (ARGUMENTS.className & "[]")>
</cffunction>

<cffunction name="replaceWS" accessor="private" output="false" returnType="any">

	<cfargument name="value" type="string" required="true">

	<cfset LOCAL.len = len(ARGUMENTS.value)>
	<cfif not LOCAL.len>
		<cfreturn>
	</cfif>

	<cfset LOCAL.Character    = createObject("java", "java.lang.Character")>
	<cfset LOCAL.wsCodepoints = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 133, 160, 173, 5760, 6158, 8192, 8193, 8194, 8195, 8196, 8197, 8198, 8199, 8200, 8201, 8202, 8203, 8204, 8205, 8206, 8207, 8288, 8232, 8233, 8239, 8287, 9248, 9250, 9251, 10240, 12288, 65279, 65296 ]>

	<cfset LOCAL.firstCP = ARGUMENTS.value.codePointAt(0)>
	<cfset LOCAL.lastCP  = ARGUMENTS.value.codePointAt(LOCAL.len -1)>
	<cfset LOCAL.wsFirst = (arrayFind(LOCAL.wsCodepoints, LOCAL.firstCP) gt 0)>
	<cfset LOCAL.wsLast  = (arrayFind(LOCAL.wsCodepoints, LOCAL.lastCP)  gt 0)>

	<cfif (
		(not LOCAL.wsFirst) and
		(not LOCAL.wsLast)
	)>
		<cfreturn>
	</cfif>

	<cfset LOCAL.cpArray = []>
	<cfset LOCAL.offset  = 0>

	<cfloop condition="true">

		<cfif LOCAL.offset gte LOCAL.len>
			<cfbreak>
		</cfif>

		<cfset LOCAL.cp   = ARGUMENTS.value.codePointAt(LOCAL.offset)>
		<cfset LOCAL.isWS = (arrayFind(LOCAL.wsCodepoints, LOCAL.cp) gt 0)>

		<cfif LOCAL.isWS>
			<cfset LOCAL.cpArray.add(46)> <!--- 46 = . --->
		<cfelse>
			<cfset LOCAL.cpArray.add(LOCAL.cp)>
		</cfif>

		<cfset LOCAL.offset += LOCAL.Character.charCount(LOCAL.cp)>

	</cfloop>

	<cfset ARGUMENTS.value = createObject("java", "java.lang.String").init(
		javaCast("int[]", LOCAL.cpArray),
		0,
		arrayLen(LOCAL.cpArray)
	)>

	<cfreturn ARGUMENTS.value>
</cffunction>

<cffunction name="trimOutput" access="private" output="false" returnType="string">

	<cfargument name="content" type="string"  required="true">
	<cfargument name="pre"     type="boolean" required="true">

	<cfset LOCAL.result = trim(ARGUMENTS.content)>

	<cfif not ARGUMENTS.pre>

		<!--- remove all tabs --->
		<cfset LOCAL.result = LOCAL.result.replaceAll(chr(9), "")>

		<!--- reduce line feeds --->
		<cfset LOCAL.result = LOCAL.result.replaceAll("\n{2,}", chr(10))>

	</cfif>

	<!--- compact divs --->
	<cfset LOCAL.result = LOCAL.result.replaceAll("</div>\n(?!=</div>)", "</div>")>

	<cfreturn LOCAL.result>
</cffunction>

<cfsetting enableCFoutputOnly="false">
