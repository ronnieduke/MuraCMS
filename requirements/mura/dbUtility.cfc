<cfcomponent extends="mura.cfobject" output="false">
	<cfset variables.table="">

<cffunction name="init" output="false">
	<cfargument name="table" default="">
		<cfset setTable(arguments.table)>
		<cfreturn this>
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
		<cfset variables.configBean=arguments.configBean>
		<cfreturn this>
</cffunction>

<cffunction name="setUtility" output="false">
	<cfargument name="utility">
		<cfset variables.utility=arguments.utility>
		<cfreturn this>
</cffunction>

<cffunction name="version" output="false">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		type="version">

	<cfreturn variables.utility.queryRowToStruct(rscheck,1)>
</cffunction>

<!------------- TABLE ----------------->
<cffunction name="setTable" output="false">
	<cfargument name="table">
	<cfset variables.table=arguments.table>
	<cfreturn this>
</cffunction>

<cffunction name="dropTable" output="false">
	<cfargument name="table" default="#variables.table#">
	
	<cfif tableExists(arguments.table)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			DROP TABLE #arguments.table#
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="tableExists" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var tableArray=tables(arguments.table)>
	<cfset var i="">
	
	<cfif arrayLen(tableArray)>
		<cfloop from="1" to="#arrayLen(tableArray)#" index="i">
			<cfif tableArray[i].table_name eq arguments.table>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn false>
</cffunction>

<cffunction name="tables" output="false">
	<cfset var rscheck="">
	<cfset var tableArray=[]>

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		type="tables">

	<cfloop query="rscheck">
		<cfset arrayAppend(tableArray, variables.utility.queryRowToStruct(rsCheck,rsCheck.currentRow))>
	</cfloop>

	<cfreturn tableArray>
</cffunction>


<!----------------- COLUMNS ----------------->

<cffunction name="columns" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rs ="">

	<cfif variables.configBean.getDbType() neq "oracle">
			<cfdbinfo 
			name="rs"
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#"
			table="#arguments.table#"
			type="columns">	
	<cfelse>
		
		<cfquery
			name="rs" 
			datasource="#variables.configBean.getDatasource()#"
			username="#variables.configBean.getDbUsername()#"
			password="#variables.configBean.getDbPassword()#">
				SELECT column_name, data_length column_size, data_type type_name, data_default column_default_value, nullable is_nullable
				FROM user_tab_cols
				WHERE table_name=UPPER('#arguments.table#')
		</cfquery>
		
	</cfif>
	
	<cfreturn transformColumnMetaData(rs,arguments.table)>
</cffunction>

