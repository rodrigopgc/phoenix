<!--- 

Pesquisa e estudos para criação do phoenix menu ;)

 --->
<html>

	<cfoutput>
		<cfparam name="arguments.dsn" default="phoenix_sql">

		<cfquery datasource="#arguments.dsn#" name="qMenu">
			
			<!--- http://blogs.msdn.com/b/fcatae/archive/2010/11/10/query-recursiva.aspx --->
			WITH phoenixMenumen_nivel(men_id, men_nome, men_nivel, men_nomeCaminho, men_ordem, men_idPai)
			AS
			(
			    -- Ancora
			    SELECT men_id,men_nome, 1 AS 'men_nivel',CAST(men_nome AS VARCHAR(255)) AS 'men_nomeCaminho', men_ordem, men_idPai
			    FROM px3.menu WHERE (men_idPai IS NULL OR men_idPai = 0)
			   	    
			    UNION ALL
			    
			    -- Parte RECURSIVA
			    SELECT 
			        m.men_id, m.men_nome, c.men_nivel + 1 AS 'men_nivel',
			        CAST((c.men_nomeCaminho + '||' + m.men_nome) AS VARCHAR(255)) 'men_nomeCaminho', m.men_ordem, m.men_idPai
			    FROM px3.menu m INNER JOIN phoenixMenumen_nivel c ON m.men_idPai = c.men_id

			    
			)
			SELECT men_nivel, men_nomeCaminho, men_ordem, men_idPai FROM phoenixMenumen_nivel

		</cfquery>

		<cfdump var="#qMenu#">

		<cfquery name="qMenuOrdem" dbtype="query"> 
		    SELECT 
		    	*
		    FROM 
		    	qMenu  
		    ORDER BY 
		    	men_nivel
		    	,men_ordem 
		</cfquery>

		<cfdump var="#qMenuOrdem#">


		<cfset arrayMenu 	= arrayNew(1)>
		<cfset structMenu 	= structNew()>

		<cfloop query="qMenuOrdem">
			
			<cfscript>
				
				arrayMenuAtual = listToArray(qMenuOrdem.men_nomeCaminho, "||");
				
				if (arrayLen(arrayMenuAtual) GT 1){

					menuAtual = arrayMenuAtual[arrayLen(arrayMenuAtual)];			
					menuPai   = arrayMenuAtual[arrayLen(arrayMenuAtual)-1];

					structMenu[menuAtual]          = structNew();
					structMenu[menuAtual].men_nome = menuAtual;
					structMenu[menuAtual].com_id   = 1;
					structMenu[menuAtual].menus    = arrayNew(1);		// array de menus filhos

					arrayAppend(structMenu[menuPai].menus, structMenu[menuAtual]);

					//writeDump(structMenu[menuPai]);

				}
				else{

					menuAtual = arrayMenuAtual[1];			
					menuPai   = 0;

					if(not structKeyExists(structMenu, menuAtual)){

						structMenu[menuAtual]          = structNew();
						structMenu[menuAtual].men_nome = menuAtual;
						structMenu[menuAtual].com_id   = 1;
						structMenu[menuAtual].menus    = arrayNew(1);	// array de menus filhos
					}

					arrayAppend(arrayMenu, structMenu[menuAtual]);
				}
				
						
			</cfscript>

		</cfloop>

		<cfdump var="#arrayMenu#">

	</cfoutput>


	<br><br><br>
	<h1>Phoenix Menu :)</h1>
	<br>

	<cfquery datasource="#arguments.dsn#" name="qMenu">
	    SELECT
	    	menu.men_ativo
	    	,menu.men_sistema
			,menu.men_id
			,menu.men_nome
			,menu.men_idPai
			,menu.men_ordem
			,(SELECT COUNT(1) FROM px3.menu AS submenu WHERE menu.men_id = submenu.men_idPai AND men_ativo = 1 AND men_sistema = 1) AS count_submenu
			,(SELECT COUNT(1) FROM px3.menu AS submenu WHERE submenu.men_idPai = menu.men_idPai AND men_ativo = 1 AND men_sistema = 1) AS count_menu
		FROM
			px3.menu AS menu
		WHERE
			menu.men_ativo	 = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		AND menu.men_sistema = <cfqueryparam cfsqltype="cf_sql_bit" value="1"/>
		ORDER BY
			menu.men_idPai
			,menu.men_ordem 
	</cfquery>

	<cfdump var="#qMenu#">

	<!--- Função desenvolvida baseada em:
	http://www.bennadel.com/blog/1069-ask-ben-simple-recursion-example.htm --->
	<cffunction
	    name="recuperaMenuRecursivo"
	    access="public"
	    returntype="void"
	    output="true"
	    hint="Faz a saída dos menus filhos de um determinado menu pai">
	 
	    <!--- Define argumentos. --->
	    <cfargument
	        name="Dados"
	        type="query"
	        required="true"
	        hint="Dados dos menus"
	        />
	 
	    <cfargument
	        name="men_idPai"
	        type="numeric"
	        required="false"
	        default="0"
	        hint="ID do menu pai que o menu filho pertence"
	        />

	    <!--- Define o scope local. --->
	    <cfset var LOCAL = StructNew() />
	 
	 
	    <!--- Menus do menu pai. --->
	    <cfquery name="LOCAL.qMenu" dbtype="query">
	        SELECT
	            men_id
	            ,men_idPai
	            ,men_nome
	            ,men_ordem
	            ,count_submenu
	            ,count_menu
	        FROM
	            ARGUMENTS.Dados
	        WHERE
	        	men_ativo   = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			AND men_sistema = <cfqueryparam cfsqltype="cf_sql_bit" value="1"/>
	        AND men_idPai 	= <cfqueryparam value="#ARGUMENTS.men_idPai#" cfsqltype="cf_sql_integer" />
	        ORDER BY
	            men_ordem ASC
	    </cfquery>


	    <!---     
	        Verifica se existem algum menu filho.
	    --->
	    <cfif LOCAL.qMenu.RecordCount>
	 
	      
	            <!--- Loop over children. --->
	            <cfloop query="LOCAL.qMenu">
	 
	                	<cfif LOCAL.qMenu.count_submenu GT 0>
	                		<li>
	                			<a class='dropdown-toggle'>#LOCAL.qMenu.men_nome# </a>

	                			<ul class='dropdown-menu' data-role='dropdown'>

	                		<!---
		                        Now that we are looking at a particular
		                        child, we want to recursively call this
		                        function (from within itself) to see if
		                        this child has, itself, some children.
		 
		                        We are passing along the same data set,
		                        but instead of passing along the
		                        original ParentID, we passing along THIS
		                        child's ID as the next round or Parent
		                        IDs.
		                    --->
		                    <cfset recuperaMenuRecursivo(
		                        Dados = ARGUMENTS.Dados,
		                        men_idPai = LOCAL.qMenu.men_id		                       
		                        ) />
	                	

		                <cfelseif LOCAL.qMenu.men_idPai GT 0>

		                	<cfif LOCAL.qMenu.men_ordem EQ 1>
		                		
		                		<!---<ul class='dropdown-menu' data-role='dropdown'> --->

		                	</cfif>
		                	
		                		<li>
		                			<a>#LOCAL.qMenu.men_nome#</a>
		                		</li>
		                     
	                	<cfelse>
	                		
	                		<li>
	                			<a>#LOCAL.qMenu.men_nome#</a>
	                		</li>

	                	</cfif>	                  
	                
	                
               			<cfif (LOCAL.qMenu.men_ordem GTE LOCAL.qMenu.count_menu)>

		                	 </ul> </li>	

		                </cfif>
	 
	            </cfloop>
	        
	 	
	    </cfif>

	    <!--- Return out. --->
	    <cfreturn />
	</cffunction>

	<cfset recuperaMenuRecursivo(
		    Dados = qMenu
		    ) />

	<cfsavecontent 
	    variable = "pxMenu">
	    

		<cfset recuperaMenuRecursivo(
		    Dados = qMenu
		    ) />

	</cfsavecontent>

	<br>
	<hr>
	<h1><font color="#FF0000">cfsavecontent</font></h1>
	<br><br>

	<cfset menu = "<ul id='menu' class='element-menu'>#pxMenu#</ul>">
	<cfdump var="#menu#">

	<cfoutput>#menu#</cfoutput>
	<hr>
