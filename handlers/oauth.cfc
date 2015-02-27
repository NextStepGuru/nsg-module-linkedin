component {

	function preHandler(event,rc,prc){
		prc.linkedinCredentials = getSetting('linkedin')['oauth'];
		prc.linkedinSettings = getModuleSettings('nsg-module-linkedin')['oauth'];
		if(!structKeyExists(session,'linkedinOAuth')){
			session['linkedinOAuth'] = structNew();
		}
	}

	function index(event,rc,prc){

		if( event.getValue('id','') == 'activateUser' ){
			var results = duplicate(session['linkedinOAuth']);

			var httpService = new http();
				httpService.setEncodeURL(false);
				httpService.setURL('https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)?format=json');
				httpservice.addParam(type='header',name="Authorization",value="Bearer #session['linkedinOAuth']['access_token']#");
			var data = deserializeJSON(httpService.send().getPrefix()['fileContent']);
			structAppend(results,data);

			structKeyRename(results,'firstName','first');
			structKeyRename(results,'lastName','last');
			structKeyRename(results,'emailAddress','email');
			structKeyRename(results,'access_token','accessToken');
			structKeyRename(results,'id','referenceID');

			results['socialservice'] = 'LinkedIn';

			announceInterception( state='linkedinLoginSuccess', interceptData=results );
			announceInterception( state='loginSuccess', interceptData=results );
			setNextEvent(view=prc.linkedinCredentials['loginSuccess'],ssl=( cgi.server_port == 443 ? true : false ));

		}else if( event.valueExists('code') ){
			session['linkedinOAuth']['code'] = event.getValue('code');

			var httpService = new http();
				httpService.setMethod('post');
				httpService.setURL(prc.linkedinSettings['tokenRequestURL']);
				httpService.addParam(type="formfield",name='code', value=session['linkedinOAuth']['code']);
				httpService.addParam(type="formfield",name='client_id', value=prc.linkedinCredentials['apiKey']);
				httpService.addParam(type="formfield",name='client_secret', value=prc.linkedinCredentials['apiSecret']);
				httpService.addParam(type="formfield",name='redirect_uri', value=prc.linkedinCredentials['redirectURL']);
				httpService.addParam(type="formfield",name='grant_type', value=prc.linkedinCredentials['grantType']);
			var results = httpService.send().getPrefix();

			if( results['status_code'] == 200 ){
				var json = deserializeJSON(results['fileContent']);

				for(var key IN json){
					session['linkedinOAuth'][key] = json[key];
				}

				setNextEvent('linkedin/oauth/activateUser')
			}else{
				announceInterception( state='linkedinLoginFailure', interceptData=results );
				announceInterception( state='loginFailure', interceptData=results );
				throw('Unknown linkedin OAuth.v2 Error','linkedin.oauth');
			}

		}else{

			location(url="#prc.linkedinSettings['authorizeRequestURL']#?client_id=#prc.linkedinCredentials['apiKey']#&redirect_uri=#urlEncodedFormat(prc.linkedinCredentials['redirectURL'])#&state=#hash(randRange(1,99))#&scope=#urlEncodedFormat(prc.linkedinCredentials['scope'])#&response_type=#prc.linkedinCredentials['responseType']#",addtoken=false);
		}
	}

	function structKeyRename(mStruct,mTarget,mKey){
		arguments.mStruct[mKey] = arguments.mStruct[mTarget];
		structDelete(arguments.mStruct,mTarget);

		return arguments.mStruct;
	}

}