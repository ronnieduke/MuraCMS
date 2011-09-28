<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.attributeID=0/>
<cfset variables.instance.ExtendSetID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.hint=""/>
<cfset variables.instance.type="TextBox"/>
<cfset variables.instance.orderno=1/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.required="false"/>
<cfset variables.instance.validation=""/>
<cfset variables.instance.regex=""/>
<cfset variables.instance.message=""/>
<cfset variables.instance.label=""/>
<cfset variables.instance.defaultValue=""/>
<cfset variables.instance.optionList=""/>
<cfset variables.instance.optionLabelList=""/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="contentRenderer">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.contentRenderer=arguments.contentRenderer />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfreturn this />
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.data)>
		
			<cfset setAttributeID(arguments.data.attributeID) />
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setExtendSetID(arguments.data.ExtendSetID) />
			<cfset setName(arguments.data.name) />
			<cfset setHint(arguments.data.name) />
			<cfset setType(arguments.data.Type) />
			<cfset setOrderNo(arguments.data.orderno) />
			<cfset setIsActive(arguments.data.isActive) />
			<cfset setRequired(arguments.data.required) />
			<cfset setvalidation(arguments.data.validation) />
			<cfset setRegex(arguments.data.regex) />
			<cfset setMessage(arguments.data.Message) />
			<cfset setLabel(arguments.data.label) />
			<cfset setDefaultValue(arguments.data.DefaultValue) />
			<cfset setOptionList(arguments.data.optionList) />
			<cfset setOptionLabelList(arguments.data.optionLabelList) />
			
		<cfelseif isStruct(arguments.data)>
		<!--- <cfdump var="#arguments.data#"><cfabort> --->
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
			
		<!--- 	<cfif getType eq "radio" or getType() eq "select">
				<cfset setOptions(arguments.data)/>
			</cfif> --->
			
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>
  
<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getAttributeID" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.attributeID />
</cffunction>

<cffunction name="setAttributeID" access="public" output="false">
	<cfargument name="AttributeID" type="numeric" />
	<cfset variables.instance.AttributeID =arguments.AttributeID />
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSetID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ExtendSetID />
</cffunction>

<cffunction name="setExtendSetID" access="public" output="false">
	<cfargument name="ExtendSetID" type="String" />
	<cfset variables.instance.ExtendSetID = trim(arguments.ExtendSetID) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getHint" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Hint />
</cffunction>

<cffunction name="setHint" access="public" output="false">
	<cfargument name="Hint" type="String" />
	<cfset variables.instance.Hint = trim(arguments.Hint) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfreturn this>
</cffunction>

<cffunction name="getOrderNo" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.OrderNo />
</cffunction>

<cffunction name="setOrderNo" access="public" output="false">
	<cfargument name="OrderNo" />
	<cfif isNumeric(arguments.OrderNo)>
	<cfset variables.instance.OrderNo = arguments.OrderNo />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="IsActive" />
	<cfif isNumeric(arguments.isActive)>
		<cfset variables.instance.IsActive = arguments.IsActive />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getRequired" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Required />
</cffunction>

<cffunction name="setRequired" access="public" output="false">
	<cfargument name="Required" type="String" />
	<cfset variables.instance.Required = trim(arguments.Required) />
	<cfreturn this>
</cffunction>

<cffunction name="getValidation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.validation />
</cffunction>

<cffunction name="setValidation" access="public" output="false">
	<cfargument name="validation" type="String" />
	<cfset variables.instance.validation = trim(arguments.validation) />
	<cfreturn this>
</cffunction>

<cffunction name="getRegex" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Regex />
</cffunction>

<cffunction name="setRegex" access="public" output="false">
	<cfargument name="Regex" type="String" />
	<cfset variables.instance.Regex = trim(arguments.Regex) />
	<cfreturn this>
</cffunction>

<cffunction name="getMessage" returntype="String" access="public" output="false">
	
	<cfreturn variables.instance.Message />
	
</cffunction>

<cffunction name="setMessage" access="public" output="false">
	<cfargument name="Message" type="String" />
	<cfset variables.instance.Message = trim(arguments.Message) />
	<cfreturn this>
</cffunction>