</html>




-- Teste manuais
<ul id='menu' class='element-menu'> 
	<li> 
		<a class='dropdown-toggle'>Painel </a> 

		<ul class='dropdown-menu' data-role='dropdown'> 

			<li> 
				<a>Exemplo 1</a> 
			</li> 

			<li> 
				<a class='dropdown-toggle'>Exemplo 2 </a> 

			<li> 
				<a class='dropdown-toggle'>Exemplo 3 </a> 
		
				<ul class='dropdown-menu' data-role='dropdown'> 
					<li> <a>Exemplo 6 </a> </li> 
				</ul> 

			</li>	
		
			<li> 
				<a>Exemplo 5</a> 
			</li> 

			<li> 
				<a>Exemplo 4</a> 
			</li> 
		</ul> 

	</li> 
</ul>


<ul id='menu' class='element-menu'> 
	<li> 
		<a class='dropdown-toggle'>Painel </a> 

		<ul class='dropdown-menu' data-role='dropdown'> 

			<li> 
				<a>Exemplo 1</a> 
			</li> 

			<li> 
				<a class='dropdown-toggle'>Exemplo 2 </a> 

				<ul class='dropdown-menu' data-role='dropdown'> 
						<li> <a>Exemplo 3</a> </li> 

						<ul class='dropdown-menu' data-role='dropdown'> 
						<li> <a>Exemplo 6 </a> </li> 
					</ul> 
				</ul> 
		
			</li>	
		
			<li> 
				<a>Exemplo 5</a> 
			</li> 

			<li> 
				<a>Exemplo 4</a> 
			</li> 
		</ul> 

	</li> 
