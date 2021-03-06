<cfinclude template="../../lib/pxUtil.cfm">

<cffunction 
	name         ="getData" 
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

	<cfargument 
		name     ="usuario" 	
		type     ="numeric"
		required ="false"
		default  ="0"	
		hint     ="ID do usuário">


	<cfargument 
		name     ="rows" 	
		type     ="numeric"
		required ="false"
		default  ="250"	
		hint     ="Número de linhas por select">

	<cfargument 
		name     ="rowFrom" 	
		type     ="numeric"
		required ="false"
		default  ="0"	
		hint     ="Linha inicial do select">

	<cfargument 
		name     ="rowTo" 	
		type     ="numeric"
		required ="false"
		default  ="250"	
		hint     ="Linha final do select">

	<cfargument 
		name     ="table" 	
		type	 ="string"
		required ="false"
		default  =""	
		hint     ="Tabela do banco de dados">

	<cfargument 
		name     ="fields" 	
		type	 ="array"
		required ="false"
		default  ="250"	
		hint     ="Campos do px-grid">


	<cfargument 
		name     ="orderBy" 	
		type	 ="string"
		required ="false"
		default  =""	
		hint     ="Campo ORDER BY da instrução SQL">

	<cfset result = structNew()>
	<cftry>

		<cfset _fields = "">
		<cfloop array="#arguments.fields#" index="i">
			
			<cfset _fields = _fields&i.field&",">
			
		</cfloop>

		<cftransaction>
					
			<cfquery name="qRecordCount" datasource="#arguments.dsn#">
				SELECT
					COUNT(1) as count
				FROM
					#arguments.table#
			</cfquery>
			
			<cfquery name="qQuery" datasource="#arguments.dsn#">
			
				WITH pagination AS
				(
					SELECT 
						#_fields#
						ROW_NUMBER() OVER (ORDER BY exe_id) AS RowNumber
					FROM 
						#arguments.table#
					WHERE 
						1 = 1	
				)
				
				SELECT 
					#_fields# 
					RowNumber
				FROM	
					pagination
				WHERE	
					RowNumber BETWEEN #arguments.rowFrom+1# AND #arguments.rowTo#
				ORDER BY 
					RowNumber ASC

			</cfquery>

		</cftransaction>

		<cfcatch>
			<cfset result.fault = cfcatch>
			<cfreturn result>
		</cfcatch>

	</cftry>

	<cfset result._fields 		= _fields>
	<cfset result.arguments 	= arguments>	
	<cfset result.recordCount 	= qRecordCount.count>
	<cfset result.qQuery 		= QueryToArray(qQuery)>

	<cfreturn result>

</cffunction>