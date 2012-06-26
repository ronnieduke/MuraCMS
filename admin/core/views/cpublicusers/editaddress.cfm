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
<cfset rsAddress=rc.userBean.getAddressById(rc.addressID)>
<cfset addressBean=rc.userBean.getAddressBeanById(rc.addressID)>
<cfset extendSets=application.classExtensionManager.getSubTypeByName("Address",rc.userBean.getsubtype(),rc.userBean.getSiteID()).getExtendSets(inherit=true,activeOnly=true) />
<cfoutput><form novalidate="novalidate" action="index.cfm?muraAction=cPublicUsers.updateAddress&userid=#URLEncodedFormat(rc.userid)#&routeid=#rc.routeid#&siteid=#URLEncodedFormat(rc.siteid)#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h2>#application.rbFactory.getKeyValue(session.rb,'user.memberaddressform')#</h2>
	
	<!--- #application.utility.displayErrors(rc.addressBean.getErrors())# --->
	
	<h3>#rc.userBean.getFname()# #rc.userBean.getlname()# <a href="index.cfm?muraAction=cPublicUsers.editUser&userid=#URLEncodedFormat(rc.userid)#&siteid=#URLEncodedFormat(rc.siteid)#&routeid=#rc.routeid#">[#application.rbFactory.getKeyValue(session.rb,'user.back')#]</a></h3>
	
	<cfif arrayLen(extendSets)>
	<br/>
	<div id="page_tabView">
	<div class="page_aTab">
	</cfif>
	
		<dl class="oneColumn">
		<dt class="first"></dt>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.addressname')#</dt>
		<dd><input id="addressName" name="addressName" type="text" value="#HTMLEditFormat(rsAddress.addressName)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address1')#</dt>
		<dd><input id="address1" name="address1" type="text" value="#HTMLEditFormat(rsAddress.address1)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address2')#</dt>
		<dd><input id="address2" name="address2" type="text" value="#HTMLEditFormat(rsAddress.address2)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.city')#</dt>
		<dd><input id="city" name="city" type="text" value="#HTMLEditFormat(rsAddress.city)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.state')#</dt>
		<dd><input id="state" name="state" type="text" value="#HTMLEditFormat(rsAddress.state)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.zip')#</dt>
		<dd><input id="zip" name="zip" type="text" value="#HTMLEditFormat(rsAddress.zip)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.country')#</dt>
		<dd><input id="country" name="country" type="text" value="#HTMLEditFormat(rsAddress.country)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.phone')#</dt>
		<dd><input id="phone" name="phone" type="text" value="#HTMLEditFormat(rsAddress.phone)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.fax')#</dt>
		<dd><input id="fax" name="fax" type="text" value="#HTMLEditFormat(rsAddress.fax)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</dt>
		<dd><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(rsAddress.addressURL)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
		<dd><input id="addressEmail" name="addressEmail" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#" type="text" value="#HTMLEditFormat(rsAddress.addressEmail)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.hours')#</dt>
		<dd><textarea id="hours" name="hours" >#HTMLEditFormat(rsAddress.hours)#</textarea></dd> 
</dl>

<!--- extended attributes as defined in the class extension manager --->
<cfif arrayLen(extendSets)>
</div>
<div class="page_aTab">
<dl class="oneColumn" id="extendDL">
<cfloop from="1" to="#arrayLen(extendSets)#" index="s">	
<cfset extendSetBean=extendSets[s]/>
<cfoutput><cfset style=extendSetBean.getStyle()/><cfif not len(style)><cfset started=true/></cfif>
	<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
	<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
	<dt <cfif not started>class="first"<cfset started=true/><cfelse>class="separate"</cfif>>#extendSetBean.getName()#</dt>
	<cfsilent>
	<cfset attributesArray=extendSetBean.getAttributes() />
	</cfsilent>
	<dd><dl><cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
		<cfset attributeBean=attributesArray[a]/>
		<cfset attributeValue=addressBean.getExtendedAttribute(attributeBean.getAttributeID(),true) />
		<dt>
		<cfif len(attributeBean.getHint())>
		<a href="##" class="tooltip">#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif> <span>#attributeBean.gethint()#</span></a>
		<cfelse>
		#attributeBean.getLabel()# <cfif attributeBean.getType() IS "Hidden"><strong>[Hidden]</strong></cfif>
		</cfif>
		<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'> <a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#attributeValue#" target="_blank">[Download]</a> <input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/> Delete</cfif>
		</dt>
		
		<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
		<cfif attributeBean.getType() IS "Hidden">
			<cfset attributeBean.setType( "TextBox" ) />
		</cfif>	
		
		<dd>#attributeBean.renderAttribute(attributeValue)#</dd>
	</cfloop></dl></dd>
</cfoutput>
</cfloop>
</dl>
</div>
</div>

<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"),0,0,0);
</script>	
</cfif>
	
		<cfif rc.addressid eq ''>
        
				<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'user.add')#" />
           <cfelse>
            	<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'user.update')#" />
				<input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" />
           </cfif>


		<input type="hidden" name="action" value="">
		<input type="hidden" name="addressID" value="#rc.addressID#">
		<input type="hidden" name="isPublic" value="#rc.userBean.getIsPublic()#">
		<cfif not rc.userBean.getAddresses().recordcount><input type="hidden" name="isPrimary" value="1"></cfif>
	
	</cfoutput>

</form>