<cffunction name="getLabel" returntype="String" access="public" output="false">
	<cfif len(variables.instance.Label)>
	<cfreturn variables.instance.Label />
	<cfelse>
	<cfreturn variables.instance.name />
	</cfif>
</cffunction>

<cffunction name="setLabel" access="public" output="false">
	<cfargument name="Label" type="String" />
	<cfset variables.instance.Label = trim(arguments.Label) />
	<cfreturn this>
</cffunction>

<cffunction name="getDefaultValue" returntype="String" access="public" output="false">
	<cfreturn variables.instance.DefaultValue />
</cffunction>

<cffunction name="setDefaultValue" access="public" output="false">
	<cfargument name="DefaultValue" type="String" />
	<cfset variables.instance.DefaultValue = trim(arguments.DefaultValue) />
</cffunction>

<cffunction name="getOptionList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.optionList />
</cffunction>

<cffunction name="setOptionList" access="public" output="false">
	<cfargument name="OptionList" type="String" />
	<cfset variables.instance.OptionList = trim(arguments.OptionList) />
	<cfreturn this>
</cffunction>

<cffunction name="getOptionLabelList" returntype="String" access="public" output="false">
	<cfreturn variables.instance.OptionLabelList />
</cffunction>

<cffunction name="setOptionLabelList" access="public" output="false">
	<cfargument name="OptionLabelList" type="String" />
	<cfset variables.instance.OptionLabelList = trim(arguments.OptionLabelList) />
	<cfreturn this>
</cffunction>

<cffunction name="load"  access="public" output="false">
<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tclassextendattributes where 
	<cfif getAttributeID()>
	attributesID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAttributeID()#">
	<cfelse>
	extendSetID=<cfqueryparam cfsqltype="cf_sql_char" maxlength="35" value="#getExtendSetID()#">
	and name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#getName()#">
	</cfif>
	</cfquery>
	
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="save"  access="public" output="false">
<cfset var rs=""/>
	
	
	<cfif getAttributeID()>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tclassextendattributes set
		ExtendSetID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getExtendSetID() neq '',de('no'),de('yes'))#" value="#getExtendSetID()#">,
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
		hint=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getHint() neq '',de('no'),de('yes'))#" value="#getHint()#">,
		type=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		isActive=#getIsActive()#,
		orderno=#getOrderno()#,
		required=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRequired() neq '',de('no'),de('yes'))#" value="#getRequired()#">,
		validation=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getvalidation() neq '',de('no'),de('yes'))#" value="#getvalidation()#">,
		regex=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRegex() neq '',de('no'),de('yes'))#" value="#getRegex()#">,
		message=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getMessage() neq '',de('no'),de('yes'))#" value="#getMessage()#">,
		label=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getLabel() neq '',de('no'),de('yes'))#" value="#getLabel()#">,
		defaultValue=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDefaultValue() neq '',de('no'),de('yes'))#" value="#getDefaultValue()#">,
		optionList=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionList() neq '',de('no'),de('yes'))#" value="#getOptionList()#">,
		optionLabelList=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionLabelList() neq '',de('no'),de('yes'))#" value="#getOptionLabelList()#">
		where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
		</cfquery>
		
	<cfelse>
	
		<cflock name="addingAttribute" scope="application" timeout="100">
			
			<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			Insert into tclassextendattributes (ExtendSetID,siteID,name,hint,type,isActive,orderno,required,validation,regex,message,label,defaultValue,optionList,optionLabelList) 
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getExtendSetID() neq '',de('no'),de('yes'))#" value="#getExtendSetID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getName() neq '',de('no'),de('yes'))#" value="#getName()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getHint() neq '',de('no'),de('yes'))#" value="#getHint()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
			#getIsActive()#,
			#getOrderno()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRequired() neq '',de('no'),de('yes'))#" value="#getRequired()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getvalidation() neq '',de('no'),de('yes'))#" value="#getvalidation()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getRegex() neq '',de('no'),de('yes'))#" value="#getRegex()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getMessage() neq '',de('no'),de('yes'))#" value="#getMessage()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getLabel() neq '',de('no'),de('yes'))#" value="#getLabel()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDefaultValue() neq '',de('no'),de('yes'))#" value="#getDefaultValue()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionList() neq '',de('no'),de('yes'))#" value="#getOptionList()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getOptionLabelList() neq '',de('no'),de('yes'))#" value="#getOptionLabelList()#">
			)
			</cfquery>
			
			<cfquery name="rs"  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select max(attributeID) as newID  from tclassextendattributes
			</cfquery>
			
			<cfset setAttributeID(rs.newID)/>
		
		</cflock>
	</cfif>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	
	<cfreturn this>
	<!--- <cfset saveOptions() /> --->
