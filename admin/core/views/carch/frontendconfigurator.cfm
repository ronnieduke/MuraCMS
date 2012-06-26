﻿<cfset event=request.event>
<cfinclude template="js.cfm">
<cfsilent>
	<cfset rsDisplayObject=application.contentManager.readContentObject(rc.contentHistID,rc.regionID,rc.orderno)>
	<cfset rc.siteid=rsDisplayObject.siteid>
	<cfif rsDisplayObject.object eq "plugin">
	<cfset displayObjectBean=application.serviceFactory.getBean('pluginDisplayObjectBean').setObjectID(rsDisplayObject.objectid).load()>
		<cfset displayObjectBean.load()>
		<cfset hasConfigurator=len(displayObjectBean.getConfiguratorJS())>
	</cfif>
	<cfset rc.contentBean=application.contentManager.getContentVersion(contentHistID=rsDisplayObject.contenthistid,siteID=rsDisplayObject.siteid)>
	<cfset rc.perm=application.permUtility.getNodePerm(application.contentGateway.getCrumblist(rc.contentBean.getContentID(),rc.contentBean.getSiteID()))>
	<cfset rc.homeBean=application.contentManager.getActiveContent(contentID=rc.homeID,siteID=rsDisplayObject.siteid)>
	<cfset hasChangesets=application.settingsManager.getSite(rsDisplayObject.siteID).getHasChangesets()>
	<cfif hasChangesets>
		<cfset currentChangeset=application.changesetManager.read(rc.contentBean.getChangesetID())>
		<cfset pendingChangesets=application.changesetManager.getPendingByContentID(rc.contentBean.getContentID(),rc.siteID)>
	</cfif>
	<cfset assignChangesets=rc.perm eq 'editor' and hasChangesets>
	<cfset $=event.getValue("MuraScope")>
</cfsilent>
<cfoutput>
<div id="configuratorContainer" style="width: 400px;">
	<h2 id="configuratorHeader">Loading...</h2>
	<div id="configuratorNotices" style="display:none;">
	<cfif not rc.contentBean.getIsNew()>
	<cfset draftcheck=application.contentManager.getDraftPromptData(rc.contentBean.getContentID(),rc.contentBean.getSiteID())>
	
	<cfif yesNoFormat(draftcheck.showdialog) and draftcheck.historyid neq rc.contentBean.getContentHistID()>
	<p class="notice">
	#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.contentBean.getModuleID())#&siteID=#URLEncodedFormat(rc.contentBean.getSiteID())#&topID=#URLEncodedFormat(rc.contentBean.getContentID())#&contentID=#URLEncodedFormat(rc.contentBean.getContentID())#&return=#URLEncodedFormat(rc.return)#&contentHistID=#draftcheck.historyID#&parentID=#URLEncodedFormat(rc.contentBean.getParentID())#&startrow=#URLEncodedFormat(rc.startrow)#&compactDisplay=true&homeID=#HTMLEditFormat(rc.homeBean.getContentID())#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
	<p>
	</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
	<p class="notice">
	<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
	<cfloop query="pendingChangesets"><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.contentBean.getModuleID())#&siteID=#URLEncodedFormat(rc.contentBean.getSiteID())#&topID=#URLEncodedFormat(rc.contentBean.getContentID())#&contentID=#URLEncodedFormat(rc.contentBean.getContentID())#&return=#URLEncodedFormat(rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#URLEncodedFormat(rc.contentBean.getParentID())#&startrow=#URLEncodedFormat(rc.startrow)#&compactDisplay=true&homeID=#HTMLEditFormat(rc.homeBean.getContentID())#">"#HTMLEditFormat(pendingChangesets.changesetName)#"</a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
	<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: "#HTMLEditFormat(currentChangeset.getName())#"</cfif>
	</p>
	</cfif>
	</div>
	<div id="configurator">
		<img src="images/progress_bar.gif">
	</div>	
	<div id="actionButtons" style="display:none;">
		<cfif assignChangesets>
			<cfinclude template="form/dsp_changesets.cfm">
		</cfif>
		<cfif assignChangesets>
			<input type="button" class="button" onclick="saveToChangeset('#rc.contentBean.getChangesetID()#','#HTMLEditFormat(rsDisplayObject.siteid)#','');return false;" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset")#" />	
		</cfif>
		<input type="button" id="saveConfigDraft" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#"/>
		<input type="button" id="previewConfigDraft" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.preview"))#"/>
		<cfif rc.perm eq "Editor"><input type="button" id="publishConfig" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#"/></cfif>
	</div>
</div>
<script>
var configuratorMode='frontEnd';

