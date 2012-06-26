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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset pageLevelList="Page,Portal,Calendar,Gallery"/>
<cfset extendedList="Page,Portal,Calendar,Gallery,Link,File,Component"/>
<cfset isExtended=false>
<cfset nodeLevelList="Page,Portal,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>
<cfset rc.perm=application.permUtility.getnodePerm(rc.crumbdata)>
<cfif rc.parentID eq "" and not rc.contentBean.getIsNew()>
	<cfset rc.parentID=rc.contentBean.getParentID()>	
 </cfif>
<cfif hasChangesets>
<cfset currentChangeset=application.changesetManager.read(rc.contentBean.getChangesetID())>
<cfset pendingChangesets=application.changesetManager.getPendingByContentID(rc.contentBean.getContentID(),rc.siteID)>
</cfif>
<cfset rc.deletable=rc.compactDisplay neq "true" and ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getLocking() eq 'none')) and (rc.perm eq 'editor' and rc.contentid neq '00000000000000000000000000000000001') and rc.contentBean.getIsLocked() neq 1>
<cfset assignChangesets=rc.perm eq 'editor' and hasChangesets>
<cfset $=event.getValue("MuraScope")>
<cfset tabAssignments=$.getBean("user").loadBy(userID=session.mura.userID, siteID=session.mura.siteID).getContentTabAssignments()>
<script>
var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts()><cfoutput>'#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfif rc.compactDisplay neq "true" and application.configBean.getConfirmSaveAsDraft()><script>
var requestedURL="";
var formSubmitted=false;
onload=function(){
	var anchors=document.getElementsByTagName("A");
	
	for(var i=0;i<anchors.length;i++){		
		if (typeof(anchors[i].onclick) != 'function' && jQuery(anchors[i]).attr("href") !='#') {
   			anchors[i].onclick = setRequestedURL;
		}
	}
	
}

onunload=function(){
	if(!formSubmitted && requestedURL != '')
	{
		conditionalExit();
	}
}

function conditionalExit(msg){
	if(form_is_modified(document.contentForm)){
	if(msg==null){
		<cfoutput>msg="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#";</cfoutput>
	}
	jQuery("#alertDialog").html(msg);
	jQuery("#alertDialog").dialog({
			resizable: false,
			modal: true,
			position: getDialogPosition(),
			buttons: {
				'Yes': function() {
					jQuery(this).dialog('close');
					if(ckContent()){
						document.getElementById('contentForm').returnURL.value=requestedURL;
						submitForm(document.contentForm,'add');
						}
						return false;
					},
				'No': function() {
					jQuery(this).dialog('close');
					location.href=requestedURL;
					requestedURL="";
				}
			}
		});
	
		return false;	
		
	} else {
		requestedURL="";
		return true;	
	}

}
<cfoutput>
function setRequestedURL(){
	requestedURL=this.href
	return conditionalExit("#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#");
}</cfoutput>
</script>
<cfelseif rc.compactDisplay eq "true">
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
				}
			);	
		} else {
			frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
		}
	}
});
</script>
</cfif> 

<cfset subtype=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid)>
<cfoutput>
<script type="text/javascript">
var hasSummary=#subType.getHasSummary()#;
var hasBody=#subType.getHasBody()#;
</script>
</cfoutput>