<cffunction name="dropColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfif columnExists(arguments.column,arguments.table)>
	<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#
			</cfquery>
		</cfcase>
	</cfswitch>	
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="addColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int,float,double">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var existing=structNew()>
	<cfset var hasTable=tableExists(arguments.table)>

	<cfif hasTable>
		<cfset existing=columnMetaData(arguments.column,arguments.table)>
	</cfif>

	<cfif arguments.autoincrement>
		<cfset arguments.datatype="int">
		<cfset arguments.nullable=false>
	</cfif>

	<cfif not structIsEmpty(existing)
		and (
			existing.dataType neq arguments.datatype
			and not arguments.autoincrement
			or (
				listFindNoCase("char,varchar",arguments.datatype) 
				and arguments.length neq existing.length
				)
			or existing.nullable neq arguments.nullable
			or existing.default neq arguments.default
			)
		>
			<cftry>
			<cfset alterColumn(argumentCollection=arguments)>
			<cfcatch></cfcatch>
			</cftry>

	<cfelseif not hasTable or structIsEmpty(existing)>
		<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD
				</cfif>
				
				#arguments.column#  <cfif arguments.autoincrement>INT PRIMARY KEY IDENTITY<cfelse>#transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				
				<cfif not hasTable>) ON [PRIMARY]</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD COLUMN
				</cfif>
				
				#arguments.column#  <cfif arguments.autoincrement>INT(10) NOT NULL AUTO_INCREMENT<cfelse>#transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				
				<cfif not hasTable>
					<cfif arguments.autoincrement>
						,PRIMARY KEY(#arguments.column#)
					</cfif>
					) ENGINE=InnoDB DEFAULT CHARSET=utf8
				</cfif>
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				<cfif not hasTable>
					CREATE TABLE #arguments.table# (
				<cfelse>
					ALTER TABLE #arguments.table# ADD <cfif variables.configBean.getDbType() eq "ORACLE">(</cfif>
				</cfif>
				
				#arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>
				
				<cfif not hasTable or variables.configBean.getDbType() eq "ORACLE">)</cfif>
				
				<cfif arguments.datatype eq "longtext">
					lob (#arguments.column#) STORE AS (
					TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
					NOCACHE LOGGING
					STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
					PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
				</cfif>

			</cfquery>
			<cfif arguments.autoincrement>				
				
				<cftry>
				 <cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					DROP SEQUENCE seq_#arguments.table#_#arguments.column#
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					CREATE SEQUENCE seq_#arguments.table#_#arguments.column#
					MINVALUE 1
					START WITH 1
					INCREMENT BY 1
					CACHE 10
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					create or replace TRIGGER trg_#arguments.table#_#arguments.column# BEFORE INSERT ON #arguments.table#
					FOR EACH ROW
					BEGIN
					    SELECT  seq_#arguments.table#_#arguments.column#.NEXTVAL INTO :new.#arguments.column# FROM DUAL;
					END;
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TRIGGER "TPLUGINS_PLUGINID_TRG" ENABLE
				</cfquery>
				<cfset addPrimaryKey(argumentCollection=arguments)>
			</cfif>
		</cfcase>
		</cfswitch>	
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="alterColumn" output="false">
	<cfargument name="column" default="">
	<cfargument name="datatype" default="varchar" hint="varchar,char,text,longtext,datetime,tinyint,int,float,double">
	<cfargument name="length" default="50">
	<cfargument name="nullable" default="true">
	<cfargument name="default" default="null">
	<cfargument name="autoincrement" default="false">
	<cfargument name="table" default="#variables.table#">
	
	<cfif arguments.autoincrement>
		<cfset arguments.datatype="int">
	</cfif>

	<cfif tableExists(arguments.table) and columnExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# ALTER COLUMN #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif arguments.autoincrement>PRIMARY KEY IDENTITY<cfelse><cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# MODIFY COLUMN #arguments.column# <cfif arguments.autoincrement>INT(10) NOT NULL AUTO_INCREMENT<cfelse>#transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif></cfif>
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# RENAME COLUMN #arguments.column# to #arguments.column#2
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# ADD #arguments.column# #transformDataType(arguments.datatype,arguments.length)# <cfif not arguments.nullable> not null </cfif> default <cfif arguments.default eq 'null' or listFindNoCase('int,tinyint',arguments.datatype)>#arguments.default#<cfelse>'#arguments.default#'</cfif>
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					UPDATE #arguments.table# SET #arguments.column#=#arguments.column#2
				</cfquery>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table# DROP COLUMN #arguments.column#2
				</cfquery>
			</cfcase>
		</cfswitch>
	<cfelse>
		<cfset addColumn(argumentCollection=arguments)>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="transformDataType" access="private">
	<cfargument name="datatype" default="varchar">
	<cfargument name="length" default="50">
	<cfset var MSSQLversion=0>
	
	<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "nvarchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "int">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "tinyint">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text,longtext">
					<cfquery name="MSSQLversion" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
						EXEC sp_MSgetversion
					</cfquery>
	
					<cftry>
						<cfset MSSQLversion=left(MSSQLversion.CHARACTER_VALUE,1)>
						<cfcatch>
							<cfset MSSQLversion=mid(MSSQLversion.COMPUTED_COLUMN_1,1,find(".",MSSQLversion.COMPUTED_COLUMN_1)-1)>
						</cfcatch>
					</cftry>
					
					<cfif MSSQLversion neq 8>
						<cfreturn "nvarchar(max)">
					<cfelse>
						<cfreturn "ntext">
					</cfif>
				</cfcase>
				<cfcase value="float">
					<cfreturn "float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "Decimal">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="mysql">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "varchar(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "int(10)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "tinyint">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "datetime">
				</cfcase>
				<cfcase value="text">
					<cfreturn "text">
				</cfcase>
				<cfcase value="longtext">
					<cfreturn "longtext">
				</cfcase>
				<cfcase value="float">
					<cfreturn "float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "double">
				</cfcase>
			</cfswitch>
		</cfcase>
		<cfcase value="oracle">
			<cfswitch expression="#arguments.datatype#">
				<cfcase value="varchar">
					<cfreturn "varchar2(#arguments.length#)">
				</cfcase>
				<cfcase value="char">
					<cfreturn "char(#arguments.length#)">
				</cfcase>
				<cfcase value="int">
					<cfreturn "number(10,0)">
				</cfcase>
				<cfcase value="tinyint">
					<cfreturn "number(3,0)">
				</cfcase>
				<cfcase value="date,datetime">
					<cfreturn "date">
				</cfcase>
				<cfcase value="text,longtext">
					<cfreturn "clob">
				</cfcase>
				<cfcase value="float">
					<cfreturn "binary_float">
				</cfcase>
				<cfcase value="double">
					<cfreturn "binary_double">
				</cfcase>
			</cfswitch>
		</cfcase>
	</cfswitch>
</cffunction>

<cffunction name="columnExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var columnsArray=columns(arguments.table)>
	<cfset var i="">
	
	<cfif arrayLen(columnsArray)>
		<cfloop from="1" to="#arrayLen(columnsArray)#" index="i">
			<cfif columnsArray[i].column eq arguments.column>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn false>
</cffunction>

<cffunction name="transformColumnMetaData" access="private" output="false">
<cfargument name="rs">
<cfargument name="table">
	<cfset var columnsArray=[]>
	<cfset var columnArgs={}>

	<cfset var defaultArgs={
					column="",
					table="",
					datatype="",
					default="null",
					nullable=true,
					autoincrement=false,
					length=50
				}>

	<cfloop query="arguments.rs">
		<cfset columnArgs=structCopy(defaultArgs)>
		<cfset columnArgs.column=arguments.rs.column_name>
		<cfset columnArgs.table=arguments.table>
		
		<cfswitch expression="#arguments.rs.type_name#">
			<cfcase value="varchar,nvarchar,varchar2">
				<!--- Add MSSQL nvarchar(max)--->
				<cfset columnArgs.datatype="varchar">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="char">
				<cfset columnArgs.datatype="varchar">
				<cfset columnArgs.length=arguments.rs.column_size>
			</cfcase>
			<cfcase value="int">
				<cfset columnArgs.datatype="int">
			</cfcase>
			<cfcase value="number">
				<cfif arguments.rs.column_size eq 10>
					<cfset columnArgs.datatype="int">
				<cfelse>
					<cfset columnArgs.datatype="tinyint">
				</cfif>
			</cfcase>
			<cfcase value="tinyint">
				<cfset columnArgs.datatype="tinyint">
			</cfcase>
			<cfcase value="date,datetime">
				<cfset columnArgs.datatype="datetime">
			</cfcase>
			<cfcase value="ntext,longtext,clob">
				<cfset columnArgs.datatype="longtext">
			</cfcase>
			<cfcase value="text">
				<cfset columnArgs.datatype="text">
			</cfcase>
			<cfcase value="float,binary_float">
				<cfset columnArgs.datatype="float">
			</cfcase>
			<cfcase value="double,decimal,binary_double">
				<cfset columnArgs.datatype="double">
			</cfcase>
		</cfswitch>

		<cfif arguments.rs.is_nullable eq "y" or (isBoolean(arguments.rs.is_nullable) and arguments.rs.is_nullable)>
			<cfset columnArgs.nullable=true>
		<cfelse>
			<cfset columnArgs.nullable=false>
		</cfif>

		<cfif len(arguments.rs.column_default_value)>
			<cfset columnArgs.default=arguments.rs.column_default_value>
		</cfif>

		<cfif len(columnArgs.default) and columnArgs.default neq "null"
			and listFindNoCase("tinyint,int,float,double",columnArgs.datatype)>
			<cfset columnArgs.default=_parseInt(columnArgs.default)>
		</cfif>

		<cfif not columnArgs.nullable and columnArgs.datatype eq "int" and isDefined('rs.is_primarykey') and arguments.rs.is_primarykey>
			<cfset columnArgs.autoincrement=true>
		</cfif>

		<cfset arrayAppend(columnsArray,columnArgs)>
	</cfloop>

	<cfreturn columnsArray>

</cffunction>

<cffunction name="columnMetaData" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var columnsArray=columns(arguments.table)>
	<cfset var i ="">

	<cfif arrayLen(columnsArray)>
		<cfloop from="1" to="#arrayLen(columnsArray)#" index="i">
			<cfif columnsArray[i].column eq arguments.column>
				<cfreturn columnsArray[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn structNew()>
</cffunction>

<!---------------- INDEXES --------------------------->
<cffunction name="addIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfset var rsCheck="">
	
	<cfif not indexExists(arguments.column,arguments.table)>
	<cftry>
		<cfswitch expression="#variables.configBean.getDbType()#">
		<cfcase value="mssql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="mysql">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		<cfcase value="oracle">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			CREATE INDEX #transformIndexName(argumentCollection=arguments)# ON #arguments.table# (#arguments.column#)
			</cfquery>
		</cfcase>
		</cfswitch>	
	<cfcatch></cfcatch>
	</cftry>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="dropIndex" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">

	<cfif indexExists(arguments.column,arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)# on #arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
				DROP INDEX #transformIndexName(argumentCollection=arguments)#
				</cfquery>
			</cfcase>
		</cfswitch>	
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="transformIndexName" access="private">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql,mysql">
				<cfreturn rereplace(replace("IX_#arguments.table#_#arguments.column#",",","ALL"),"[[:space:]]","","All")>
			</cfcase>
			<cfcase value="oracle">
				<cfreturn rereplace(replace(right("IX_#arguments.table#_#arguments.column#",30),",","ALL"),"[[:space:]]","","All")>
			</cfcase>
		</cfswitch>	
</cffunction>

<cffunction name="indexes" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rs="">

	<cfdbinfo 
		name="rs"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="index">
	<cfreturn buildIndexMetaData(rs,arguments.table)>
</cffunction>

<cffunction name="buildIndexMetaData" access="private" output="false">
	<cfargument name="rs">
	<cfargument name="table">
	<cfset var index={}>
	<cfset var indexArray=[]>

 	<cfif rs.recordcount>
		<cfloop query="rs">
			<cfset index={table=arguments.table,
					column=rs.column_name,
					name=rs.index_name
					}>
			<cfif rs.NON_UNIQUE>
				<cfset index.unique=false>
			<cfelse>
				<cfset index.unique=true>
			</cfif>
			<cfset arrayAppend(indexArray,index)>
		</cfloop>
	</cfif>
	<cfreturn indexArray>
</cffunction>

<cffunction name="indexExists" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var indexArray=indexes(arguments.table)>
	<cfset var i="">
	
	<cfif arrayLen(indexArray)>
		<cfloop from="1" to="#arrayLen(indexArray)#" index="i">
			<cfif indexArray[i].column eq arguments.column>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="indexMetaData" output="false">
	<cfargument name="column">
	<cfargument name="table" default="#variables.table#">
	<cfset var indexArray=indexes(arguments.table)>
	<cfset var i="">

	<cfif arrayLen(indexArray)>
		<cfloop from="1" to="#arrayLen(indexArray)#" index="i">
			<cfif indexArray[i].column eq arguments.column>
				<cfreturn indexArray[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn structNew()>
</cffunction>

<!--------- PRIMARY KEY -------------------->
<cffunction name="primaryKeyExists" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="index">
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like 'primary'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
	</cfquery>

	<cfreturn rsCheck.recordcount>
</cffunction>

<cffunction name="primaryKeyMetaData" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="index">
	
	<cfquery name="rsCheck" dbtype="query">
		select * from rsCheck where lower(rsCheck.INDEX_NAME) like 'primary'
		or lower(rsCheck.INDEX_NAME) like 'pk_%'
	</cfquery>

	<cfreturn buildIndexMetatData(rsCheck,arguments.table)>
</cffunction>

<cffunction name="addPrimaryKey" output="false">
	<cfargument name="column" default="">
	<cfargument name="table" default="#variables.table#">
	
	<cfif not primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
						ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
	    			ADD PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
					ADD CONSTRAINT pk_#arguments.table# PRIMARY KEY (#arguments.column#)
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="dropPrimaryKey" output="false">
	<cfargument name="table" default="#variables.table#">
	
	<cfif primaryKeyExists(arguments.table)>
		<cfswitch expression="#variables.configBean.getDbType()#">
			<cfcase value="mssql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT pk_#arguments.table#
				</cfquery>
			</cfcase>
			<cfcase value="mysql">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
	    			DROP PRIMARY KEY
				</cfquery>
			</cfcase>
			<cfcase value="oracle">
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
					ALTER TABLE #arguments.table#
					DROP CONSTRAINT pk_#arguments.table#
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfreturn this>
</cffunction>


<!------------ FOREIGN KEYS ------------------------->

<cffunction name="foreignKeyExists" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">

	<cfset var fkArray=foreignKeys(argumentCollection=arguments)>
	<cfset var i="">
	
	<cfif arrayLen(fkArray)>
		<cfloop from="1" to="#arrayLen(fkArray)#" index="i">
			<cfif fkArray[i].fkColumn eq arguments.fkColumn
			and fkArray[i].fkTable eq arguments.fkTable>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="foreignKeyMetaData" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var fkArray=foreignKeys(argumentCollection=arguments)>
	<cfset var i="">
	
	<cfif arrayLen(fkArray)>
		<cfloop from="1" to="#arrayLen(fkArray)#" index="i">
			<cfif fkArray[i].fkColumn eq arguments.fkColumn
			and fkArray[i].fkTable eq arguments.fkTable>
				<cfreturn fkArray[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn structNew()>
</cffunction>

<cffunction name="addForeignKey" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfif not foreignKeyExists(
							table=arguments.fkTable,
							column=arguments.fkColumn,
							fkTable=arguments.table,
							fkColumn=arguments.column
						)>	
		<cfset addIndex(arguments.column,arguments.table)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table#
			ADD CONSTRAINT fk_#arguments.fktable#_#arguments.fkcolumn#
			FOREIGN KEY (#arguments.column#)
			REFERENCES #arguments.fktable#(#arguments.fkcolumn#)

			<!---
			MySQL
			ON DELETE reference_option
		    ON UPDATE reference_option
		    --->
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="dropForeignKey" output="false">
	<cfargument name="column">
	<cfargument name="fkColumn">
	<cfargument name="fkTable">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfif not foreignKeyExists(
							table=arguments.fkTable,
							column=arguments.fkColumn,
							fkTable=arguments.table,
							fkColumn=arguments.column
						)>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
			ALTER TABLE #arguments.table#
			DROP <cfif variables.configBean.getDbType() eq 'MySQL'>FOREIGN KEY<cfelse>CONSTRAINT</cfif> fk_#arguments.fktable#_#arguments.fkcolumn#
		</cfquery>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="buildForeignKeyMetaData" access="private" output="false">
	<cfargument name="rs">
	<cfargument name="table">
	<cfset var fk={}>
	<cfset var fkArray=[]>

	<cfif rs.recordcount>
		<cfloop query="rs">

			<cfset fk={table=arguments.table,
					fkTable=rs.fkTable_name,
					fkColumn=rs.fkcolumn_name,
					deleteRule=rs.delete_rule,
					updateRule=rs.update_rule}>
			<cfset arrayAppend(fkArray,fk)>
		</cfloop>
	</cfif>
	<cfreturn fkArray>
</cffunction>

<cffunction name="foreignKeys" output="false">
	<cfargument name="table" default="#variables.table#">
	<cfset var rscheck="">

	<cfdbinfo 
		name="rsCheck"
		datasource="#variables.configBean.getDatasource()#"
		username="#variables.configBean.getDbUsername()#"
		password="#variables.configBean.getDbPassword()#"
		table="#arguments.table#"
		type="foreignKeys">


	<cfreturn buildForeignKeyMetaData(rsCheck,arguments.table)>
</cffunction>

<cfscript>
/**
 * Parse out the first set of numbers in a string.
 * 
 * @param string      String to parse. (Required)
 * @return Returns a string. 
 * @author Marco G. Williams (email@marcogwilliams.com) 
 * @version 1, May 22, 2003 
 */
function _parseInt(String){
    var NewString = "";
    var i = 1;

    for(i=1; i lt Len(arguments.String); i = i + 1) {
        if( isNumeric( mid(arguments.String,i,1) ) ) { newString = val( mid( arguments.String,i,Len(arguments.String) ) ); break;}
    }
    return NewString;
}
</cfscript>

</cfcomponent>