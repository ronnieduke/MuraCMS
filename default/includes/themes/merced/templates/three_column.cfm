<cfoutput>
<cfinclude template="inc/html_head.cfm" />
<body id="#$.getTopID()#" class="threeCol depth#arrayLen($.event('crumbdata'))#">
<div id="container" class="#$.createCSSid($.content('menuTitle'))#">
	<cfinclude template="inc/header.cfm" />
	<div id="content" class="clearfix">
		<aside id="left">
			#$.dspObjects(1)#
		</aside>
		<article>
			<nav>#$.dspCrumbListLinks("crumblist","&nbsp;&raquo;&nbsp;")#</nav>
			#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
			#$.dspObjects(2)#
		</article>
		<aside id="right">
			#$.dspObjects(3)#
		</aside>
	</div>
	<cfinclude template="inc/footer.cfm" />
</div>
</body>
</html>
</cfoutput>