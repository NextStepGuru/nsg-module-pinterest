component {

	// Module Properties
	this.title 				= "Pinterest";
	this.author 			= "Jeremy R DeYoung";
	this.webURL 			= "http://www.nextstep.guru";
	this.description 		= "Coldbox Module to allow Social Login via Pinterest";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "pinterest";
	// Model Namespace
	this.modelNamespace		= "pinterest";
	// CF Mapping
	this.cfmapping			= "pinterest";
	// Module Dependencies
	this.dependencies 		= ["nsg-module-security","nsg-module-oauth"];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			oauth = {
				oauthVersion 		= 1,
				tokenRequestURL 	= "https://api.pinterest.com/oauth/request_token",
				authorizeRequestURL = "https://api.pinterest.com/oauth/authorize",
				accessRequestURL 	= "https://api.pinterest.com/oauth/access_token"
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
			customInterceptionPoints = "pinterestLoginSuccess,pinterestLoginFailure"
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
		/*
		its still not working correctly, pinterest won't approve my app to test
		var nsgSocialLogin = controller.getSetting('nsgSocialLogin',false,arrayNew());
			arrayAppend(nsgSocialLogin,{"name":"pinterest","icon":"pinterest","title":"Pinterest"});
			controller.setSetting('nsgSocialLogin',nsgSocialLogin);
		*/
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}