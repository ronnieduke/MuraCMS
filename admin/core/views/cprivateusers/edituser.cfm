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
<cfsilent>
<cfset event=request.event>
<cfhtmlhead text="#session.dateKey#">
<cfparam name="rc.activeTab" default="0" />
<cfset userPoolID=application.settingsManager.getSite(rc.siteID).getPrivateUserPoolID()>
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(type=2,siteID=userPoolID,activeOnly=true) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset rsPluginScripts=application.pluginManager.getScripts("onUserEdit",rc.siteID)>
<cfset tabLabelList='#application.rbFactory.getKeyValue(session.rb,'user.basic')#,#application.rbFactory.getKeyValue(session.rb,'user.addressinformation')#,#application.rbFactory.getKeyValue(session.rb,'user.groupmemberships')#,#application.rbFactory.getKeyValue(session.rb,'user.interests')#'>
<cfset tablist="tabBasic,tabAddressinformation,tabGroupmemberships,tabInterests">
<cfif rsSubTypes.recordcount>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))>
<cfset tabList=listAppend(tabList,"tabExtendedattributes")>
</cfif>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,'user.advanced'))>
<cfset tabList=listAppend(tabList,"tabAdvanced")></cfsilent>
<cfoutput><form novalidate="novalidate" action="index.cfm?muraAction=cPrivateUsers.update&userid=#URLEncodedFormat(rc.userid)#&routeid=#rc.routeid#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h2>#application.rbFactory.getKeyValue(session.rb,'user.adminuserform')#</h2>
	
	<cfif len(rc.userBean.getUsername())>
		<cfset strikes=createObject("component","mura.user.userstrikes").init(rc.userBean.getUsername(),application.configBean)>
		<cfif structKeyExists(rc,"removeBlock")>
			<cfset strikes.clear()>
		</cfif>
		<cfif strikes.isBlocked()>
			<p class="error">
			#application.rbFactory.getKeyValue(session.rb,'user.blocked')#: #LSTimeFormat(strikes.blockedUntil(),"short")#
			<a href="?muraAction=cPrivateUsers.edituser&userid=#URLEncodedFormat(rc.userid)#&type=2&siteid=#URLEncodedFormat(rc.siteid)#&removeBlock">[#application.rbFactory.getKeyValue(session.rb,'user.remove')#]</a>
			</p>
		</cfif>
	</cfif>
	
	<cfif not structIsEmpty(rc.userBean.getErrors())>
		<p class="error">#application.utility.displayErrors(rc.userBean.getErrors())#</p>
	</cfif>
	
	<p>#application.rbFactory.getKeyValue(session.rb,'user.requiredtext')#</p>
</cfoutput>	
<cfsavecontent variable="tabContent">
<cfoutput>	
<div id="tabBasic">
	<dl class="oneColumn">
		<cfif rsNonDefault.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.type')#</dt>
		<dd><select name="subtype" class="dropdown" onchange="resetExtendedAttributes('#rc.userBean.getUserID()#','2',this.value,'#userPoolID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');">
			<option value="Default" <cfif  rc.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif rc.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		</dd>
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		<dt <cfif not  rsNonDefault.recordcount>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.fname')#*</dt> 
		<dd><input id="fname" name="fname" type="text" value="#HTMLEditFormat(rc.userBean.getfname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.fnamerequired')#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.lname')#*</dt>
		<dd><input id="lname" name="lname" type="text" value="#HTMLEditFormat(rc.userBean.getlname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.lnamerequired')#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.company')#</dt>
		<dd><input id="organization" name="company" type="text" value="#HTMLEditFormat(rc.userBean.getcompany())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.jobtitle')#</dt>
		<dd><input id="jobtitle" name="jobtitle" type="text" value="#HTMLEditFormat(rc.userBean.getjobtitle())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.mobilephone')#</dt>
		<dd><input id="mobilePhone" name="mobilePhone" type="text" value="#HTMLEditFormat(rc.userBean.getMobilePhone())#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#*</dt>
		<dd><input id="email" name="email" type="text" value="#HTMLEditFormat(rc.userBean.getemail())#" class="text" required="true" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.username')#*</dt>
		<dd><input id="username"  name="usernameNoCache" type="text" value="#HTMLEditFormat(rc.userBean.getusername())#" class="text" required="true" message="The 'Username' field is required" autocomplete="off"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpassword')#**</dt>
<dd><input name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="text"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordmatchvalidate')#"></dd> 
<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpasswordconfirm')#**</dt>
<dd><input  name="password2" autocomplete="off" type="password" value="" class="text"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordconfirm')#"></dd>    
<span id="extendSetsBasic"></span>		
</dl>		
</div>
<div id="tabAddressinformation">
		<cfsilent>
		<cfparam name="rc.address1" default=""/>
		<cfparam name="rc.address2" default=""/>
		<cfparam name="rc.city" default=""/>
		<cfparam name="rc.state" default=""/>
		<cfparam name="rc.zip" default=""/>
		<cfparam name="rc.country" default=""/>
		<cfparam name="rc.phone" default=""/>
		<cfparam name="rc.fax" default=""/>
		<cfparam name="rc.addressURL" default=""/>
		<cfparam name="rc.addressEmail" default=""/>
		<cfparam name="rc.hours" default=""/>
		</cfsilent>
		<dl class="oneColumn">
		<cfif rc.userid eq ''>
		<dt class="first"></dt>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address1')#</dt>
		<dd><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rc.address1)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address2')#</dt>
		<dd><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rc.address2)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.city')#</dt>
		<dd><input id="city" name="city" type="text" value="#HTMLEditFormat(rc.city)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.state')#</dt>
		<dd><input id="state" name="state" type="text" value="#HTMLEditFormat(rc.state)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.zip')#</dt>
		<dd><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rc.zip)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.country')#</dt>
		<dd><input id="country" name="country" type="text" value="#HTMLEditFormat(rc.country)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.phone')#</dt>
		<dd><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rc.phone)#" class="text"></dd>	
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.fax')#</dt>
		<dd><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rc.fax)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</dt>
		<dd><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rc.addressURL)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
		<dd><input id="addressEmail" name="addressEmail" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" type="text" value="#HTMLEditFormat(rc.addressEmail)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.hours')#</dt>
		<dd><textarea id="hours" name="hours" >#HTMLEditFormat(rc.hours)#</textarea></dd>   
		<input type="hidden" name="isPrimary" value="1" />
		<cfelse>
		<dt class="first"><ul id="navTask"><li><a href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID=&returnURL=#urlencodedformat(cgi.query_string)#">#application.rbFactory.getKeyValue(session.rb,'user.addnewaddress')#</a></li></ul></dt>
		<cfset rsAddresses=rc.userBean.getAddresses()>
		<dd>
		<cfif rsAddresses.recordcount>
		<table id="metadata">
		<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.primary')#</th><th>#application.rbFactory.getKeyValue(session.rb,'user.address')#</th><th class="adminstration"></th></tr>
		<cfloop query="rsAddresses">
		<tr>
			<td>
			<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
			</td>
			<td>
			<cfif rsAddresses.addressName neq ''><a title="Edit" href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#urlencodedformat(cgi.query_string)#"><strong>#rsAddresses.addressName#</strong></a><br/></cfif>
			<cfif rsAddresses.address1 neq ''>#rsAddresses.address1#<br/></cfif>
			<cfif rsAddresses.address2 neq ''>#rsAddresses.address2#<br/></cfif>
			<cfif rsAddresses.city neq ''>#rsAddresses.city# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #rsAddresses.state# </cfif><cfif rsaddresses.zip neq ''> #rsAddresses.zip#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
			<cfif rsAddresses.phone neq ''>#application.rbFactory.getKeyValue(session.rb,'user.phone')#: #rsAddresses.phone#<br/></cfif>
			<cfif rsAddresses.fax neq ''>#application.rbFactory.getKeyValue(session.rb,'user.fax')#: #rsAddresses.fax#<br/></cfif>
			<cfif rsAddresses.addressURL neq ''>#application.rbFactory.getKeyValue(session.rb,'user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#rsAddresses.addressURL#</a><br/></cfif>
			<cfif rsAddresses.addressEmail neq ''>#application.rbFactory.getKeyValue(session.rb,'user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#rsAddresses.addressEmail#</a></cfif>
			</td>
			<td nowrap class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cPrivateUsers.editAddress&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#urlencodedformat(cgi.query_string)#">[#application.rbFactory.getKeyValue(session.rb,'user.edit')#]</a></li>
			<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?muraAction=cPrivateUsers.updateAddress&userid=#URLEncodedFormat(rc.userid)#&action=delete&siteid=#URLEncodedFormat(rc.siteid)#&routeID=#rc.routeid#&addressID=#rsAddresses.addressID#&returnURL=#urlencodedformat(cgi.query_string)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#',this);">[#application.rbFactory.getKeyValue(session.rb,'user.delete')#]</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul></td>
		</tr>
		</cfloop>
		</table>
		<cfelse>
		<em>#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</em>
		</cfif>
		</dd>
		</cfif>
		</dl>
