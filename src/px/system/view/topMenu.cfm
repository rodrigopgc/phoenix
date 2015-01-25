<div    
    id            ="menuDiv" 
    class         ="navbar bg-dark" 
    ng-controller ="pxTopMenuCtrl"
    >

    <cfinvoke 
        component      ="phoenix.src.px.system.model.menu"
        method         ="getMenu"
        returnvariable ="pxMenu"
        >
    
    <div class="navbar-content">

        <a class="pull-menu" href="#"></a>

        <ul id="menu" class="element-menu"> 

            <cfoutput>#pxMenu#</cfoutput>

            <!--- 
            <div class="element place-right">
                <a class="dropdown-toggle">
                    <span class="icon-cog"></span>
                </a>
                <ul class="dropdown-menu place-right" data-role="dropdown" ng-click="logout()">
                    <li>
                        <i class="icon-exit on-left"></i>Sair
                    </li>
                </ul>
            </div>
            --->

            <!--- 
            <span class="element-divider"></span>
            --->            
            <button class="element image-button image-left place-right bg-dark">Sistema Phoenix 3 - Rich Solutions
                <img id="topMenuImgLogo" ng-src="{{logo}}"/>
            </button>            

        </ul>
    
    </div>

</div>



