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
<cfswitch expression="#rc.moduleID#">

<cfcase value="00000000000000000000000000000000003,00000000000000000000000000000000004">

<cfset rc.perm=application.permUtility.getPerm(rc.moduleid,rc.siteid)>

<cfparam name="rc.sortBy" default="">
<cfparam name="rc.sortDirection" default="">
<cfparam name="rc.searchString" default="">

<cfset titleDirection = "asc">
<cfset displayDirection = "asc">
<cfset lastUpdatedDirection = "desc">

<cfswitch expression="#rc.sortBy#">
	<cfcase value="title">
		 <cfif rc.sortDirection eq "asc">
			<cfset titleDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="display">
		<cfif rc.sortDirection eq "asc">
			<cfset displayDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="lastupdate">
		<cfif rc.sortDirection eq "desc">
			<cfset lastUpdatedDirection = "asc">
		</cfif>
	</cfcase>
</cfswitch>

<cfoutput>
<cfif rc.moduleid eq '00000000000000000000000000000000004'>
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.formsmanager')#</h2>
<cfelse>
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.componentmanager')#</h2>	
</cfif>

<ul id="navTask">
	<cfif rc.moduleid eq '00000000000000000000000000000000003'>
	<li><a href="index.cfm?muraAction=cArch.edit&type=Component&contentid=&topid=#URLEncodedFormat(rc.topid)#&parentid=#rc.topid#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addcomponent')#</a></li>
	<cfelse>
		<li><a href="index.cfm?muraAction=cArch.edit&type=Form&contentid=&topid=#URLEncodedFormat(rc.topid)#&parentid=#rc.topid#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&formType=editor">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addformwitheditor')#</a></li>
	<li><a href="index.cfm?muraAction=cArch.edit&type=Form&contentid=&topid=#URLEncodedFormat(rc.topid)#&parentid=#rc.topid#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&formType=builder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addformwithbuilder')#</a></li>
	</cfif>
</ul>

  <h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'sitemanager.filterview')#:</h3>
  <form novalidate="novalidate" id="filterByTitle" action="index.cfm" method="get">
	  <h4>#application.rbFactory.getKeyValue(session.rb,'sitemanager.filterviewdesc')#</h4>
	  <input type="text" name="searchString" value="#HTMLEditFormat(rc.searchString)#" class="text">
	  <input type="button" class="submit" onclick="document.getElementById('filterByTitle').submit();" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.filter')#" />
	  <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#" />
	  <input type="hidden" name="topid" value="#rc.topID#" />
	  <input type="hidden" name="parentid" value="#rc.parentID#" />
	  <input type="hidden" name="moduleid" value="#rc.moduleID#" />
	  <input type="hidden" name="sortBy" value="" />
	  <input type="hidden" name="sortDirection" value="" />
	  <input type="hidden" name="muraAction" value="cArch.list" />
  </form>
  
  </cfoutput>
  <table class="mura-table-grid stripe">
    
	<cfoutput>
	<tr> 
      <th class="varWidth"><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=title&sortDirection=#titleDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.title')#</a></th>
    <!--- <cfif rc.perm eq 'editor'><th class="order" width="30">Order</th></cfif>--->
      <th><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=display&sortDirection=#displayDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.display')#</a></th>
      <th><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=lastUpdate&sortDirection=#lastUpdatedDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.lastupdated')#</a></th>
      <th class="administration">&nbsp;</th>
    </tr>
	</cfoutput>
    <cfif rc.rstop.recordcount>
     <cfoutput query="rc.rsTop" maxrows="#rc.nextn.recordsperPage#" startrow="#rc.startrow#">
	<cfsilent><cfif rc.perm neq 'editor'>
	<cfset verdict=application.permUtility.getPerm(rc.rstop.contentid, rc.siteid)>
	
	<cfif verdict neq 'deny'>
		<cfif verdict eq 'none'>
			<cfset verdict=rc.perm>
		</cfif>
	<cfelse>
		<cfset verdict = "none">
	</cfif>
	
	<cfelse>
