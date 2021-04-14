## A web server built using [Shelf](https://pub.dev/packages/shelf).

This is an example app how a webserver can be built using dart.
Here I have used the following packages:

- shelf - base for the webserver
- shelf_router - makes creating routes easy.
- shelf_static - for serving static files. Here all the js files.
- mustache - for web templating
### You can access the demo  [here](http://13.233.224.200:8080/).
***It is currently running inside a docekr container hosted on a t2.micro instance at AWS**
## Routes

### /

It renders the landing page.

#### /authenticated

It renders conent only if the user is logged in (cookie is sent via resquest). Other wise it sends a 403 response.

### /api

#### /api/messages GET

It return a json response "Greetings {name}"
The name is of the logged in user.

#### /api/login POST

Does a psuedo login of the user. It basically sets a cookie with key name nad value the name sent via the body.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