</ul>


<ul id='menu' class='element-menu'> 
	<li> <a class='dropdown-toggle'>Painel </a> 
		<ul class='dropdown-menu' data-role='dropdown'> 
			<li> <a>Exemplo 1</a> </li> 
		</ul> 
	</li>	
</ul> </li>	</ul>


<cfabort>
<br><br>
Original
<br><br>
<cffunction
    name="OutputChildren"
    access="public"
    returntype="void"
    output="true"
    hint="Outputs the children of a given parent.">
 
    <!--- Define arguments. --->
    <cfargument
        name="Data"
        type="query"
        required="true"
        hint="Family tree data query."
        />
 
    <cfargument
        name="ParentID"
        type="numeric"
        required="false"
        default="0"
        hint="The ID of the parent who's children we want to output."
        />
 
    <!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />
 
 
    <!--- Query for the children of the given parent. --->
    <cfquery name="LOCAL.Children" dbtype="query">
        SELECT
            id,
            name
        FROM
            ARGUMENTS.Data
        WHERE
            parent_id = <cfqueryparam value="#ARGUMENTS.ParentID#" cfsqltype="cf_sql_integer" />
        ORDER BY
            name ASC
    </cfquery>
 
 
    <!---
        Check to see if we found any children. This is our
        END case scenario. If there are no children then our
        recursion will come to a stop for this path.
    --->
    <cfif LOCAL.Children.RecordCount>
 
        <ul>
            <!--- Loop over children. --->
            <cfloop query="LOCAL.Children">
 
                <li>
                    #LOCAL.Children.name#
 
                    <!---
                        Now that we are looking at a particular
                        child, we want to recursively call this
                        function (from within itself) to see if
                        this child has, itself, some children.
 
                        We are passing along the same data set,
                        but instead of passing along the
                        original ParentID, we passing along THIS
                        child's ID as the next round or Parent
                        IDs.
                    --->
                    <cfset OutputChildren(
                        Data = ARGUMENTS.Data,
                        ParentID = LOCAL.Children.id
                        ) />
                </li>
 
            </cfloop>
        </ul>
 
    </cfif>
 
    <!--- Return out. --->
    <cfreturn />
</cffunction>