</cffunction>

<cffunction name="delete" access="public">
<cfset var fileManager=getBean("fileManager") />	
<cfset var rs =""/>
	
	<cftransaction>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select attributeValue,baseID from tclassextenddata
	inner join tclassextendattributes on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
	where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	and attributeValue is not null
	and tclassextendattributes.type='File'
	</cfquery>
	
	<cfloop query="rs">
		<cfset fileManager.deleteIfNotUsed(rs.attributeValue,rs.baseID) />
	</cfloop>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextenddata
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select attributeValue,baseID from tclassextenddatauseractivity
	inner join tclassextendattributes on (tclassextenddatauseractivity.attributeID=tclassextendattributes.attributeID)
	where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	and attributeValue is not null
	and tclassextendattributes.type='File'
	</cfquery>
	
	<cfloop query="rs">
		<cfset fileManager.deleteIfNotUsed(rs.attributeValue,rs.baseID) />
	</cfloop>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextenddatauseractivity
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextendattributes
	where attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#getAttributeID()#">
	</cfquery>
	</cftransaction>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
</cffunction>

<cffunction name="renderAttribute" output="false" returntype="string">
<cfargument name="theValue" required="true" default="useMuraDefault"/>
<cfset var renderValue= arguments.theValue />
<cfset var optionValue= "" />
<cfset var str=""/>
<!---<cfset var key="ext#replace(getAttributeID(),'-','','ALL')#"/>--->
<cfset var key=getName() />
<cfset var o=0/>
<cfset var optionlist=""/>
<cfset var optionLabellist=""/>
<cfset var renderInstanceValue=renderValue>
<cfif renderValue eq "useMuraDefault">
	<cfset renderValue=variables.contentRenderer.setDynamicContent(getDefaultValue()) />
</cfif>

<cfif getValidation() eq "Date">
	<cfset renderValue=lsDateFormat(renderValue,session.dateKeyFormat) />
</cfif>

<cfswitch expression="#getType()#">
<cfcase value="Hidden">
<cfsavecontent variable="str"><cfoutput><input type="hidden" name="#key#" id="#key#" label="#XMLFormat(getlabel())#" value="#HTMLEditFormat(renderValue)#" /></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="TextBox">
<cfsavecontent variable="str"><cfoutput><input type="text" name="#key#" class="text<cfif getValidation() eq 'date'> datepicker</cfif>" id="#key#" label="#XMLFormat(getlabel())#" value="#HTMLEditFormat(renderValue)#" required="#getRequired()#"<cfif len(getvalidation())> validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> regex="#getRegex()#"</cfif><cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif> /></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="TextArea,HTMLEditor">
<cfsavecontent variable="str"><cfoutput><textarea name="#key#" id="#key#" label="#XMLFormat(getlabel())#" required="#getRequired()#"<cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif><cfif getType() eq "HTMLEditor"> class="htmlEditor"</cfif><cfif len(getvalidation())> validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> regex="#getRegex()#"</cfif>>#HTMLEditFormat(renderValue)#</textarea></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="SelectBox,MultiSelectBox">
<cfset optionlist=variables.contentRenderer.setDynamicContent(getOptionList())/>
<cfset optionLabellist=variables.contentRenderer.setDynamicContent(getOptionLabelList())/>
<cfsavecontent variable="str"><cfoutput><select name="#key#" id="#key#" label="#XMLFormat(getlabel())#" required="#getRequired()#"<cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif><cfif getType() eq "MultiSelectBox"> multiple="multiple"</cfif>><cfif listLen(optionlist,'^')><cfloop from="1" to="#listLen(optionlist,'^')#" index="o"><cfset optionValue=listGetAt(optionlist,o,'^') /><option value="#XMLFormat(optionValue)#"<cfif optionValue eq renderValue or listFind(renderValue,optionValue,"^") or listFind(renderValue,optionValue)> selected="selected"</cfif>><cfif len(optionlabellist)>#listGetAt(optionlabellist,o,'^')#<cfelse>#optionValue#</cfif></option></cfloop></cfif></select></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="RadioGroup">
<cfset optionlist=variables.contentRenderer.setDynamicContent(getOptionList())/>
<cfset optionLabellist=variables.contentRenderer.setDynamicContent(getOptionLabelList())/>
<cfsavecontent variable="str"><cfoutput><cfif listLen(optionlist,'^')><cfloop from="1" to="#listLen(optionlist,'^')#" index="o"><cfset optionValue=listGetAt(optionlist,o,'^') /><input type="radio" id="#key#" name="#key#" value="#XMLFormat(optionValue)#"<cfif optionValue eq renderValue> checked="checked"</cfif> /> <cfif len(optionlabellist)>#listGetAt(optionlabellist,o,'^')#<cfelse>#optionValue#</cfif> </cfloop></cfif></cfoutput></cfsavecontent>
</cfcase>
<cfcase value="File">
<cfsavecontent variable="str"><cfoutput><input type="file" name="#key#" id="#key#" label="#XMLFormat(getlabel())#" value="" required="#getRequired()#"<cfif len(getvalidation())> validate="#getValidation()#"</cfif><cfif getvalidation() eq "Regex"> regex="#getRegex()#"</cfif><cfif len(getMessage())> message="#XMLFormat(getMessage())#"</cfif>/></cfoutput></cfsavecontent>
</cfcase>
</cfswitch>

