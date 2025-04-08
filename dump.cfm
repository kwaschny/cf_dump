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

	<!--- byteMax --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "byteMax")) and
		structKeyExists(REQUEST, "__cf_dump_byteMax") and
		isNumeric(REQUEST["__cf_dump_byteMax"])
	)>
		<cfset ATTRIBUTES.byteMax = REQUEST["__cf_dump_byteMax"]>
	</cfif>
	<cfparam name="ATTRIBUTES.byteMax" type="numeric" default="1024">

	<!--- embed --->
	<cfif (
		(not structKeyExists(ATTRIBUTES, "embed")) and
		structKeyExists(REQUEST, "__cf_dump_embed") and
		isBoolean(REQUEST["__cf_dump_embed"])
	)>
		<cfset ATTRIBUTES.embed = REQUEST["__cf_dump_embed"]>
	</cfif>
	<cfparam name="ATTRIBUTES.embed" type="boolean" default="false">

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

		<cfif (
			ATTRIBUTES.embed or
			ATTRIBUTES.reset or
			(not structKeyExists(REQUEST, "__cf_dump_head"))
		)>

			<cfset REQUEST["__cf_dump_head"] = true>

			<style>
				.cf_dump{background-color:##fff;border-spacing:0;box-sizing:border-box;color:##000;display:table;font-family:'Segoe UI',sans-serif;font-size:14px;margin-bottom:8px;margin-top:8px}.cf_dump div{box-sizing:border-box;font-size:inherit}.cf_dump pre{margin:0}.cf_dump .lowkey{color:##a0a0a0}.cf_dump .empty{white-space:nowrap}.cf_dump .label{background-color:##e91e63;color:##fff;padding:4px}.cf_dump .var{border-collapse:collapse;display:table;width:100%}.cf_dump .var .rowheader.whitespace::before,.cf_dump .var.whitespace .colheader::before{content:'⚠️'}.cf_dump .var .rowheader.whitespace,.cf_dump .var.whitespace .rowcell{color:##f00000;font-family:Consolas,monospace;letter-spacing:1px}.cf_dump .var.array>.colheader{background-color:##090;border-color:##090;color:##fff}.cf_dump .var.array>.row>.rowheader{background-color:##cfc;border-color:##090;color:##090}
				.cf_dump .var.array>.row>.rowcell{border-color:##090}.cf_dump .var.boolean>.colheader{background-color:##673ab7;border-color:##673ab7;color:##fff}.cf_dump .var.boolean>.row>.rowcell{border-color:##673ab7}.cf_dump .var.byte>.colheader{background-color:##fc4;border-color:##fc4;color:##000}.cf_dump .var.byte>.row>.rowcell{border-color:##fc4}.cf_dump .var.component>.colheader{background-color:##1c434a;border-color:##1c434a;color:##b6dce3}.cf_dump .var.component>.row>.rowheader{background-color:##b6dce3;border-color:##1c434a;color:##1c434a}.cf_dump .var.component>.row>.rowcell{border-color:##1c434a}.cf_dump .var.exception>.colheader{background-color:##000;border-color:##000;color:##ffff80}
				.cf_dump .var.exception>.row>.rowheader{background-color:##ffff80;border-color:##000;color:##000}.cf_dump .var.exception>.row>.rowcell{border-color:##000}.cf_dump .var.null>.colheader{background-color:##000;border-color:##000;color:##fff}.cf_dump .var.null>.row>.rowcell{border-color:##000}.cf_dump .var.numeric>.colheader{background-color:##2196f3;border-color:##2196f3;color:##fff}.cf_dump .var.numeric>.row>.rowcell{border-color:##2196f3}.cf_dump .var.object>.colheader{background-color:##f44;border-color:##f44;color:##fff}.cf_dump .var.object>.row>.rowheader{background-color:##ffdbdb;border-color:##f44;color:##f44}.cf_dump .var.object>.row>.rowcell{border-color:##f44}.cf_dump .var.query>.colheader{background-color:##a6a;border-color:##a6a;color:##fff}
				.cf_dump .var.query>.colfooter{border-color:##a6a}.cf_dump .var.query>.row>.rowheader{background-color:##fdf;border-color:##a6a;color:##a6a}.cf_dump .var.query>.row>.rowcell{border-color:##a6a}.cf_dump .var.simple>.colheader{background-color:##f44;border-color:##f44;color:##fff}.cf_dump .var.simple>.row>.rowcell{border-color:##f44}.cf_dump .var.string>.colheader{background-color:##ff8000;border-color:##ff8000;color:##fff}.cf_dump .var.string>.row>.rowcell{border-color:##ff8000}.cf_dump .var.struct>.colheader{background-color:##44c;border-color:##44c;color:##fff}.cf_dump .var.struct>.row>.rowheader{background-color:##cdf;border-color:##44c;color:##44c}.cf_dump .var.struct>.row>.rowcell{border-color:##44c}
				.cf_dump .var.xml>.colheader{background-color:grey;border-color:grey;color:##fff}.cf_dump .var.xml>.row>.rowheader{background-color:##eee;border-color:grey;color:grey}.cf_dump .var.xml>.row>.rowcell{border-color:grey}.cf_dump .colheader{border:1px solid;cursor:pointer;display:table-caption;font-size:11px;letter-spacing:1px;padding:1px 2px 2px;user-select:none;white-space:nowrap}.cf_dump .colheader[data-cf_dump_collapsed]{opacity:.5}.cf_dump .colheader a{color:inherit;text-decoration:none}.cf_dump .type{font-weight:700}.cf_dump .subtype{font-size:9px}.cf_dump .ref{opacity:.5}.cf_dump .colfooter{border:1px solid;border-top:0;display:table-caption;caption-side:bottom;padding:2px;white-space:nowrap}.cf_dump .colfooter.hidden{display:none}.cf_dump .row{display:table-row}.cf_dump .row.hidden{display:none}
				.cf_dump .rowheader{border:1px solid;border-right:0;border-top:0;cursor:pointer;display:table-cell;padding:2px 4px;vertical-align:top;width:1%}.cf_dump .rowheader[data-cf_dump_collapsed]{opacity:.5}.cf_dump .struct>.row>.rowheader{white-space:nowrap}.cf_dump .query>.row>.rowheader:last-child{border-right:1px solid}.cf_dump .rowcell{border:1px solid;border-top:0;display:table-cell;padding:2px;vertical-align:top}.cf_dump .rowcell.hidden .cellcontent,.cf_dump .rowcell.hidden .var{display:none}.cf_dump .string .rowcell{word-break:break-all}.cf_dump .component .extends{margin-left:7px}.cf_dump .component .implements{margin-left:15px}.cf_dump .component .keyword{color:##fff}.cf_dump .object .col.colheader a{color:inherit;text-decoration:none}
				.cf_dump .object .row .rowcell{font-family:Consolas,monospace}.cf_dump .object .row .rowcell .returns,.cf_dump .object .row .rowcell .type{opacity:.5}.cf_dump .object .row .rowcell .method{color:##00f}.cf_dump .object .row .rowcell .params,.cf_dump .object .row .rowcell .returns,.cf_dump .object .row .rowcell .type{font-size:11px}.cf_dump .trace>.rowcell{overflow:auto;white-space:nowrap}.cf_dump .trace .preview{border:1px solid ##a0a0a0;margin:8px;padding:8px}.cf_dump .trace .preview .block{margin-top:8px}.cf_dump .trace .exception{font-weight:700}.cf_dump .trace .class,.cf_dump .trace .filler{opacity:.5}.cf_dump .trace .file{font-size:11px}.cf_dump .cfdump_array,.cf_dump .cfdump_query,.cf_dump .cfdump_struct,.cf_dump .cfdump_xml{color:##000}
			</style>

			<script>
				document.addEventListener("DOMContentLoaded",function(){if(void 0===window.__cf_dump_head){var e;window.__cf_dump_head=!0;for(var t=document.querySelectorAll(".cf_dump .colheader"),l=0;l<t.length;l++)t[l].addEventListener("click",function(e){"A"!==e.target.nodeName&&function(e,t){var l,c;if(null===e.getAttribute("data-cf_dump_collapsed")){for(l=0;l<t.length;l++)((c=t[l]).classList.contains("row")||c.classList.contains("colfooter"))&&c.classList.add("hidden");e.setAttribute("data-cf_dump_collapsed","")}else{for(l=0;l<t.length;l++)((c=t[l]).classList.contains("row")||c.classList.contains("colfooter"))&&c.classList.remove("hidden");
				e.removeAttribute("data-cf_dump_collapsed")}}(this,this.parentNode.children)}),(e=t[l].querySelector("a.toggle"))&&e.addEventListener("click",function(){for(var e=this.parentNode.parentNode.children,t=1;t<e.length;t++){var l,c=e[t],d=2===c.children.length?c.children[0]:void 0,n=d?c.children[1].children[0]:c.children[0].children[0];d&&n.classList.contains("empty")?r(d,c.children):0<n.children.length&&((l=n.children[0].querySelector("a.toggle"))&&l.click())}});
				var c=document.querySelectorAll(".cf_dump .rowheader"),r=function(e,t){var l,c;if(null===e.getAttribute("data-cf_dump_collapsed")){for(l=0;l<t.length;l++)(c=t[l]).classList.contains("rowcell")&&c.classList.add("hidden");e.setAttribute("data-cf_dump_collapsed","")}else{for(l=0;l<t.length;l++)(c=t[l]).classList.contains("rowcell")&&c.classList.remove("hidden");e.removeAttribute("data-cf_dump_collapsed")}};for(l=0;l<c.length;l++)c[l].addEventListener("click",function(){var e,t=this,l=t.getAttribute("data-cf_dump_querycolumn");e=null!==t.getAttribute("data-cf_dump_querycolumn")?t.parentNode.parentNode.querySelectorAll('.rowcell[data-cf_dump_querycell="'+l+'"]'):t.parentNode.children,r(t,e)})}});
			</script>

		</cfif>

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

			<div class="var null lowkey empty">
				<div class="col colheader">
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

			<cfset LOCAL.type    = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.subType = "">

			<cfset LOCAL.title = "">

			<cfswitch expression="#LOCAL.type#">

				<cfcase value="java.lang.Boolean">

					<cfset LOCAL.type     = "boolean">
					<cfset LOCAL.cssClass = "boolean">

					<cfset ARGUMENTS.var = ( ARGUMENTS.var ? "true" : "false" )>

				</cfcase>

				<cfcase value="java.lang.Byte">

					<cfset LOCAL.type     = "byte">
					<cfset LOCAL.subType  = "HEX">
					<cfset LOCAL.cssClass = "byte">

					<cfset ARGUMENTS.var = VARIABLES.String.format("%02X", [ ARGUMENTS.var ])>

				</cfcase>

				<cfcase value="java.lang.Double">

					<cfset LOCAL.type     = "numeric">
					<cfset LOCAL.subType  = "double">
					<cfset LOCAL.cssClass = "numeric">

				</cfcase>

				<cfcase value="java.lang.String">

					<cfset LOCAL.len = len(ARGUMENTS.var)>
					<cfset LOCAL.cps = ARGUMENTS.var.codePointCount(0, LOCAL.len)>

					<cfif LOCAL.len eq LOCAL.cps>
						<cfset LOCAL.type = "string [#LOCAL.len#]">
					<cfelse>
						<cfset LOCAL.type = "string [chars: #LOCAL.len#, codepoints: #LOCAL.cps#]">
					</cfif>

					<cfset LOCAL.cssClass = "string">

					<cfif LOCAL.len>

						<!--- whitespace warning --->
						<cfif (
							(not ATTRIBUTES.pre) and
							VARIABLES.wsInspectVal
						)>

							<cfset LOCAL.val = replaceWS(ARGUMENTS.var)>

							<cfif not isNull(LOCAL.val)>

								<cfset LOCAL.title     = "This string contains leading or trailing whitespaces, usually unintended. All whitespaces have been replaced with a dot.">
								<cfset LOCAL.cssClass &= " whitespace">

								<cfset ARGUMENTS.var = LOCAL.val>

							</cfif>

						</cfif>

					<cfelse>

						<cfset LOCAL.cssClass &= " lowkey empty">
						<cfset ARGUMENTS.var   = "[empty string]">

					</cfif>

				</cfcase>

				<cfcase value="java.lang.Integer">

					<cfset LOCAL.type     = "numeric">
					<cfset LOCAL.subType  = "integer">
					<cfset LOCAL.cssClass = "numeric">

				</cfcase>

				<cfcase value="java.lang.Long">

					<cfset LOCAL.type     = "numeric">
					<cfset LOCAL.subType  = "long">
					<cfset LOCAL.cssClass = "numeric">

				</cfcase>

				<cfdefaultcase>
					<cfset LOCAL.cssClass = "simple">
				</cfdefaultcase>

			</cfswitch>

			<div <cfif len(LOCAL.title)>title="#encodeForHtmlAttribute(LOCAL.title)#"</cfif> class="var #LOCAL.cssClass#">
				<div class="col colheader">
					<span class="type">#encodeForHtml(LOCAL.type)#</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
				</div>
				<div class="row">
					<div class="rowcell">
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

			<cfset LOCAL.subType  = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = arrayLen(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div class="var array lowkey">
					<div class="col colheader">
						<span class="type">array</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div class="row">
						<div class="rowcell">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<div class="var array lowkey empty">
					<div class="col colheader">
						<span class="type">array [0]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
					</div>
					<div class="row">
						<div class="rowcell">
							[empty array]
						</div>
					</div>
				</div>

			<cfelse>

				<cfset VARIABLES.resolvedVars[LOCAL.identity] = LOCAL.subType>

				<cfset isByteArray = (LOCAL.subType eq "[B")>
				<cfset showValues  = ((not isByteArray) or (LOCAL.len lte ATTRIBUTES.byteMax))>

				<div class="var array">

					<div class="col colheader">
						<span class="type">array [#LOCAL.len#]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span> <a title="Toggle empty elements." class="toggle">🗜</a>
					</div>

					<cfif showValues>

						<!--- Byte[] --->
						<cfif isByteArray>

							<cfloop array="#ATTRIBUTES.byteEncoding#" index="LOCAL.encoding">

								<div class="row">
									<div class="rowheader" data-cf_dump_collapsed>
										#encodeForHtml( replace(uCase(LOCAL.encoding), "-", "‑", "ALL") )# <!--- force non-breaking hyphen --->
									</div>
									<div class="rowcell lowkey hidden">
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
									<div class="rowheader">
										#LOCAL.i#
									</div>
									<div class="rowcell lowkey">
										<div class="cellcontent">
											[top reached]
										</div>
									</div>
								</div>

								<cfbreak>

							</cfif>

							<div class="row">
								<div class="rowheader">
									#LOCAL.i#
								</div>
								<div class="rowcell">
									<cfif arrayIsDefined(ARGUMENTS.var, LOCAL.i)>
										#renderDump(ARGUMENTS.var[LOCAL.i], ARGUMENTS.depth)#
									<cfelse>
										#renderDump()#
									</cfif>
								</div>
							</div>

							<cfset LOCAL.i++>
						</cfloop>

					<cfelse>

						<div class="row">
							<div class="rowcell lowkey">
								[more than #ATTRIBUTES.byteMax# Bytes]
							</div>
						</div>

					</cfif>

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

				<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

					<div class="var component lowkey">
						<div class="col colheader">
							<span class="type">component</span> <span class="subtype">#encodeForHtml(LOCAL.meta.FullName)#</span>
						</div>
						<div class="row">
							<div class="rowcell">
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

						<div class="col colheader">
							<span class="type">component</span> <span class="subtype">#encodeForHtml(LOCAL.meta.FullName)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span> <a title="Toggle empty elements." class="toggle">🗜</a><br>
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
									<div class="rowheader">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div class="rowcell lowkey">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = ARGUMENTS.var[LOCAL.field]>

								<div class="row">
									<div class="rowheader">
										#encodeForHtml(LOCAL.field)#
									</div>
									<div class="rowcell">
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
									<div class="rowheader">
										<span title="This field is private and can only be accessed from inside the component.">
											👁&nbsp;#encodeForHtml(LOCAL.field)#
										</span>
									</div>
									<div class="rowcell lowkey">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>
								</div>

							<cfelse>

								<cfset LOCAL.element = LOCAL.privateScope[LOCAL.field]>

								<div class="row">
									<div class="rowheader">
										<span title="This field is private and can only be accessed from inside the component.">
											👁&nbsp;#encodeForHtml(LOCAL.field)#
										</span>
									</div>
									<div class="rowcell">
										#renderDump(LOCAL.element, ARGUMENTS.depth)#
									</div>
								</div>

							</cfif>

						</cfloop>

					</div>

				</cfif>

			<!--- object --->
			<cfelse>

				<cfset LOCAL.meta    = ARGUMENTS.var.getClass()>
				<cfset LOCAL.subType = getClassName(ARGUMENTS.var)>

				<cfset LOCAL.docsLink = "">
				<cfif find("java.", LOCAL.subType) eq 1>
					<cfset LOCAL.docsLink = "https://docs.oracle.com/en/java/javase/11/docs/api/java.base/#replace(LOCAL.subType, ".", "/", "ALL")#.html">
				</cfif>

				<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

					<div class="var object lowkey">
						<div class="col colheader">
							<cfif len(LOCAL.docsLink)>
								<span class="type">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" class="subtype">#encodeForHtml(LOCAL.subType)#</a>
							<cfelse>
								<span class="type">object</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
							</cfif>
						</div>
						<div class="row">
							<div class="rowcell">
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
							<div class="col colheader">
								ColdFusion Exception <a title="Toggle empty elements." class="toggle">🗜</a>
							</div>
							<div class="row">
								<div class="rowheader">
									Type
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getType(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row">
								<div class="rowheader">
									Message
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getMessage(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row">
								<div class="rowheader">
									Detail
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getDetail(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row trace">
								<div class="rowheader">
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
									<div class="rowheader">
										#LOCAL.exceptionField#
									</div>
									<div class="rowcell">
										#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
									</div>
								</div>

							</cfloop>
							<div class="row trace">
								<div class="rowheader">
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

					<!--- check for other exceptions (Java) --->
					<cfelseif isInstanceOf(ARGUMENTS.var, "java.lang.Exception")>

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
							<div class="col colheader">
								Java Exception <a title="Toggle empty elements." class="toggle">🗜</a>
							</div>
							<div class="row">
								<div class="rowheader">
									Message
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var.getMessage(), ARGUMENTS.depth)#
								</div>
							</div>
							<div class="row trace">
								<div class="rowheader">
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
									<div class="rowheader">
										#LOCAL.exceptionField#
									</div>
									<div class="rowcell">
										#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
									</div>
								</div>

							</cfloop>
							<div class="row trace">
								<div class="rowheader">
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
							<div class="col colheader">
								<cfif len(LOCAL.docsLink)>
									<span class="type">object</span> <a href="#encodeForHtmlAttribute(docsLink)#" target="_blank" rel="noopener noreferrer" class="subtype">#encodeForHtml(LOCAL.subType)#</a> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
								<cfelse>
									<span class="type">object</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
								</cfif>
							</div>
							<cfif not arrayIsEmpty(LOCAL.constructors)>
								<div class="row">
									<div class="rowheader">
										<span class="type">constructors</span>
									</div>
									<div class="rowcell">
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
									<div class="rowheader">
										<span class="type">fields</span>
									</div>
									<div class="rowcell">
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
									<div class="rowheader">
										<span class="type">methods</span>
									</div>
									<div class="rowcell">
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

			<cfif isXmlDoc(ARGUMENTS.var)>

				<div class="var xml">
					<div class="col colheader">
						<span class="type">XmlDocument</span> <span class="subtype"></span> <a title="Toggle empty elements." class="toggle">🗜</a>
					</div>
					<div class="row">
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlRoot, ARGUMENTS.depth)#
						</div>
					</div>
				</div>

			<cfelse>

				<div class="var xml">
					<div class="col colheader">
						<span class="type">#( isXmlRoot(ARGUMENTS.var) ? "XmlRoot" : "XmlNode" )#</span> <a title="Toggle empty elements." class="toggle">🗜</a>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlName
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlName, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlNsPrefix
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlNsPrefix, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlNsURI
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlNsURI, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlText
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlText, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlComment
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlComment, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
							XmlAttributes
						</div>
						<div class="rowcell">
							#renderDump(ARGUMENTS.var.XmlAttributes, ARGUMENTS.depth)#
						</div>
					</div>
					<div class="row">
						<div class="rowheader">
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

			<cfset LOCAL.subType  = getClassName(ARGUMENTS.var)>
			<cfset LOCAL.identity = VARIABLES.System.identityHashCode(ARGUMENTS.var)>
			<cfset LOCAL.len      = structCount(ARGUMENTS.var)>

			<cfif structKeyExists(VARIABLES.resolvedVars, LOCAL.identity)>

				<div class="var struct lowkey">
					<div class="col colheader">
						<span class="type">struct</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span>
					</div>
					<div class="row">
						<div class="rowcell">
							[references @#encodeForHtml(LOCAL.identity)#]
						</div>
					</div>
				</div>

			<cfelseif not LOCAL.len>

				<div class="var struct lowkey empty">
					<div class="col colheader">
						<span class="type">struct [0]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span>
					</div>
					<div class="row">
						<div class="rowcell">
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

					<cfset LOCAL.exceptionFields = [
						"Type",
						"Message",
						"Detail",
						"TagContext",
						"StackTrace"
					]>

					<div class="var exception">
						<div class="col colheader">
							Lucee Exception  <a title="Toggle empty elements." class="toggle">🗜</a>
						</div>
						<div class="row">
							<div class="rowheader">
								Type
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Type, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row">
							<div class="rowheader">
								Message
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Message, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row">
							<div class="rowheader">
								Detail
							</div>
							<div class="rowcell">
								#renderDump(ARGUMENTS.var.Detail, ARGUMENTS.depth)#
							</div>
						</div>
						<div class="row trace">
							<div class="rowheader">
								TagContext
							</div>
							<div class="rowcell">
								<div class="cellcontent">

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
						</div>

						<cfset LOCAL.sortedKeys = structKeyArray(ARGUMENTS.var)>
						<cfset arraySort(LOCAL.sortedKeys, "TEXTnoCASE")>

						<cfloop array="#LOCAL.sortedKeys#" index="LOCAL.exceptionField">

							<cfif arrayFindNoCase(LOCAL.exceptionFields, LOCAL.exceptionField)>
								<cfcontinue>
							</cfif>

							<div class="row">
								<div class="rowheader">
									#LOCAL.exceptionField#
								</div>
								<div class="rowcell">
									#renderDump(ARGUMENTS.var[LOCAL.exceptionField], ARGUMENTS.depth)#
								</div>
							</div>

						</cfloop>

						<div class="row trace">
							<div class="rowheader">
								StackTrace
							</div>
							<div class="rowcell">
								<div class="cellcontent">

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

					<div class="var struct">

						<div class="col colheader">
							<span class="type">struct [#LOCAL.len#]</span> <span class="subtype">#encodeForHtml(LOCAL.subType)#</span> <span class="ref">@#encodeForHtml(LOCAL.identity)#</span> <a title="Toggle empty elements." class="toggle">🗜</a>
						</div>

						<cfloop collection="#ARGUMENTS.var#" item="LOCAL.key">

							<cfset LOCAL.printedKey = LOCAL.key>
							<cfset LOCAL.title      = "">
							<cfset LOCAL.cssClass   = "">

							<!--- whitespace warning --->
							<cfif VARIABLES.wsInspectKey>

								<cfset LOCAL.val = replaceWS(LOCAL.key)>

								<cfif not isNull(LOCAL.val)>

									<cfset LOCAL.title    = "This key contains leading or trailing whitespaces, usually unintended. All whitespaces have been replaced with a dot.">
									<cfset LOCAL.cssClass = "whitespace">

									<cfset LOCAL.printedKey = LOCAL.val>

								</cfif>

							</cfif>

							<div class="row">

								<div <cfif len(LOCAL.title)>title="#encodeForHtmlAttribute(LOCAL.title)#"</cfif> class="rowheader #LOCAL.cssClass#">
									<!--- ACF uses legacy ESAPI that cannot handle all codepoints properly --->
									#encodeForHtml(LOCAL.printedKey)#
								</div>

								<cfif arrayFindNoCase(ATTRIBUTES.blacklist, LOCAL.key)>

									<div class="rowcell lowkey">
										<div class="cellcontent">
											[blacklisted]
										</div>
									</div>

								<cfelseif structKeyExists(ARGUMENTS.var, LOCAL.key)>

									<div class="rowcell">
										#renderDump(ARGUMENTS.var[LOCAL.key], ARGUMENTS.depth)#
									</div>

								<!--- null value --->
								<cfelse>

									<div class="rowcell">
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

					<div class="col colheader">
						<span class="type">query [#LOCAL.len#]</span>
					</div>
					<div class="row">
						<div class="rowheader">
						</div>
						<cfloop array="#LOCAL.columns#" index="LOCAL.column">
							<div data-cf_dump_querycolumn="#encodeForHtmlAttribute(LOCAL.column)#" class="rowheader" style="width: #LOCAL.columnWidth#%;">
								#encodeForHtml(LOCAL.column)#
							</div>
						</cfloop>
					</div>

					<cfloop query="#ARGUMENTS.var#">

						<!--- top (maximum rows) --->
						<cfif (ATTRIBUTES.top gte 0) and (ARGUMENTS.var.currentRow gt ATTRIBUTES.top)>

							<div class="row">
								<div class="rowheader">
									#ARGUMENTS.var.currentRow#
								</div>
								<cfloop array="#LOCAL.columns#" index="LOCAL.column">
									<div data-cf_dump_querycell="#encodeForHtmlAttribute(LOCAL.column)#" class="rowcell lowkey" style="width: #LOCAL.columnWidth#%;">
										<div class="cellcontent">
											[top reached]
										</div>
									</div>
								</cfloop>
							</div>

							<cfbreak>

						</cfif>

						<div class="row">
							<div class="rowheader">
								#ARGUMENTS.var.currentRow#
							</div>
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<div data-cf_dump_querycell="#encodeForHtmlAttribute(LOCAL.column)#" class="rowcell" style="width: #LOCAL.columnWidth#%;">
									#renderDump(ARGUMENTS.var[LOCAL.column][ARGUMENTS.var.currentRow], ARGUMENTS.depth)#
								</div>
							</cfloop>
						</div>

					</cfloop>

				</div>

			<cfelse>

				<div class="var query lowkey empty">
					<div class="col colheader">
						<span class="type">query [0]</span>
					</div>
					<cfif LOCAL.columnCount>
						<div class="row">
							<cfloop array="#LOCAL.columns#" index="LOCAL.column">
								<div class="rowheader" style="width: #LOCAL.columnWidth#%;">
									#encodeForHtml(LOCAL.column)#
								</div>
							</cfloop>
						</div>
					</cfif>
					<div class="colfooter">
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
