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

	<!--- wsWarning --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "wsWarning")) and
		structKeyExists(REQUEST, "__cf_dump_wsWarning") and
		isBoolean(REQUEST["__cf_dump_wsWarning"])
	)>
		<cfset ATTRIBUTES.wsWarning = REQUEST["__cf_dump_wsWarning"]>
	</cfif>
	<cfparam name="ATTRIBUTES.wsWarning" type="boolean" default="true">

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

		<style>

			.cf_dump {
				background-color: ##FFFFFF;
				border-spacing: 0px;
				color: ##000000;
				font-family: 'Segoe UI', sans-serif;
				font-size: 14px;
				margin-bottom: 8px;
				margin-top: 8px;
			}

				.cf_dump div {
					box-sizing: border-box;
					font-size: inherit;
				}

				.cf_dump .lowkey {
					color: ##A0A0A0;
				}

				.cf_dump .empty {
					white-space: nowrap;
				}

				.cf_dump .label {
					background-color: ##E91E63;
					color: ##FFFFFF;
					padding: 4px;
				}

				.cf_dump .var {
					border-collapse: collapse;
					display: table;
					width: 100%;
				}
					.cf_dump .var.whitespace .colheader::before {
						content: '⚠️ '
					}
					.cf_dump .var.whitespace .rowcell {
						color: ##F00000;
						font-family: Consolas, monospace;
						letter-spacing: 1px;
					}

				.cf_dump .colheader {
					border: 1px solid;
					cursor: pointer;
					display: table-caption;
					font-size: 11px;
					letter-spacing: 1px;
					padding: 1px 2px 2px 2px;
					white-space: nowrap;
				}
					.cf_dump .type {
						font-weight: bold;
					}
					.cf_dump .subtype {
						font-size: 9px;
					}
					.cf_dump .ref {
						opacity: 0.50;
					}

				.cf_dump .colfooter {
					border: 1px solid;
					display: table-caption;
					caption-side: bottom;
					padding: 2px;
					white-space: nowrap;
				}
					.cf_dump .colfooter.hidden {
						display: none;
					}

				.cf_dump .row {
					display: table-row;
				}
					.cf_dump .row.hidden {
						display: none;
					}

				.cf_dump .rowheader {
					border: 1px solid;
					border-right: none;
					border-top: none;
					cursor: pointer;
					display: table-cell;
					padding: 2px 4px;
					vertical-align: top;
					width: 1%;
				}

					.cf_dump .struct > .row > .rowheader {
						white-space: nowrap;
					}

					.cf_dump .query > .row > .rowheader:last-child {
						border-right: 1px solid;
					}

				.cf_dump .rowcell {
					border: 1px solid;
					border-top: none;
					display: table-cell;
					padding: 2px;
					vertical-align: top;
				}
					.cf_dump .rowcell.hidden .var,
					.cf_dump .rowcell.hidden .cellcontent {
						display: none;
					}

					.cf_dump .string .rowcell {
						word-break: break-all;
					}

				.cf_dump .component .extends {
					margin-left: 7px;
				}
				.cf_dump .component .implements {
					margin-left: 15px;
				}
				.cf_dump .component .keyword {
					color: ##FFFFFF;
				}

				.cf_dump .object .col.colheader a {
					color: inherit;
					text-decoration: underline;
				}
				.cf_dump .object .row .rowcell {
					font-family: Consolas, monospace;
				}
					.cf_dump .object .row .rowcell .returns,
					.cf_dump .object .row .rowcell .type {
						opacity: 0.50;
					}
					.cf_dump .object .row .rowcell .method {
						color: ##0000FF;
					}
					.cf_dump .object .row .rowcell .returns,
					.cf_dump .object .row .rowcell .params,
					.cf_dump .object .row .rowcell .type {
						font-size: 11px;
					}

				.cf_dump .trace > .rowcell {
					overflow: auto;
					white-space: nowrap;
				}

				.cf_dump .trace .preview {
					border: 1px solid ##A0A0A0;
					margin: 8px;
					padding: 8px;
				}
					.cf_dump .trace .preview .block {
						margin-top: 8px;
					}

				.cf_dump .trace .exception {
					font-weight: bold;
				}

				.cf_dump .trace .class,
				.cf_dump .trace .filler {
					opacity: 0.50;
				}

				.cf_dump .trace .file {
					font-size: 11px;
				}

				.cf_dump .cfdump_array,
				.cf_dump .cfdump_query,
				.cf_dump .cfdump_struct,
				.cf_dump .cfdump_xml {
					color: ##000000;
				}

		</style>

		<div class="cf_dump">

			<cfif len(ATTRIBUTES.label)>
				<div class="label">
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