jQuery(document).ready(function(){
	if(jQuery("##ProxyIFrame").length){
		jQuery("##ProxyIFrame").load(
			function(){
				frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");
			}
		);	
	} else {
		frontEndProxy.postMessage("cmd=setWindowMode&mode=configurator");
	}
	
	<cfswitch expression="#rsDisplayObject.object#">
		<cfcase value="feed,feed_no_summary,remoteFeed">	
			initFeedConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="feed_slideshow,feed_slideshow_no_summary">	
			initSlideShowConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'
					});
		</cfcase>
		<cfcase value="category_summary,category_summary_rss">	
			initCategorySummaryConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="related_content,related_section_content">	
			initRelatedContentConfigurator({
						'object':'#JSStringFormat(rsDisplayObject.object)#',
						'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
						'name':'#JSStringFormat(rsDisplayObject.name)#',
						'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
						'context':'#application.configBean.getContext()#',
						'params':'#JSStringFormat(rsDisplayObject.params)#',
						'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
						'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
						'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
						'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'		
					});
		</cfcase>
		<cfcase value="plugin">	
			var configurator=getPluginConfigurator('#JSStringFormat(rsDisplayObject.objectid)#');
			window[configurator](
				{
					'object':'#JSStringFormat(rsDisplayObject.object)#',
					'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
					'name':'#JSStringFormat(rsDisplayObject.name)#',
					'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
					'context':'#application.configBean.getContext()#',
					'params':'#JSStringFormat(rsDisplayObject.params)#',
					'siteid':'#JSStringFormat(rc.contentBean.getSiteID())#',
					'contenthistid':'#JSStringFormat(rc.contentBean.getContentHistID())#',
					'contentid':'#JSStringFormat(rc.contentBean.getContentID())#',
					'parentid':'#JSStringFormat(rc.contentBean.getParentID())#'
				}
			);
			jQuery("##configuratorHeader").html('#JSStringFormat(rsDisplayObject.name)#');
		</cfcase>
	</cfswitch>
		
	jQuery("##publishConfig").bind("click",
		function(){
			
			if (draftremovalnotice != "" &&
			!confirm(draftremovalnotice)) {
				return false;
			}
			
			updateAvailableObject();
			
			if (availableObjectValidate(availableObject.params)) {
				jQuery("##configurator").html('<img src="images/progress_bar.gif">');
				jQuery("##actionButtons").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(availableObject.params),
					'approved': 1,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(rc.homeBean.getURL())#");
				});
			}
		});
	
	jQuery("##saveConfigDraft").bind("click",
		function(){
			
			updateAvailableObject();
			
			if (availableObjectValidate(availableObject.params)) {
				jQuery("##configurator").html('<img src="images/progress_bar.gif">');
				jQuery("##actionButtons").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(availableObject.params),
					'approved': 0,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': '',
					'removepreviouschangeset': false,
					'preview': 0
				}, function(){
					frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(rc.homeBean.getURL())#");
				});
			}
		});
		
		jQuery("##previewConfigDraft").bind("click",
		function(){
			
			updateAvailableObject();
				
			if (availableObjectValidate(availableObject.params)) {
				jQuery("##configurator").html('<img src="images/progress_bar.gif">');
				jQuery("##actionButtons").hide();
				jQuery("##configuratorNotices").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams",
				{
					'contenthistid':'#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid':'#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid':'#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno':'#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid':'#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(availableObject.params),
					'approved':0,
					'object':'#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid':'',
					'removepreviouschangeset':false,
					'preview':1	
				},
	
				function(raw){
					var resp=eval( "(" + raw + ")" );
					<cfset str=rc.homeBean.getURL()>
					var loc="#JSStringFormat(str)#";
					<cfif find("?",str)>
					loc=loc + "&";
					<cfelse>
					loc=loc + "?";
					</cfif>
					//loc=loc + "contentID=" + resp.contentid;
					loc=loc + "previewID=" + resp.contenthistid;
					frontEndProxy.postMessage("cmd=setLocation&location=" + encodeURIComponent(loc) );
				}
			
				);
			}
		});
	
});

function saveConfiguratorToChangeset(changesetid,removepreviouschangeset){

	confirmDialog(publishitemfromchangeset, 
		function() {
			updateAvailableObject();
			
			if (availableObjectValidate(availableObject.params)) {
				jQuery("##configurator").html('<img src="images/progress_bar.gif">');
				jQuery("##actionButtons").hide();
				
				jQuery.post("./index.cfm?muraAction=cArch.updateObjectParams", {
					'contenthistid': '#JSStringFormat(rsDisplayObject.contentHistID)#',
					'objectid': '#JSStringFormat(rsDisplayObject.objectid)#',
					'regionid': '#JSStringFormat(rsDisplayObject.columnid)#',
					'orderno': '#JSStringFormat(rsDisplayObject.orderno)#',
					'siteid': '#JSStringFormat(rsDisplayObject.siteid)#',
					'params': JSON.stringify(availableObject.params),
					'approved': 0,
					'object': '#JSStringFormat(rsDisplayObject.object)#',
					'name': '#JSStringFormat(rsDisplayObject.name)#',
					'changesetid': changesetid,
					'removepreviouschangeset': removepreviouschangeset,
					'preview': 0
				}, function(){
					frontEndProxy.postMessage("cmd=setLocation&location=#jsStringFormat(rc.homeBean.getURL())#");
				});
				
			}
			 						
	});	
	
}

var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts()><cfoutput>'#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfinclude template="dsp_configuratorJS.cfm">
</cfoutput>