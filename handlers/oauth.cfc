component {

	function preHandler(event,rc,prc){
		prc.pinterestCredentials = getSetting('pinterest')['oauth'];
		prc.pinterestSettings = getModuleSettings('nsg-module-pinterest')['oauth'];
		if(!structKeyExists(session,'pinterestOAuth')){
			session['pinterestOAuth'] = structNew();
		}
	}

	function index(event,rc,prc){

		if( event.getValue('id','') == 'activateUser' ){
			var results = duplicate(session['pinterestOAuth']);

			var httpService = new http();
				httpService.setURL('https://www.pinterestapis.com/oauth2/v1/userinfo');
				httpService.addParam(type="url", name='access_token', value=session['pinterestOAuth']['access_token']);
			var data = deserializeJSON(httpService.send().getPrefix()['fileContent']);
			structAppend(results,data);

			announceInterception( state='pinterestLoginSuccess', interceptData=results );
			setNextEvent(view=prc.pinterestCredentials['loginSuccess'],ssl=( cgi.server_port == 443 ? true : false ));

		}else if( event.valueExists('code') ){
			session['pinterestOAuth']['code'] = event.getValue('code');

			var httpService = new http();
				httpService.setMethod('post');
				httpService.setURL(prc.pinterestSettings['tokenRequestURL']);
				httpService.addParam(type="formfield",name='code', value=session['pinterestOAuth']['code']);
				httpService.addParam(type="formfield",name='client_id', value=prc.pinterestCredentials['clientID']);
				httpService.addParam(type="formfield",name='client_secret', value=prc.pinterestCredentials['clientSecret']);
				httpService.addParam(type="formfield",name='redirect_uri', value=prc.pinterestCredentials['redirectURL']);
				httpService.addParam(type="formfield",name='grant_type', value='authorization_code');
			var results = httpService.send().getPrefix();

			if( results['status_code'] == 200 ){
				var json = deserializeJSON(results['fileContent']);

				for(var key IN json){
					session['pinterestOAuth'][key] = json[key];
				}

				setNextEvent('pinterest/oauth/activateUser')
			}else{
				announceInterception( state='pinterestLoginFailure', interceptData=results );
				throw('Unknown pinterest OAuth.v2 Error','pinterest.oauth');
			}

		}else{
			var httpService = new http();
				httpService.setMethod('post');
				httpService.setURL(prc.pinterestSettings['tokenRequestURL']);
				httpService.addParam(type="formfield",name='consumer_id', value=prc.pinterestCredentials['appID']);
				httpService.addParam(type="formfield",name='response_type', value='token');
			var results = httpService.send().getPrefix();
writedump(results);abort;

			location(url="#prc.pinterestSettings['authorizeRequestURL']#?client_id=#prc.pinterestCredentials['clientID']#&redirect_uri=#urlEncodedFormat(prc.pinterestCredentials['redirectURL'])#&scope=#prc.pinterestCredentials['scope']#&response_type=#prc.pinterestCredentials['responseType']#&approval_prompt=#prc.pinterestCredentials['approvalPrompt']#&access_type=#prc.pinterestCredentials['accessType']#",addtoken=false);
		}
	}
}