<cfsilent>
	<cfif rc.contentBean.getType() eq 'File'>
	<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(rc.contentBean.getFileID())>
	<cfset fileExt=rsFile.fileExt>
	<cfelse>
	<cfset fileExt=''/>
	</cfif>
	<cfif listFindNoCase(extendedList,rc.type)>
		<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />
		<cfif rc.compactDisplay neq "true" and listFindNoCase("#pageLevelList#",rc.type)>
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where 
				type in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#pageLevelList#"/>)
				or type='Base'
			</cfquery>
		<cfelse>
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where 
				type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.type#"/>
				<!---<cfif listFindNocase("Link,File",rc.type)>--->
					or type='Base'
				<!---</cfif>--->
			</cfquery>
		</cfif>
		<cfif listFindNoCase("Component,File,Link",rc.type)>
			<cfset baseTypeList=rc.type>
		<cfelse>
			<cfset baseTypeList=pageLevelList>
		</cfif>
		
		<!--- If the node is new check to see if the parent type has a matching sub type. --->
		<cfif rc.contentBean.getIsNew()>
			<cfquery name="rsParentSubType" dbtype="query">
			select * from rsSubTypes
			where 
			type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.type#"/>
			and subtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#$.getBean('content').loadBy(contentID=rc.parentID, siteID=rc.siteID).getSubType()#"/>
			</cfquery>
			<cfif rsParentSubType.recordcount>
				<cfset rc.contentBean.setSubType(rsParentSubType.subType)>
			</cfif>
		</cfif>
		
		<cfif rsSubTypes.recordCount>
			<cfset isExtended=true/>
		<cfelse>
			<cfset isExtended=false/>
		</cfif>
	</cfif>
	
	<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",rc.type)>
	<cfset rsPluginScripts1=application.pluginManager.getScripts("onContentEdit",rc.siteID)>
	<cfset rsPluginScripts2=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID)>
	<cfquery name="rsPluginScripts3" dbtype="query">
	select * from rsPluginScripts1 
	union
	select * from rsPluginScripts2 
	</cfquery>
	<cfquery name="rsPluginScripts" dbtype="query">
	select * from rsPluginScripts3 order by pluginID
	</cfquery>
	<cfelse>
	<cfset rsPluginScripts=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID)>
	</cfif>