<cfreturn str/>
</cffunction>

<!--- 
<cffunction name="getOptions" access="public" returntype="query">
	<cfset var rs = "" />

	<cfif not isQuery(variables.instance.options)>
		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select * from TClassExtendAttributeOptions
		where attributeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getAttributeID()#">
		order by orderno 
		</cfquery>
		
		<cfset variables.instance.options=rs />
	</cfif>

	<cfreturn variables.instance.options />

</cffunction>

<cffunction name="setOptions" access="public">
<cfargument name="options">
<cfset var o=1/>

<cfif isQuery(arguments.options)>
	<cfset variables.instance.options=arguments.options />
<cfelse>
	<cfset variables.instance.options=queryNew("optionID,attributeID,siteID,optionValue,label,orderno","cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar,cf_sql_varchar") />

	<cfloop condition="structkeyExist(arguments.options,'options#o#')">
	
		<cfif len(arguments.options["label#o#"])
			or len(arguments.options["optionValue#o#"])>
			
			<cfset querySetCell(variables.instance.options,"optionID",createUUID(),o) />
			<cfset querySetCell(variables.instance.options,"attributeID",getAttributeID(),o) />
			<cfset querySetCell(variables.instance.options,"siteID",getSiteID(),o) />
			<cfset querySetCell(variables.instance.options,"orderno",o,o) />
			<cfset querySetCell(variables.instance.options,"label",arguments.options["label#o#"],o) />
			<cfset querySetCell(variables.instance.options,"optionValue",arguments.options["optionValue#o#"],o) />

		</cfif>
	<cfset o=o+1/>
	</cfloop>
</cfif>

</cffunction>

<cffunction name="deleteOptions">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from TExtendAttributeOptions
		where attributeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getAttributeID()#">
	</cfquery>
</cffunction>

<cffunction name="saveOptions" access="public">
	<cfif isQuery(variables.instance.options)>
		<cfset deleteOptions() />
		
		<cfloop query="variables.instance.options">
			<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into TClassExtendAttributeOptions
			(optionID,attributeID,siteID,optionValue,label,orderno)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.optionID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.attributeID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.options.siteID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.options.optionValue neq '',de('no'),de('yes'))#" value="#variables.instance.options.optionValue#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(variables.instance.options.label neq '',de('no'),de('yes'))#" value="#variables.instance.options.label#">,
				variables.instance.options.orderno
			)
			</cfquery>
		</cfloop>

	</cfif>
	
</cffunction> --->

</cfcomponent>