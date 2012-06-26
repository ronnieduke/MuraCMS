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
<cfhtmlhead text="#session.dateKey#">
<cfoutput>
<h2>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"advertising.editcampaign"),rc.userBean.getCompany())#</h2>
<ul id="navTask">
<li><a href="index.cfm?muraAction=cAdvertising.viewAdvertiser&&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.backtoadvertiser')#</a></li>
<cfif rc.campaignid neq ""><li><a href="index.cfm?muraAction=cAdvertising.viewReportByCampaign&campaignid=#URLEncodedFormat(rc.campaignid)#&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewcampaignreport')#</a></li></cfif>
</ul>

<h3>#application.rbFactory.getKeyValue(session.rb,'advertising.campaigninformation')#</h3>
#application.utility.displayErrors(rc.campaignBean.getErrors())#
<form novalidate="novalidate" action="index.cfm?muraAction=cAdvertising.updateCampaign&siteid=#URLEncodedFormat(rc.siteid)#" name="form1"  method="post" onsubmit="return validate(this);">
<dl class="oneColumn separate">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</dt>
<dd><input name="name" class="text" required="true" message="The 'Name' field is required." value="#HTMLEditFormat(rc.campaignBean.getName())#" maxlength="50"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</dt>
<dd><input name="startDate" class="text datepicker" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.startdatevalidate')#" value="#LSDateFormat(rc.campaignBean.getStartDate(),session.dateKeyFormat)#">
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</dt>
<dd><input name="endDate" class="text datepicker" validate="date" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.enddatevalidate')#" value="#LSDateFormat(rc.campaignBean.getEndDate(),session.dateKeyFormat)#">
<!---<input class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" onclick="window.open('date_picker/index.cfm?form=form1&field=endDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;" >---></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif rc.campaignBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label> 
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not rc.campaignBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#HTMLEditFormat(rc.campaignBean.getNotes())#</textarea></dd>
</dl>
<div id="actionButtons">
<cfif rc.campaignid eq ''>
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.add')#" />
	<input type=hidden name="campaignID" value="">
<cfelse>
	<input type="button" class="submit" onclick=submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deletecampaignconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" />
	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.update')#" />
	<input type=hidden name="campaignID" value="#rc.campaignBean.getCampaignID()#">
	</cfif>
</div>
<input type="hidden" name="action" value="">
<input type="hidden" name="userID" value="#HTMLEditFormat(rc.userid)#">
</form>
</cfoutput>
<cfif rc.campaignid neq ''>

	<cfoutput>
	<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'advertising.campaignplacements')#</h3>
	<ul id="navTask">
	<li><a href="index.cfm?muraAction=cAdvertising.editPlacement&campaignid=#URLEncodedFormat(rc.campaignid)#&placementid=&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.addplacement')#</a></li>
	</ul>
	
	<table class="mura-table-grid stripe">
	<tr>
		<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.adzone')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.creativeasset')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.startdate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.enddate')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.exclusive')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.active')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.budget')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalimpressions')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpm')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpmtotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.totalclicks')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpc')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.cpctotal')#</th>
		<th>#application.rbFactory.getKeyValue(session.rb,'advertising.total')#</th>
		<th class="administration">&nbsp;</th>
	</tr></cfoutput>
	<cfif rc.rsPlacements.recordcount>
		<cfsilent>
			<cfset cTotalImps=0 />
			<cfset cTotalClicks=0 />
			<cfset cTotalImpsCost=0 />
			<cfset cTotalClicksCost=0 />
			<cfset cTotalBudget=0 />
		</cfsilent>
		<cfoutput query="rc.rsPlacements">
		 <cfsilent>
			  <cfquery name="rsClicks" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#rc.rsPlacements.placementID#'
			   and type='Click'
	  		 </cfquery>
	  		 <cfquery name="rsImps" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			   select sum(counter) as total from tadstats where 
			   placementid='#rc.rsPlacements.placementID#'
			   and type='Impression'
	  		 </cfquery>
	  		 <cfset clicks=iif(rsClicks.total neq '',de('#rsClicks.total#'),de(0))>
	  		 <cfset imps=iif(rsImps.total neq '',de('#rsImps.total#'),de(0))>
			
		 	<cfset cTotalImps=cTotalImps+imps />
		 	<cfset cTotalClicks=cTotalClicks+clicks />
		 	<cfset cTotalImpsCost=cTotalImpsCost+(imps*rc.rsPlacements.costPerImp) />
		 	<cfset cTotalClicksCost=cTotalClicksCost+(clicks*rc.rsPlacements.costPerClick) />
	 		<cfset cTotalBudget=cTotalBudget+rc.rsPlacements.budget />
	 	</cfsilent>
			<tr>
				<td class="varWidth"><a href="index.cfm?muraAction=cAdvertising.editAdZone&siteid=#URLEncodedFormat(rc.siteid)#&adzoneid=#rc.rsplacements.adzoneid#">#rc.rsPlacements.Adzone#</a></td>
				<td><a href="index.cfm?muraAction=cAdvertising.editCreative&userid=#URLEncodedFormat(rc.userid)#&creativeid=#rc.rsplacements.creativeid#&siteid=#URLEncodedFormat(rc.siteid)#">#rc.rsPlacements.creative#</a></td>
				<td>#LSDateFormat(rc.rsPlacements.startdate,session.dateKeyFormat)#</td>
				<td>#LSDateFormat(rc.rsPlacements.enddate,session.dateKeyFormat)#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(rc.rsPlacements.isExclusive)#')#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'advertising.#yesnoFormat(rc.rsPlacements.isActive)#')#</td>
				<td>#LSCurrencyFormat(rc.rsPlacements.budget)#</td>
				<td>#Imps#</td>
				<td>#LSCurrencyFormat(rc.rsPlacements.costPerImp*1000)#</td>
				<td>#LSCurrencyFormat(rc.rsPlacements.costPerImp*Imps)#</td>
				<td>#Clicks#</td>
				<td>#LSCurrencyFormat(rc.rsPlacements.costPerClick)#</td>
				<td>#LSCurrencyFormat(rc.rsPlacements.costPerClick*Clicks)#</td>
				<td>#LSCurrencyFormat((rc.rsPlacements.costPerClick*Clicks)+(rc.rsPlacements.costPerImp*Imps))#</td>
				<td class="administration"><ul class="three">
				<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cAdvertising.editPlacement&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&campaignid=#rc.campaignID#&placementid=#rc.rsplacements.placementid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li>
				<li class="viewReport"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.viewplacementreport')#" href="index.cfm?muraAction=cAdvertising.viewReportByPlacement&placementid=#rc.rsPlacements.placementid#&campaignid=#rc.campaignid#&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.viewplacementreport')#</a></li>
				<li class="delete"><a title="#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.delete'))#" href="index.cfm?muraAction=cAdvertising.updatePlacement&action=delete&campaignid=#rc.campaignid#&siteid=#URLEncodedFormat(rc.siteid)#&userid=#URLEncodedFormat(rc.userid)#&placementid=#rc.rsplacements.placementid#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteplacementconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li></ul>
				</td></tr>
		</cfoutput>
		<cfoutput>
		<tr>
				<td nowrap class="varWidth" align="right" colspan="6">#application.rbFactory.getKeyValue(session.rb,'advertising.totals')#:</td>
				<td>#LSCurrencyFormat(cTotalBudget)#</td>
				<td>#cTotalImps#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalImpsCost)#</td>
				<td>#cTotalClicks#</td>
				<td>&nbsp;</td>
				<td>#LSCurrencyFormat(cTotalClicksCost)#</td>
				<td>#LSCurrencyFormat(cTotalImpsCost+cTotalClicksCost)#</td>
				<td></td>
				</tr>
		</table>
		</cfoutput>
	<cfelse>
		<tr>
			<td nowrap class="varWidth" colspan="15"><em><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.nocampaignplacements')#</cfoutput></em></td>
		</tr>
		</table>
	</cfif>
</cfif>