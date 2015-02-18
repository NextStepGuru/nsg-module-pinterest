Coldbox Module to allow Social Login via Pinterest
================

Setup & Installation
---------------------

####Add the following structure to Coldbox.cfc
	pinterest = {
		oauth = {
		}
	}

Interception Point
---------------------
If you want to capture any data from a successful login, use the interception point pinterstLoginSuccess. Inside the interceptData structure will contain all the provided data from pinterst for the specific user.

####An example interception could look like this

	component {

		function pinterstLoginSuccess(event,interceptData){
			var queryService = new query(sql="SELECT roles,email,password FROM user WHERE pinterstUserID = :id;");
				queryService.addParam(name="id",value=interceptData['user_id']);
			var lookup = queryService.execute().getResult();

			if( lookup.recordCount ){
				login {
					loginuser name=lookup.email password=lookup.password roles=lookup.roles;
				};
			}else{
				// create new user
			}

		}
	}