<cfoutput>#trimOutput(VARIABLES.output)#</cfoutput>

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

			<div class="var null lowkey">
				<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
					<span class="type">null</span>
				</div>
				<div class="row">
					<div class="rowcell">
						[undefined]
					</div>
				</div>
			</div>

		<!--- simple --->
		<cfelseif isSimpleValue(ARGUMENTS.var)>

			<cfset LOCAL.type    = ARGUMENTS.var.getClass().getName()>
			<cfset LOCAL.subType = "">

			<cfset LOCAL.title = "">

			<cfswitch expression="#LOCAL.type#">

				<cfcase value="java.lang.Boolean">

					<cfset LOCAL.type         = "boolean">
					<cfset LOCAL.cssClass     = "boolean">
					<cfset LOCAL.cssDeepColor = "##673AB7">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

					<cfset ARGUMENTS.var = ( ARGUMENTS.var ? "true" : "false" )>

				</cfcase>

				<cfcase value="java.lang.Byte">

					<cfset LOCAL.type         = "byte">
					<cfset LOCAL.subType      = "HEX">
					<cfset LOCAL.cssClass     = "byte">
					<cfset LOCAL.cssDeepColor = "##FFCC44">
					<cfset LOCAL.cssForeColor = "##000000">

					<cfset ARGUMENTS.var = VARIABLES.String.format("%02X", [ ARGUMENTS.var ])>

				</cfcase>

				<cfcase value="java.lang.Double">

					<cfset LOCAL.type         = "numeric">
					<cfset LOCAL.subType      = "double">
					<cfset LOCAL.cssClass     = "numeric">
					<cfset LOCAL.cssDeepColor = "##2196F3">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfcase>

				<cfcase value="java.lang.String">

					<cfset LOCAL.len = len(ARGUMENTS.var)>

					<cfset LOCAL.type         = "string [#LOCAL.len#]">
					<cfset LOCAL.cssClass     = "string">
					<cfset LOCAL.cssDeepColor = "##FF8000">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

					<cfif LOCAL.len>

						<!--- whitespace warning --->
						<cfif (
							(not ATTRIBUTES.pre) and
							ATTRIBUTES.wsWarning and (
								reFind("^\s", ARGUMENTS.var) or
								reFind("\s$", ARGUMENTS.var)
							)
						)>

							<cfset LOCAL.title = "This string contains leading or trailing whitespaces, usually unintended. Every whitespace has been replaced with a dot.">

							<cfset LOCAL.cssClass &= " whitespace">
							<cfset ARGUMENTS.var   = reReplace(ARGUMENTS.var, "\s", ".", "ALL")>

						</cfif>

					<cfelse>

						<cfset LOCAL.cssClass &= " lowkey empty">
						<cfset ARGUMENTS.var   = "[empty string]">

					</cfif>

				</cfcase>

				<cfcase value="java.lang.Integer">

					<cfset LOCAL.type         = "numeric">
					<cfset LOCAL.subType      = "integer">
					<cfset LOCAL.cssClass     = "numeric">
					<cfset LOCAL.cssDeepColor = "##2196F3">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfcase>

				<cfdefaultcase>

					<cfset LOCAL.cssClass     = "simple">
					<cfset LOCAL.cssDeepColor = "##FF8000">
					<cfset LOCAL.cssForeColor = "##FFFFFF">

				</cfdefaultcase>

			</cfswitch>

			<div <cfif len(LOCAL.title)>title="#encodeForHtmlAttribute(LOCAL.title)#"</cfif> class="var #LOCAL.cssClass#">
				<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
					<span class="type">#encodeForHtml(LOCAL.type)#</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
				</div>
				<div class="row">
					<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
						<cfif ATTRIBUTES.pre>
							<pre>#encodeForHtml(ARGUMENTS.var)#</pre>
						<cfelse>
							#encodeForHtml(ARGUMENTS.var)#
						</cfif>
					</div>
				</div>
			</div>

		<!--- array --->
		<cfelseif isArray(ARGUMENTS.var)>

			<cfset LOCAL.cssDeepColor = "##009900">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##CCFFCC">

			<cfset LOCAL.subType  = ARGUMENTS.var.getClass().getName()>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = arrayLen(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div class="var array lowkey">
					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">array</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div class="row">
						<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<div class="var array lowkey">
					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">array [0]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
					</div>
					<div class="row">
						<div class="rowcell empty" style="border-color: #LOCAL.cssDeepColor#;">
							[empty array]
						</div>
					</div>
				</div>

			<cfelse>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<div class="var array">

					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">array [#LOCAL.len#]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
					</div>

					<!--- Byte[] --->
					<cfif LOCAL.subType eq "[B">

						<cfloop array="#ATTRIBUTES.byteEncoding#" index="LOCAL.encoding">

							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									#encodeForHtml( replace(uCase(LOCAL.encoding), "-", "‑", "ALL") )# <!--- force non-breaking hyphen --->
								</div>
								<div class="rowcell lowkey hidden" style="border-color: #LOCAL.cssDeepColor#;">
									<div class="cellcontent">
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

							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									#LOCAL.i#
								</div>
								<div class="rowcell lowkey" style="border-color: #LOCAL.cssDeepColor#;">
									<div class="cellcontent">
										[top reached]
									</div>
								</div>
							</div>

							<cfbreak>

						</cfif>

						<div class="row">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								#LOCAL.i#
							</div>
							<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
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

					<div class="var component lowkey">
						<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
							<span class="type">component</span> <span class="subtype">#encodeForHtml(LOCAL.meta.FullName)#</span>
						</div>
						<div class="row">
							<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
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

					<div class="var component">
						<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
							<span class="type">component</span> <span class="subtype">#encodeForHtml(LOCAL.meta.FullName)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span><br>
							<cfif len(LOCAL.extends)>
								<span class="extends"><span class="keyword">extends</span> <span class="subtype">#encodeForHtml(LOCAL.extends)#</span></span><br>
							</cfif>
							<cfloop array="#LOCAL.implements#" index="LOCAL.className">
								<span class="implements"><span class="keyword">implements</span> <span class="subtype">#encodeForHtml(className)#</span></span><br>
							</cfloop>
						</div>

						<cfloop array="#LOCAL.publicFields#" index="LOCAL.field">

							<!--- skip fields starting with an underscore --->
							<cfif find("_", LOCAL.field) eq 1>
								<cfcontinue>
							</cfif>

							<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.field)>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div class="rowcell lowkey" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = ARGUMENTS.var[LOCAL.field]>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
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

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										<span title="This field is private and can only be accessed from inside the component.">
											👁&nbsp;#encodeForHtml(LOCAL.field)#
										</span>
									</div>
									<div class="rowcell lowkey" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = LOCAL.privateScope[LOCAL.field]>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										<span title="This field is private and can only be accessed from inside the component.">
											👁&nbsp;#encodeForHtml(LOCAL.field)#
										</span>
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
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
				<cfset LOCAL.subType = LOCAL.meta.getName()>

				<cfset LOCAL.docsLink = "">
				<cfif find("java.", LOCAL.subType) eq 1>
					<cfset LOCAL.docsLink = "https://docs.oracle.com/en/java/javase/11/docs/api/java.base/#replace(LOCAL.subType, ".", "/", "ALL")#.html">
				</cfif>

				<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

					<div class="var object lowkey">
						<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
							<cfif len(LOCAL.docsLink)>
								<span class="type">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" class="subtype">#encodeForHtml(LOCAL.subType)#</a>
							<cfelse>
								<span class="type">object</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
							</cfif>
						</div>
						<div class="row">
							<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
								[references @#encodeForHtml(LOCAL.identity)#]
							</div>
						</div>
					</div>

				<cfelse>

					<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

					<!--- check for exception instance (ColdFusion) --->
					<cfif (
						(find("coldfusion.", LOCAL.subType) eq 1) and
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

						<div class="var exception">
							<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
								ColdFusion Exception
							</div>
							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									Type
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getType(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									Message
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getMessage(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									Detail
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getDetail(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row trace">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									TagContext
								</div>
								<div class="rowcell">
									<div class="cellcontent">

										<span class="exception">
											#encodeForHtml( ARGUMENTS.var.getMessage() )#
										</span>

										<cfloop array="#ARGUMENTS.var.TagContext#" index="LOCAL.entry">
											<br>&nbsp;&nbsp;<span class="filler">at</span> #encodeForHtml(LOCAL.entry.Template)# <span class="filler">in Line</span> #LOCAL.entry.Line#
										</cfloop>

									</div>
								</div>
							</div>
							<cfloop array="#LOCAL.exceptionFields#" index="LOCAL.exceptionField">

								<cfif not structKeyExists(ARGUMENTS.var, LOCAL.exceptionField)>
									<cfcontinue>
								</cfif>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#LOCAL.exceptionField#
									</div>
									<div class="rowcell">
										#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
									</div>
								</div>

							</cfloop>
							<div class="row trace">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									StackTrace
								</div>
								<div class="rowcell">
									<div class="cellcontent">

									<span class="exception">
										#encodeForHtml( ARGUMENTS.var.toString() )#
									</span>

									<cfset LOCAL.trace = ARGUMENTS.var.getStackTrace()>
									<cfloop array="#LOCAL.trace#" index="LOCAL.entry">
										<br>&nbsp;&nbsp;<span class="class">at #encodeForHtml( LOCAL.entry.getClassName() )#</span>.<span class="method">#encodeForHtml( LOCAL.entry.getMethodName() )#</span> <span class="file">(#encodeForHtml( LOCAL.entry.getFileName() )#:#LOCAL.entry.getLineNumber()#</span>)
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
									'<span class="method">#encodeForHtml( listLast(LOCAL.method.getName(), ".") )#</span>(<span class="params">#arrayToList(LOCAL.methodSign, ", ")#</span>)'
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
									'<span class="type">#encodeForHtml(LOCAL.fieldType)#</span> <span class="field">#encodeForHtml( LOCAL.field.getName() )#</span>'
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
									'<span class="method">#encodeForHtml( LOCAL.method.getName() )#</span>(<span class="params">#arrayToList(LOCAL.methodSign, ", ")#</span>) <span class="returns">#encodeForHtml(LOCAL.returnType)#</span>'
								)>

							</cfloop>

							<cfset arraySort(LOCAL.methods, "TEXT", "ASC")>

						<!--- END: prepare methods --->

						<div class="var object">
							<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
								<cfif len(LOCAL.docsLink)>
									<span class="type">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" class="subtype">#encodeForHtml(LOCAL.subType)#</a> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
								<cfelse>
									<span class="type">object</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
								</cfif>
							</div>
							<cfif not arrayIsEmpty(LOCAL.constructors)>
								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										<span class="type">constructors</span>
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
											<cfloop array="#LOCAL.constructors#" index="LOCAL.method">
												#LOCAL.method#<br>
											</cfloop>
										</div>
									</div>
								</div>
							</cfif>
							<cfif not arrayIsEmpty(LOCAL.fields)>
								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										<span class="type">fields</span>
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
											<cfloop array="#LOCAL.fields#" index="LOCAL.field">
												#LOCAL.field#<br>
											</cfloop>
										</div>
									</div>
								</div>
							</cfif>
							<cfif not arrayIsEmpty(LOCAL.methods)>
								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										<span class="type">methods</span>
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
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

				<div class="var xml">
					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">XmlDocument</span> <span class="subtype"></span>
					</div>
					<div class="row">
						<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
							#renderDump(ARGUMENTS.var.XmlRoot, ARGUMENTS.depth)#
						</div>
					</div>
				</div>

			<cfelse>

				<div class="var xml">
					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">#( isXmlRoot(ARGUMENTS.var) ? "XmlRoot" : "XmlNode" )#</span>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlName
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlName, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlNsPrefix
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlNsPrefix, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlNsURI
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlNsURI, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlText
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlText, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlComment
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlComment, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlAttributes
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlAttributes, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
							XmlChildren
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlChildren, ARGUMENTS.depth)#
						</div>
					</div>
				</div>

			</cfif>

		<!--- struct --->
		<cfelseif isStruct(ARGUMENTS.var)>

			<!--- top (maximum depth) --->
			<cfif (ATTRIBUTES.top gte 0) and (ARGUMENTS.depth gt ATTRIBUTES.top)>

				<div class="var lowkey">
					<div class="row">
						<div class="rowcell">
							[top reached]
						</div>
					</div>
				</div>

				<cfreturn>

			</cfif>

			<cfset LOCAL.cssDeepColor = "##4444CC">
			<cfset LOCAL.cssForeColor = "##FFFFFF">
			<cfset LOCAL.cssSoftColor = "##CCDDFF">

			<cfset LOCAL.subType  = ARGUMENTS.var.getClass().getName()>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = structCount(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div class="var struct lowkey">
					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">struct</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div class="row">
						<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<div class="var struct lowkey">

					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">struct [0]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
					</div>

					<div class="row">
						<div class="rowcell empty" style="border-color: #LOCAL.cssDeepColor#;">
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

					<div class="var exception">
						<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
							Lucee Exception
						</div>
						<div class="row">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								Type
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Type, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								Message
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Message, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								Detail
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Detail, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row trace">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								TagContext
							</div>
							<div class="rowcell">

								<span class="exception">
									#encodeForHtml( ARGUMENTS.var.Message )#
								</span>

								<cfloop array="#ARGUMENTS.var.TagContext#" index="LOCAL.entry">

									<cfset LOCAL.preserveNL = LOCAL.entry.codePrintHTML>
									<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, chr(9), "&nbsp;&nbsp;&nbsp;&nbsp;", "ALL")>

									<div class="preview">
										<span class="filler">at</span> #encodeForHtml(LOCAL.entry.Template)# <span class="filler">in Line</span> #LOCAL.entry.Line#
										<div class="block">#LOCAL.preserveNL#</div>
									</div>

								</cfloop>

							</div>
						</div>

						<cfset LOCAL.sortedKeys = structKeyArray(ARGUMENTS.var)>
						<cfset arraySort(LOCAL.sortedKeys, "TEXTnoCASE")>

						<cfloop array="#LOCAL.sortedKeys#" index="LOCAL.exceptionField">

							<cfif arrayFindNoCase(LOCAL.exceptionFields, LOCAL.exceptionField)>
								<cfcontinue>
							</cfif>

							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									#LOCAL.exceptionField#
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
								</div>
							</div>

						</cfloop>

						<div class="row trace">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								StackTrace
							</div>
							<div class="rowcell">

								<cfset LOCAL.preserveNL = encodeForHtml(ARGUMENTS.var.StackTrace)>
								<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##xd;", "", "ALL")>
								<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##xa;", "<br>", "ALL")>
								<cfset LOCAL.preserveNL = replace(LOCAL.preserveNL, "&##x9;", "&nbsp;&nbsp;", "ALL")>

								#LOCAL.preserveNL#

							</div>
						</div>
					</div>

				<cfelse>

					<div class="var struct">

						<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
							<span class="type">struct [#LOCAL.len#]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
						</div>

						<cfloop collection="#ARGUMENTS.var#" item="LOCAL.key">

							<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.key)>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#encodeForHtml(LOCAL.key)#
									</div>
									<div class="rowcell lowkey" style="border-color: #LOCAL.cssDeepColor#;">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelseif structKeyExists(ARGUMENTS.var, LOCAL.key)>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#encodeForHtml(LOCAL.key)#
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
										#renderDump(ARGUMENTS.var[LOCAL.key], ARGUMENTS.depth)#
									</div>
								</div>

							<!--- null value --->
							<cfelse>

								<div class="row">
									<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
										#encodeForHtml(LOCAL.key)#
									</div>
									<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#;">
										#renderDump()#
									</div>
								</div>

							</cfif>

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

				<div class="var query">

					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">query [#LOCAL.len#]</span>
					</div>
					<div class="row">
						<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
						</div>
						<cfloop array="#LOCAL.columns#" index="LOCAL.column">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#; width: #LOCAL.columnWidth#%;">
								#encodeForHtml(LOCAL.column)#
							</div>
						</cfloop>
					</div>

					<cfloop query="#ARGUMENTS.var#">

						<!--- top (maximum rows) --->
						<cfif (ATTRIBUTES.top gte 0) and (ARGUMENTS.var.currentRow gt ATTRIBUTES.top)>

							<div class="row">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
									#ARGUMENTS.var.currentRow#
								</div>
								<cfloop array="#LOCAL.columns#" index="LOCAL.column">
									<div class="rowcell lowkey" style="border-color: #LOCAL.cssDeepColor#; width: #LOCAL.columnWidth#%;">
										<div class="cellcontent">
											[top reached]
										</div>
									</div>
								</cfloop>
							</div>

							<cfbreak>

						</cfif>

						<div class="row">
							<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#;">
								#ARGUMENTS.var.currentRow#
							</div>
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<div class="rowcell" style="border-color: #LOCAL.cssDeepColor#; width: #LOCAL.columnWidth#%;">
									#renderDump(ARGUMENTS.var[LOCAL.column][ARGUMENTS.var.currentRow], ARGUMENTS.depth)#
								</div>
							</cfloop>
						</div>

					</cfloop>

				</div>

			<cfelse>

				<div class="var query lowkey">

					<div class="col colheader" style="background-color: #LOCAL.cssDeepColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssForeColor#;">
						<span class="type">query [0]</span>
					</div>
					<cfif LOCAL.columnCount>
						<div class="row">
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<div class="rowheader" style="background-color: #LOCAL.cssSoftColor#; border-color: #LOCAL.cssDeepColor#; color: #LOCAL.cssDeepColor#; width: #LOCAL.columnWidth#%;">
									#encodeForHtml(LOCAL.column)#
								</div>
							</cfloop>
						</div>
					</cfif>
					<div class="colfooter empty" style="border-color: #LOCAL.cssDeepColor#;">
						[empty query]
					</div>
				</div>

			</cfif>

		</cfif>

	</cfoutput>

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

<cffunction name="trimOutput" access="private" output="false" returnType="string">

	<cfargument name="content" type="string" required="true">

	<cfset LOCAL.result = trim(ARGUMENTS.content)>

	<!--- remove all tabs --->
	<cfset LOCAL.result = createObject("java", "org.apache.commons.lang.StringUtils").replace(LOCAL.result, chr(9), "")>

	<!--- reduce line feeds --->
	<cfset LOCAL.result = reReplace(LOCAL.result, "\n{2,}", chr(10), "ALL")>

	<!--- compact divs --->
	<cfset LOCAL.result = reReplace(LOCAL.result, "</div>\n(?!=</div>)", "</div>", "ALL")>

	<cfreturn LOCAL.result>
</cffunction>

<cfsetting enableCFoutputOnly="false">