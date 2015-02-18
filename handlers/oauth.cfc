component {

	property name="oauthService" inject="oauthV1Service@oauth";

	function preHandler(event,rc,prc){
		if( !structKeyExists(getSetting('linkedin'),'oauth') ){
			throw('You must define the OAuth setting in your Coldbox.cfc','linkedin.setup');
		}
		prc.linkedinCredentials = getSetting('linkedin')['oauth'];
		prc.linkedinSetting = getModuleSettings( module=event.getCurrentModule(), setting="oauth" );

		if(!structKeyExists(session,'linkedinOAuth')){
			session['linkedinOAuth'] = structNew();
		}
	}

	function index(event,rc,prc){
	}

}