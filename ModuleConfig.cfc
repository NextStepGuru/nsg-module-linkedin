component {

	// Module Properties
	this.title 				= "LinkedIn";
	this.author 			= "Jeremy R DeYoung";
	this.webURL 			= "http://www.nextstep.guru";
	this.description 		= "Coldbox Module to allow Social Login via LinkedIn";
	this.version			= "1.0.5";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "linkedin";
	// Model Namespace
	this.modelNamespace		= "linkedin";
	// CF Mapping
	this.cfmapping			= "linkedin";
	// Module Dependencies
	this.dependencies 		= ["nsg-module-security","nsg-module-oauth"];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			oauth = {
				oauthVersion 		= 2,
				authorizeRequestURL = "https://www.linkedin.com/uas/oauth2/authorization",
				tokenRequestURL 	= "https://www.linkedin.com/uas/oauth2/accessToken"
			}
		};

		// Layout Settings
		layoutSettings = {
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="oauth",action="index"},
			{pattern="/oauth/:id?", handler="oauth",action="index"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = "linkedinLoginSuccess,linkedinLoginFailure"
		};

		// Custom Declared Interceptors
		interceptors = [
		];

		// Binder Mappings
		binder.mapDirectory( "#moduleMapping#.models" );

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var nsgSocialLogin = controller.getSetting('nsgSocialLogin',false,arrayNew());
			arrayAppend(nsgSocialLogin,{"name":"linkedin","icon":"linkedin","title":"LinkedIn"});
			controller.setSetting('nsgSocialLogin',nsgSocialLogin);

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}