<!--- 
	Código atual:
	
    <cfparam name="arguments.dsn" default="phoenix_sql">
    
    <cfquery datasource="#arguments.dsn#" name="qMenu">
        SELECT
            menu.men_ativo
            ,menu.men_id
            ,menu.men_nome
            ,menu.men_idPai
            ,menu.men_ordem
            ,(SELECT COUNT(1) FROM px3.menu AS submenu WHERE menu.men_id = submenu.men_idPai AND men_sistema = 1) AS count_submenu
            ,(SELECT COUNT(1) FROM px3.menu AS submenu WHERE submenu.men_idPai = menu.men_idPai AND men_sistema = 1) AS count_menu
        FROM
            px3.menu AS menu
        WHERE
            men_ativo = <cfqueryparam value="1" cfsqltype="cf_sql_bit" />
        AND men_sistema = 1
        ORDER BY
            menu.men_idPai
            ,menu.men_ordem 
    </cfquery>

    <!--- Função desenvolvida baseada em:
    http://www.bennadel.com/blog/1069-ask-ben-simple-recursion-example.htm --->

    <cffunction
        name="recuperaMenuRecursivo"
        access="public"
        returntype="void"
        output="true"
        hint="Faz a saída dos menus filhos de um determinado menu pai">
     
        <!--- Define argumentos. --->
        <cfargument
            name="Dados"
            type="query"
            required="true"
            hint="Dados dos menus"
            />
     
        <cfargument
            name="men_idPai"
            type="numeric"
            required="false"
            default="0"
            hint="ID do menu pai que o menu filho pertence"
            />

        <!--- Define o scope local. --->
        <cfset var LOCAL = StructNew() />
     
     
        <!--- Menus do menu pai. --->
        <cfquery name="LOCAL.qMenu" dbtype="query">
            SELECT
                men_id
                ,men_idPai
                ,men_nome
                ,men_ordem
                ,count_submenu
                ,count_menu
            FROM
                ARGUMENTS.Dados
            WHERE
                men_ativo = <cfqueryparam value="1"                     cfsqltype="cf_sql_bit" />
            AND men_idPai = <cfqueryparam value="#ARGUMENTS.men_idPai#" cfsqltype="cf_sql_integer" />
            ORDER BY
                men_ordem ASC
        </cfquery>


        <!---     
            Verifica se existem algum menu filho.
        --->
        <cfif LOCAL.qMenu.RecordCount>
     
          
                <!--- Loop over children. --->
                <cfloop query="LOCAL.qMenu">
     
                        <cfif LOCAL.qMenu.count_submenu GT 0>
                            <li>
                                <a class='dropdown-toggle'>#LOCAL.qMenu.men_nome# </a>

                                <ul class='dropdown-menu' data-role='dropdown'>

                            <!---
                                Now that we are looking at a particular
                                child, we want to recursively call this
                                function (from within itself) to see if
                                this child has, itself, some children.
         
                                We are passing along the same data set,
                                but instead of passing along the
                                original ParentID, we passing along THIS
                                child's ID as the next round or Parent
                                IDs.
                            --->
                            <cfset recuperaMenuRecursivo(
                                Dados = ARGUMENTS.Dados,
                                men_idPai = LOCAL.qMenu.men_id                             
                                ) />
                        

                        <cfelseif LOCAL.qMenu.men_idPai GT 0>

                            <cfif LOCAL.qMenu.men_ordem EQ 1>
                                
                                <!---<ul class='dropdown-menu' data-role='dropdown'> --->

                            </cfif>
                            
                                <li>
                                    <a>#LOCAL.qMenu.men_nome#</a>
                                </li>
                             
                        <cfelse>
                            
                            <li>
                                <a>#LOCAL.qMenu.men_nome#</a>
                            </li>

                        </cfif>                   
                    
                    
                        <cfif (LOCAL.qMenu.men_ordem EQ LOCAL.qMenu.count_menu)>

                             </ul> </li>    

                        </cfif>
     
                </cfloop>
            
        
        </cfif>

        <!--- Return out. --->
        <cfreturn />
    </cffunction>

    <cfsavecontent 
        variable = "pxMenu">
        

        <cfset recuperaMenuRecursivo(
            Dados = qMenu
            ) />

    </cfsavecontent>
    --->

--->