</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (rc.rsPageCount.counter lt application.settingsManager.getSite(rc.siteid).getpagelimit() and  rc.contentBean.getIsNew()) or not rc.contentBean.getIsNew()>
<cfoutput>
	<cfif rc.type eq "Component">
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcomponent")#</h2>
	<cfelseif rc.type eq "Form">
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editform")#</h2>
	<cfelse>
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcontent")#</h2>
	</cfif>
	
	<cfif rc.compactDisplay neq "true">
	<ul class="metadata">
		<cfif not rc.contentBean.getIsNew()>
			<cfif listFindNoCase('Page,Portal,Calendar,Gallery,Link,File',rc.type)>
				<cfset rsRating=application.raterManager.getAvgRating(rc.contentBean.getcontentID(),rc.contentBean.getSiteID()) />
				<cfif rsRating.recordcount>
				<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.votes")#: <strong><cfif rsRating.recordcount>#rsRating.theCount#<cfelse>0</cfif></strong></li>
				<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.averagerating")#: <img id="ratestars" src="images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="#rsRating.theAvg# stars" border="0"></li>
				</cfif>
			</cfif>
		<cfif rc.type eq "file" and rc.contentBean.getMajorVersion()>
				<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#: <strong>#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#</strong></li>
		</cfif>
		</cfif>
		<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.update")#: <strong>#LSDateFormat(parseDateTime(rc.contentBean.getlastupdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(rc.contentBean.getlastupdate()),"short")#</strong></li>
		<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.status")#: <strong><cfif not rc.contentBean.getIsNew()><cfif rc.contentBean.getactive() gt 0 and rc.contentBean.getapproved() gt 0>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#<cfelseif rc.contentBean.getapproved() lt 1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#</cfif></strong></li>
		<cfset started=false>
		<li>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#: <strong>#HTMLEditFormat(rc.type)#</strong>
		</li>
	</ul>
	</cfif>
	
	<cfif rc.compactDisplay eq "true" and not ListFindNoCase(nodeLevelList,rc.type)>
		<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</p>
	</cfif>
	
	<cfif not rc.contentBean.getIsNew()>
		<cfset draftcheck=application.contentManager.getDraftPromptData(rc.contentBean.getContentID(),rc.contentBean.getSiteID())>
		
		<cfif yesNoFormat(draftcheck.showdialog) and draftcheck.historyid neq rc.contentBean.getContentHistID()>
		<p class="notice">
		#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="./?#replace(cgi.query_string,'#rc.contentBean.getContentHistID()#','#draftcheck.historyid#')#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
		<p>
		</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
		<p class="notice">
		<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
		<cfloop query="pendingChangesets"><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.moduleID)#&siteID=#URLEncodedFormat(rc.siteID)#&topID=#URLEncodedFormat(rc.topID)#&contentID=#URLEncodedFormat(rc.contentID)#&return=#URLEncodedFormat(rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#URLEncodedFormat(rc.parentID)#&startrow=#URLEncodedFormat(rc.startrow)#&type=#URLEncodedFormat(rc.type)#">"#HTMLEditFormat(pendingChangesets.changesetName)#"</a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
		<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: "#HTMLEditFormat(currentChangeset.getName())#"</cfif>
		</p>
	</cfif>

	<cfif not structIsEmpty(rc.contentBean.getErrors())>
		<div class="error">#application.utility.displayErrors(rc.contentBean.getErrors())#</div>
	</cfif>
	<form novalidate="novalidate" action="index.cfm" method="post" enctype="multipart/form-data" name="contentForm" onsubmit="return ckContent(draftremovalnotice);" id="contentForm">
	
	<cfif rc.compactDisplay neq "true" and rc.moduleid eq '00000000000000000000000000000000000'>
		#application.contentRenderer.dspZoom(rc.crumbdata,fileExt)#
	</cfif>
	
	<!--- This is plugin message targeting --->	
	<span id="msg">
	<cfif not listFindNoCase("Component,Form",rc.type)>#application.pluginManager.renderEvent("onContentEditMessageRender", pluginEvent)#</cfif>
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()#EditMessageRender", pluginEvent)#
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()##rc.contentBean.getSubType()#EditMessageRender", pluginEvent)#
	</span>
	
	
	<cfif rc.compactDisplay neq "true" or not listFindNoCase(nodeLevelList,rc.type)>	
		<cfif rc.contentid neq "">
			<ul id="navTask">
			<cfif rc.compactDisplay neq "true" and (rc.contentBean.getfilename() neq '' or rc.contentid eq '00000000000000000000000000000000001')>
				<cfswitch expression="#rc.type#">
				<cfcase value="Page,Portal,Calendar,Gallery">
					<cfif not rc.contentBean.getIsNew()>
						<cfset currentBean=application.contentManager.getActiveContent(rc.contentID,rc.siteid) />
						<li><a href="##" onclick="return openPreviewDialog('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,currentBean.getfilename())#','#currentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					</cfif>
					<li><a href="##" onclick="return openPreviewDialog('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?previewid=#rc.contentBean.getcontenthistid()#&contentid=#rc.contentBean.getcontentid()#','#rc.contentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				<cfcase value="Link">
					<cfset currentBean=application.contentManager.getActiveContent(rc.contentID,rc.siteid) />
					<cfif not rc.contentBean.getIsNew()>
						<li><a href="##" onclick="return openPreviewDialog('#currentBean.getfilename()#','#currentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					</cfif>
					<li><a href="##" onclick="return openPreviewDialog('#rc.contentBean.getfilename()#','#rc.contentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				<cfcase value="File">	
					<li><a href="##" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.contentid#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					<li><a href="##" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#rc.contentBean.getFileID()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				</cfswitch>
			</cfif>
			<cfswitch expression="#rc.type#">
			<cfcase value="Form">
				<cfif listFind(session.mura.memberships,'S2IsPrivate')>
				<li><a href="index.cfm?muraAction=cArch.datamanager&contentid=#URLEncodedFormat(rc.contentid)#&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&moduleid=#rc.moduleid#&type=Form&parentid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.managedata")#</a></li>
				</cfif>
			</cfcase>
			</cfswitch>
			<li><a href="index.cfm?muraAction=cArch.hist&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&compactDisplay=#rc.compactDisplay#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.versionhistory")#</a> </li>
			<cfif rc.compactDisplay neq 'true' and rc.contentBean.getactive()lt 1 and (rc.perm neq 'none')><li><a href="index.cfm?muraAction=cArch.update&contenthistid=#URLEncodedFormat(rc.contenthistid)#&action=delete&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#&return=#rc.return#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deleteversionconfirm"))#',this.href)">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deleteversion")#</a></li></cfif>
			<cfif rc.deletable><li><a href="index.cfm?muraAction=cArch.update&action=deleteall&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.type#&parentid=#URLEncodedFormat(rc.parentid)#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#" 
			<cfif listFindNoCase(nodeLevelList,rc.contentBean.getType())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),rc.contentBean.getMenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deletecontentconfirm"))#',this.href)"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deletecontent")#</a></li></cfif>
			<cfif (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2'))><li><a href="index.cfm?muraAction=cPerm.main&contentid=#URLEncodedFormat(rc.contentid)#&type=#rc.contentBean.gettype()#&parentid=#rc.contentBean.getparentID()#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.permissions")#</a></li></cfif>
			</ul>
		</cfif>
	</cfif>
	
	<cfif rc.compactDisplay neq "true">
			<div class="selectContentType">
			<cfif listFindNoCase(pageLevelList,rc.type)>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
				<cfloop list="#baseTypeList#" index="t">
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</cfloop>
				</select>
			<cfelseif rc.type eq 'File'>
				<cfset t="File"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#t#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")# / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif rc.type eq 'Link'>	
				<cfset t="Link"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif rc.type eq 'Component'>	
				<cfset t="Component"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			</cfif>
		</div>
	</cfif>
	
	<cfif rc.compactDisplay eq "true">
		<cfif not listFindNoCase("Component,Form", rc.type)>
			<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rc.type#"> and subtype not in ('Default','default')</cfquery>
			<cfif rsst.recordcount>
					<cfset t=rc.type/>
					<cfsilent></cfsilent>
					<div class="selectContentType">
					<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
					<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#rc.contentBean.getcontentHistID()#',this.value,'#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');">
					<option value="#t#^Default" <cfif rc.type eq t and rc.contentBean.getSubType() eq "Default">selected</cfif>>#t#</option>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif rc.type eq t and rc.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#t#  / #rsst.subtype#</option>
					</cfloop>
					</select>	
					</div>								
			</cfif>
		</cfif>
			
		<input type="hidden" name="closeCompactDisplay" value="true" />
	</cfif>
	
	</cfoutput>
	
	<cfset tabLabelList=""/>
	<cfset tabList="">
	<cfsavecontent variable="tabContent">
	
		<cfif rc.type neq "Form">
			<cfinclude template="form/dsp_tab_basic.cfm">	
		<cfelse>
			<cfif rc.contentBean.getIsNew() and not (isdefined("url.formType") and url.formType eq "editor")>		
				<cfset rc.contentBean.setBody( application.serviceFactory.getBean('formBuilderManager').createJSONForm( rc.contentBean.getContentID() ) ) />
			</cfif>
			<cfif isJSON(rc.contentBean.getBody())>
				<cfinclude template="form/dsp_tab_formbuilder.cfm">
			<cfelse>
				<cfinclude template="form/dsp_tab_basic.cfm">
			</cfif>
		</cfif>
		
		<cfswitch expression="#rc.type#">
			<cfcase value="Page,Portal,Calendar,Gallery,File,Link">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Meta Data')>
			<cfinclude template="form/dsp_tab_meta.cfm">
			</cfif>
			</cfcase>
		</cfswitch>
			
		<cfswitch expression="#rc.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Content Objects')>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')>
			<cfinclude template="form/dsp_tab_objects.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
			<cfif application.categoryManager.getCategoryCount(rc.siteID)>
			<cfinclude template="form/dsp_tab_categories.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
			</cfif>
		</cfcase>
		<cfcase value="Link,File">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
			<cfif application.categoryManager.getCategoryCount(rc.siteid)>
			<cfinclude template="form/dsp_tab_categories.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
			</cfif>
		</cfcase>
		<cfcase value="Component">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
			<cfif not rc.contentBean.getIsNew()>
			<cfinclude template="form/dsp_tab_usage.cfm">
			</cfif>
			</cfif>		
		</cfcase>
		<cfcase value="Form">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
			<cfif not rc.contentBean.getIsNew()>
			<cfinclude template="form/dsp_tab_usage.cfm">
			</cfif>
			</cfif>
		</cfcase>
	</cfswitch>
	
	<cfswitch expression="#rc.type#">
		<cfcase value="Page,Portal,Calendar,Gallery,Link,File,Component">
		<cfif isExtended>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
			<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid).getExtendSets(activeOnly=true) />
			<cfinclude template="form/dsp_tab_extended_attributes.cfm">
			</cfif>
			<cfoutput>
			<script type="text/javascript">
			loadExtendedAttributes('#rc.contentbean.getcontentHistID()#','#rc.type#','#rc.contentBean.getSubType()#','#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');
			</script>
			</cfoutput>
		</cfif>
		</cfcase>
	</cfswitch>
		<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Advanced')>
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		<cfinclude template="form/dsp_tab_advanced.cfm">
		</cfif> 
		</cfif>
		<cfoutput query="rsPluginScripts" group="pluginID">
			<!---<cfset tabLabelList=tabLabelList & ",'#jsStringFormat(rsPluginScripts.name)#'"/>--->
			<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
			<cfset tabID="tab" & application.contentRenderer.createCSSID(rsPluginScripts.name)>
			<cfset tabList=listAppend(tabList,tabID)>
			<cfset pluginEvent.setValue("tabList",tabLabelList)>
				<div id="#tabID#">
				<cfoutput>
				<cfset rsPluginScript=application.pluginManager.getScripts("onContentEdit",rc.siteID,rsPluginScripts.moduleID)>
				<cfif rsPluginScript.recordcount>
				#application.pluginManager.renderScripts("onContentEdit",rc.siteid,pluginEvent,rsPluginScript)#
				<cfelse>
				<cfset rsPluginScript=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID,rsPluginScripts.moduleID)>
				#application.pluginManager.renderScripts("on#rc.type#Edit",rc.siteid,pluginEvent,rsPluginScript)#
				</cfif>
				</cfoutput>
				</div>
		</cfoutput>
	</cfsavecontent>
	<cfoutput>
	<img class="loadProgress tabPreloader" src="images/progress_bar.gif">
	<div class="tabs initActiveTab" style="display:none">
		<ul>
		<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
		</cfloop>
		</ul>
		#tabContent#
	</div>
	
	<cfif assignChangesets>
		<cfinclude template="form/dsp_changesets.cfm">
	</cfif>
	
	<div class="clearfix" id="actionButtons">
		<cfif assignChangesets>
		<input type="button" class="submit" onclick="saveToChangeset('#rc.contentBean.getChangesetID()#','#HTMLEditFormat(rc.siteID)#','');return false;" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset")#" />	
		</cfif>
		 <input type="button" class="submit" onclick="if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#" />
		<cfif listFindNoCase("Page,Portal,Calendar,Gallery",rc.type)>
		<input type="button" class="submit" onclick="document.contentForm.preview.value=1;if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraftandpreview"))#" />
		</cfif>
		<cfif rc.perm eq 'editor'>
		<input type="button" class="submit" onclick="document.contentForm.approved.value=1;if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#" />
		</cfif> 
	</div>
		<input name="approved" type="hidden" value="0">
		<input name="muraPreviouslyApproved" type="hidden" value="#rc.contentBean.getApproved()#">
		<input id="removePreviousChangeset" name="removePreviousChangeset" type="hidden" value="false">
		<input id="changesetID" name="changesetID" type="hidden" value="">
		<input name="preview" type="hidden" value="0">	
		<cfif rc.type neq 'Link'>
			<input name="filename" type="hidden" value="#rc.contentBean.getfilename()#">
		</cfif>
		<cfif not rc.contentBean.getIsNew()>
			<input name="lastupdate" type="hidden" value="#LSDateFormat(rc.contentBean.getlastupdate(),session.dateKeyFormat)#">
		</cfif>
		<cfif rc.contentid eq '00000000000000000000000000000000001'>
			<input name="isNav" type="hidden" value="1">
		</cfif>
		<cfif rc.type eq 'Form'>
			<input name="responseDisplayFields" type="hidden" value="#rc.contentBean.getResponseDisplayFields()#">
		</cfif>
		<input name="action" type="hidden" value="add">
		<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
		<input type="hidden" name="moduleid" value="#rc.moduleid#">
		<input type="hidden" name="preserveID" value="#rc.contentBean.getPreserveID()#">
		<input type="hidden" name="return" value="#rc.return#">
		<input type="hidden" name="topid" value="#rc.topid#">
		<input type="hidden" name="contentid" value="#rc.contentBean.getContentID()#">
		<input type="hidden" name="ptype" value="#rc.ptype#">
		<input type="hidden" name="type" value="#rc.type#">
		<input type="hidden" name="subtype" value="#rc.contentBean.getSubType()#">
		<input type="hidden" name="muraAction" value="cArch.update">
		<input type="hidden" name="startrow" value="#rc.startrow#">
		<input type="hidden" name="returnURL" id="txtReturnURL" value="#rc.returnURL#">
		<input type="hidden" name="homeID" value="#rc.homeID#">
		<cfif not  listFind(session.mura.memberships,'S2')>
			<input type="hidden" name="isLocked" value="#rc.contentBean.getIsLocked()#">
		</cfif>
		<input name="OrderNo" type="hidden" value="<cfif rc.contentBean.getorderno() eq ''>0<cfelse>#rc.contentBean.getOrderNo()#</cfif>">
				
	</cfoutput>
	</form>
<cfelse>
	<div>
		<cfinclude template="form/dsp_full.cfm">
	</div>
</cfif>