<cfscript>
	dbUtility.setTable('tsettings')
	 .addColumn(column='reCAPTCHASiteKey', datatype='varchar', length=50)
	 .addColumn(column='reCAPTCHASecret', datatype='varchar', length=50)
   .addColumn(column='reCAPTCHALanguage', datatype='varchar', length=25);
</cfscript>