</div>
<div id="tabGroupmemberships">
		<dl class="oneColumn">
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.admingroups')#</dt>
		<dd><ul>
			<cfloop query="rc.rsPrivateGroups">
				<li><input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPrivateGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPrivateGroups.UserID) or listfind(rc.groupid,rc.rsPrivateGroups.UserID)>checked</cfif>>#rc.rsPrivateGroups.groupname#</li>
			</cfloop></ul>
		</dd>
		<cfif rc.rsPublicGroups.recordcount>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</dt>
		<dd><ul>
			<cfloop query="rc.rsPublicGroups">
				<li><input name="groupid" type="checkbox" class="checkbox" value="#rc.rsPublicGroups.UserID#" <cfif listfind(rc.userBean.getgroupid(),rc.rsPublicGroups.UserID) or listfind(rc.groupid,rc.rsPublicGroups.UserID)>checked</cfif>>#rc.rsPublicGroups.site# - #rc.rsPublicGroups.groupname#</li>
			</cfloop></ul>
		</dd>
		</cfif>
		</dd>
		</dl>
</div>	
<div id="tabInterests">
		<dl class="oneColumn">
		<dd class="first">
			<cfif application.categoryManager.getCategoryCount(rc.siteid)>
			<!---<ul class="interestGroups">--->
				<cfloop collection="#application.settingsManager.getSites()#" item="site">
					<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq rc.siteid>
						<!---<li>--->
							<cfoutput><h4>#application.settingsManager.getSite(site).getSite()#</h4>
							<div class="divide"></div>
							</cfoutput>
							<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" categoryID="#rc.categoryID#" nestLevel="0"  userBean="#rc.userBean#">
						<!---</li>--->
					</cfif>
				</cfloop>
			<!---</ul>--->
			<cfelse>
			<p class="notice">#application.rbFactory.getKeyValue(session.rb,'user.nointerestcategories')#</p>
			</cfif> 
		</dd>
		
	</dl>
