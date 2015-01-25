<cfinclude template="../../lib/pxUtil.cfm">

<cffunction 
	name         ="getController" 
	access       ="remote" 
	output       ="false" 
	returntype   ="Any" 
	returnformat ="JSON">

	<cfargument 
		name     ="dsn"		
		type     ="string"
		required ="false"	
		default  ="phoenix_sql"	
		hint     ="Data source name">


	<!--- <cfreturn arguments> --->

	<cfquery name="qController" datasource="#arguments.dsn#">
		
		SELECT 
			con_id,
			com_id,
			con_file
		FROM 
			px3.controller

	</cfquery>

	<cfreturn QueryToArray(qController)>

</cffunction>