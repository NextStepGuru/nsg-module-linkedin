Coldbox Module to allow Social Login via LinkedIn
================

Setup & Installation
---------------------

####Add the following structure to Coldbox.cfc
	linkedIn = {
		oauth = {
		}
	}

Interception Point
---------------------
If you want to capture any data from a successful login, use the interception point linkedInLoginSuccess. Inside the interceptData structure will contain all the provided data from linkedIn for the specific user.

####An example interception could look like this

	component {

		function linkedInLoginSuccess(event,interceptData){
			var queryService = new query(sql="SELECT roles,email,password FROM user WHERE linkedinUserID = :id;");
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