</div>
	
<cfif rsSubTypes.recordcount>
<div id="tabExtendedattributes">
		<span id="extendSetsDefault"></span>
		<script type="text/javascript">
		loadExtendedAttributes('#rc.userbean.getUserID()#','#rc.userbean.getType()#','#rc.userBean.getSubType()#','#userPoolID#','#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#');
		</script>	
</div>
<cfhtmlhead text='<script type="text/javascript" src="js/user.js"></script>'>
</cfif>

<div id="tabAdvanced">
		<dl class="oneColumn">
				<cfif listFind(session.mura.memberships,'S2')>
			<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.superadminaccount')#</dt>
			<dd><ul class="radioGroup"><li><input name="s2" type="radio" class="radio" value="1" <cfif rc.userBean.gets2() eq 1>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="s2" type="radio" class="radio" value="0" <cfif rc.userBean.gets2() eq 0>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li></ul></dd>
		</cfif>
		
		<dt <cfif not listFind(session.mura.memberships,'S2')>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.emailbroadcaster')#</dt>
		<dd><ul class="radioGroup"><li><input name="subscribe" type="radio" class="radio" value="1"<cfif rc.userBean.getsubscribe() eq 1>Checked</cfif>>Yes</li><li><input name="subscribe" type="radio" class="radio" value="0"<cfif rc.userBean.getsubscribe() eq 0>Checked</cfif>>No</li></ul></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.inactive')#</dt>
		<dd><ul class="radioGroup"><li><input name="InActive" type="radio" class="radio" value="0"<cfif rc.userBean.getInActive() eq 0 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="InActive" type="radio" class="radio" value="1"<cfif rc.userBean.getInActive() eq 1 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li></ul></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.tags')#</dt>
		<dd><input id="tags" name="tags" type="text" value="#HTMLEditFormat(rc.userBean.getTags())#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.usertype')#</dt>
		<dd><ul class="radioGroup"><li><input name="switchToPublic" type="radio" class="radio" value="1"> #application.rbFactory.getKeyValue(session.rb,'user.sitemember')#</li><li><input name="switchToPublic" type="radio" class="radio" value="0" Checked> #application.rbFactory.getKeyValue(session.rb,'user.administrative')#</li></ul></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.contactform')#</dt>
		<dd><ul>
			<cfloop collection="#application.settingsManager.getSites()#" item="site">
				<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()>
					<li><input type="checkbox" class="checkbox" name="ContactForm" value="#site#" <cfif listfind(rc.userBean.getcontactform(),site)>Checked</cfif>>#application.settingsManager.getSite(site).getSite()#</li>
				</cfif>
			</cfloop></ul>
		</dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.remoteid')#</dt>
		<dd><input id="remoteID" name="remoteID" type="text" value="#HTMLEditFormat(rc.userBean.getRemoteID())#"  class="text"></dd>
		</dl>
</div>
	</cfoutput>
		<cfoutput query="rsPluginScripts" group="pluginID">
		<!---<cfset tabLabelList=tabLabelList & ",'#jsStringFormat(rsPluginScripts.name)#'"/>--->
		<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
		<cfset tabID="tab" & application.contentRenderer.createCSSID(rsPluginScripts.name)>
		<cfset tabList=listAppend(tabList,tabID)>
		<cfset pluginEvent.setValue("tabList",tabLabelList)>
			<div id="#tabID#">
			<cfoutput>
			<cfset rsPluginScript=application.pluginManager.getScripts("onUserEdit",rc.siteID,rsPluginScripts.moduleID)>
			<cfif rsPluginScript.recordcount>
			#application.pluginManager.renderScripts("onUserEdit",rc.siteid,pluginEvent,rsPluginScript)#
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

	<div id="actionButtons">
	<cfif rc.userid eq ''>
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
    <cfelse>
        <input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteuserconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" /> 
		<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
	</cfif>
	</div>
		<input type="hidden" name="type" value="2">
		<input type="hidden" name="action" value="">
		<input type="hidden" name="contact" value="0">
		<input type="hidden" name="groupid" value="">
		<input type="hidden" name="ContactForm" value="">
		<input type="hidden" name="isPublic" value="0">
<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>

<script type="text/javascript">
initTabs(Array(#tablist#),#rc.activeTab#,0,0);
</script>
--->		
</cfoutput>

</form>