<cfset verdict='editor'>
</cfif>
</cfsilent>
        <tr>  
          <td class="varWidth"><cfif verdict neq 'none'><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#left(rc.rstop.menutitle,90)#</a><cfelse>#left(rc.rstop.menutitle,90)#</cfif></td>
          <!--- <cfif verdict eq 'editor'><td nowrap class="order"><cfif rc.rstop.currentrow neq 1><a href="index.cfm?muraAction=cArch.order&contentid=#rc.rstop.contentid#&parentid=#rc.rstop.parentid#&direction=down&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#"><img src="images/icons/up_on.gif" width="9" height="6" border="0"></a><cfelse><img src="images/icons/up_off.gif" width="9" height="6" border="0"></cfif><cfif rc.rstop.currentrow lt rc.rstop.recordcount><a href="index.cfm?muraAction=cArch.order&contentid=#rc.rstop.contentid#&parentid=#rc.rstop.parentid#&direction=up&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&startrow=#rc.startrow#&moduleid=#rc.moduleid#"><img src="images/icons/down_on.gif" width="9" height="6" border="0"></a><cfelse><img src="images/icons/down_off.gif" width="9" height="6" border="0"></cfif></td>	--->  
			   <td> 
	    <cfif rc.rstop.Display and (rc.rstop.Display eq 1 and rc.rstop.approved and rc.rstop.approved)>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#<cfelseif(rc.rstop.Display eq 2 and rc.rstop.approved and rc.rstop.approved)>#LSDateFormat(rc.rstop.displaystart,"short")# - #LSDateFormat(rc.rstop.displaystop,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</cfif></td>
		<td>#LSDateFormat(rc.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rc.rstop.lastupdate,"medium")#</td>
          <td class="administration">
			<ul class="#lcase(rc.rstop.type)#">
				<cfif verdict neq 'none'>
				<li class="edit">
					<a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#"title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
					<li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a></li>
					<cfif rc.moduleid eq '00000000000000000000000000000000004'>
						<li class="manageData"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#" href="index.cfm?muraAction=cArch.datamanager&contentid=#rc.rstop.ContentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&contenthistid=#rc.rstop.ContentHistID#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&type=Form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
					</cfif>
					<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
						<li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#" href="index.cfm?muraAction=cPerm.main&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a>
					<cfelse>
						<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
					</cfif>
				<cfelse>
					<li class="editOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</li>
					<li class="versionHistoryOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</li>
					<cfif rc.moduleid eq '00000000000000000000000000000000004'>
						<li class="manageDataOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</li>
					</cfif>
					<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
				</cfif>
				<cfif ((rc.locking neq 'all') or (rc.parentid eq '#rc.topid#' and rc.locking eq 'none')) and (verdict eq 'editor') and not rc.rsTop.isLocked eq 1>
					<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?muraAction=cArch.update&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&action=deleteall&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&parentid=#URLEncodedFormat(rc.parentid)#" onClick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
				<cfelseif rc.locking neq 'all'>
					<li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</li>
				</cfif>
			</ul></td></tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="7" class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noitemsinsection')#</cfoutput></td>
      </tr>
    </cfif>
	
  <!---   <cfif rc.nextn.numberofpages gt 1><tr> 
      <td colspan="7" class="noResults">More Results: <cfloop from="1"  to="#rc.nextn.numberofpages#" index="i"><cfoutput><cfif rc.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#i#</a> </cfif></cfoutput></cfloop></td></tr></cfif> --->
  </table>
</td></tr></table>

  <cfif rc.nextn.numberofpages gt 1>
    <cfoutput> 
 	#application.rbFactory.getKeyValue(session.rb,'sitemanager.moreresults')#: 
		
		 <cfif rc.nextN.currentpagenumber gt 1> <a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#rc.nextN.previous#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.prev')#</a></cfif>
		<cfloop from="#rc.nextn.firstPage#"  to="#rc.nextn.lastPage#" index="i"><cfif rc.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#i#</a> </cfif></cfloop>
		 <cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#rc.nextN.next#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.next')#&nbsp;&raquo;</a></cfif>
		</cfoutput>
   </cfif>
<cfinclude template="draftpromptjs.cfm">


</cfcase>

<cfcase value="00000000000000000000000000000000000">

<cfsilent>

<cfset crumbdata=application.contentManager.getCrumbList(rc.topid,rc.siteid)>

<cfif isdefined('rc.nextN') and rc.nextN gt 0>
  <cfset session.mura.nextN=rc.nextN>
  <cfset rc.startrow=1>
</cfif>

<cfif not isDefined('rc.saveSort')>
  <cfset rc.sortBy=rc.rstop.sortBy />
  <cfset rc.sortDirection=rc.rstop.sortDirection />
</cfif>

<cfparam name="rc.sortBy" default="#rc.rstop.sortBy#" />
<cfparam name="rc.sortDirection" default="#rc.rstop.sortDirection#" />
<cfparam name="rc.sorted" default="false" />
<cfparam name="rc.lockid" default="" />
<cfparam name="rc.assignments" default="false" />
<cfparam name="rc.categoryid" default="" />
<cfparam name="rc.tag" default="" />
<cfparam name="rc.type" default="" />
<cfparam name="rc.page" default="1" />
<cfparam name="rc.subtype" default="" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">

<cfparam name="session.flatViewArgs" default="#structNew()#">
<cfparam name="session.flatViewArgs" default="#structNew()#">

<cfscript>
	if(not structKeyExists(session.flatViewArgs,session.siteid)){
		session.flatViewArgs["#session.siteid#"]=structNew();
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"moduleid")){
		session.flatViewArgs["#session.siteid#"].moduleid=rc.moduleid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortby")){
		session.flatViewArgs["#session.siteid#"].sortby="lastupdate";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortdirection")){
		session.flatViewArgs["#session.siteid#"].sortdirection="desc";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"lockid")){
		session.flatViewArgs["#session.siteid#"].lockid=rc.lockid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"assignments")){
		session.flatViewArgs["#session.siteid#"].assignments=rc.assignments;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"categoryid")){
		session.flatViewArgs["#session.siteid#"].categoryid=rc.categoryid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tag")){
		session.flatViewArgs["#session.siteid#"].tag=rc.tag;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"page")){
		session.flatViewArgs["#session.siteid#"].page=rc.page;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"type")){
		session.flatViewArgs["#session.siteid#"].type="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"subtype")){
		session.flatViewArgs["#session.siteid#"].subtype=rc.subtype;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"report")){
		session.flatViewArgs["#session.siteid#"].report="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"keywords")){
		session.flatViewArgs["#session.siteid#"].keywords="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tab")){
		session.flatViewArgs["#session.siteid#"].tab=0;
	}

	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"filtered") or not isBoolean((session.flatViewArgs["#session.siteid#"].filtered))){
		session.flatViewArgs["#session.siteid#"].filtered=false;
	}
</cfscript>

<cfif not isdefined("url.activeTab")>
	<cfset rc.activeTab=session.flatViewArgs["#session.siteID#"].tab/>
</cfif>
<cfif isdefined("url.keywords")>
	<cfif session.flatViewArgs["#session.siteID#"].keywords neq url.keywords>
		<cfset session.flatViewArgs["#session.siteID#"].page=1>
	</cfif>
	<cfset session.flatViewArgs["#session.siteID#"].keywords=url.keywords/>
	<cfset session.flatViewArgs["#session.siteID#"].report=""/>
	<cfset session.keywords=url.keywords/>
</cfif>
<cfhtmlhead text='<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-pulse.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>

<cfif isdefined('rc.orderperm') and (rc.orderperm eq 'editor' or (rc.orderperm eq 'author' and application.configBean.getSortPermission() eq "author"))>
	<cflock type="exclusive" name="editingContent#rc.siteid#" timeout="60">
		
		<cfif rc.sorted>
			<cfset current=application.serviceFactory.getBean("content").loadBy(contentID=rc.topID, siteid=rc.siteID)>
			<cfif rc.sortBy eq 'orderno'>
				<cfset rc.sortDirection='asc'>
			</cfif>
			<cfset current.setSortBy(rc.sortBy)>
			<cfset current.setSortDirection(rc.sortDirection)>
			<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
			<cfset variables.pluginEvent.setValue("contentBean")>
			<cfset application.pluginManager.announceEvent("onBeforeContentSort",pluginEvent)>
		</cfif>
		
		<cfif isdefined('rc.orderid') >
			<cfloop from="1" to="#listlen(rc.orderid)#" index="i">
				<cfset newOrderNo=(rc.startrow+i)-1>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #newOrderNo# where contentid ='#listgetat(rc.orderid,i)#'
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
		update tcontent set sortBy='#rc.sortBy#',sortDirection='#rc.sortDirection#' where contentid ='#rc.topid#'
		</cfquery>
		<cfif rc.sortBy eq 'orderno' and  not isdefined('rc.orderid')>
			<cfset rsSetOrder=application.contentManager.getNest('#rc.topid#',rc.siteid,rc.rsTop.sortBy,rc.rsTop.sortDirection)>
			<cfloop query="rsSetOrder">
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #rsSetOrder.currentrow# where contentid ='#rsSetOrder.contentID#'
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif rc.sorted>
			<cfset application.pluginManager.announceEvent("onAfterContentSort",pluginEvent)>
		</cfif>
		
		<cfset application.settingsManager.getSite(rc.siteid).purgeCache()>
	</cflock>
</cfif>
<cfif not len(crumbdata[1].siteid)>
  <cflocation url="index.cfm?muraAction=cDashboard.main&siteid=#URLEncodedFormat(rc.siteid)#&span=30" addtoken="false"/>
</cfif>
</cfsilent>

<cfoutput>
<script>	
siteID='#session.siteID#';
<cfif session.copySiteID eq rc.siteID>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
copyAll = '#session.copyAll#';
<cfelse>
copyContentID = '';
copySiteID = '';
copyAll = 'false';
</cfif>
</script>
 
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h2>
<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
    <!---<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.contentsearch")#</h3>--->
    <input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" align="absmiddle" />
    <input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.search")#" />
    <input type="hidden" name="muraAction" value="cArch.list">
	<input type="hidden" name="activetab" value="1">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
    <input type="hidden" name="moduleid" value="#rc.moduleid#">
</form>


<!---<img class="loadProgress tabPreloader" src="images/progress_bar.gif">--->

<div id="viewTabs" class="tabs initActiveTab" style="display:none">
		<ul>
			<li><a href="##tabArchitectual" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.architectural")#</span></a></li>
			<li><a href="##tabFlat" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.flat")#</span></a></li>
		</ul>
		<div id="tabArchitectual">
		<div id="gridContainer"><img class="loadProgress" src="images/progress_bar.gif"></div>
		</div>
		
		<div id="tabFlat">
			<img class="loadProgress" src="images/progress_bar.gif">
		</div>
		
</div>
<script type="text/javascript">
var archViewLoaded=false;
var flatViewLoaded=false;

function initFlatViewArgs(){
	return {siteid:'#JSStringFormat(session.siteID)#', 
			moduleid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].moduleid)#', 
			sortby:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortby)#', 
			sortdirection:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortdirection)#', 
			page:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].page)#',	
			tag:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].tag)#',
			categoryid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].categoryid)#',
			lockid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].lockid)#',
			type:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].type)#',
			subType:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].subtype)#',
			report:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].report)#',
			keywords:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].keywords)#',
			filtered: '#JSStringFormat(session.flatViewArgs["#session.siteID#"].filtered)#'
			};
}

var flatViewArgs=initFlatViewArgs();

function initSiteManagerTabContent(index){

	jQuery.get("./index.cfm","muraAction=carch.siteManagerTab&tab=" + index);
	
	switch(index){
		case 0:
		if (!archViewLoaded) {
			loadSiteManager('#JSStringFormat(rc.siteID)#', '#JSStringFormat(rc.topid)#', '#JSStringFormat(rc.moduleid)#', '#JSStringFormat(rc.sortby)#', '#JSStringFormat(rc.sortdirection)#', '#JSStringFormat(rc.ptype)#', '#JSStringFormat(rc.startrow)#');
			archViewLoaded = true;
		}
		break;
		case 1:
		if (!flatViewLoaded) {
			loadSiteFlat(flatViewArgs);
			flatViewLoaded = true;
		}
	}
}

jQuery("##viewTabs").bind( "tabsselect", function(event,ui){
	initSiteManagerTabContent(ui.index)
});	

initSiteManagerTabContent(#rc.activeTab#);			
</script>
</cfoutput>
<cfinclude template="draftpromptjs.cfm">

</cfcase>
</cfswitch>

