user                = require '../controllers/userController'
{isLoggedIn}        = require '../config/middleWare'
{alreadyLoggedOut}  = require '../config/middleWare'

# all routes for users
module.exports = (app, passport) ->

  app.get '/', user.index

  ###
    AUTHENTICATION
  ###
  app.post '/signup', passport.authenticate('local-signup'), (req, res) ->
    res.json 201, req.user

  app.post '/login', passport.authenticate('local-login'), (req, res) ->
    res.json req.user

  app.get '/logout', alreadyLoggedOut, user.logout

  app.get '/loggedin', user.loggedIn

  app.delete '/user/delete', isLoggedIn, user.deleteUser

  # this route is expecting an email
  app.post '/user/forgot/password', user.forgotPassword

  # this is the route the is sent in the email, use clicks this
  app.get '/user/reset/:token', user.resetPassword

  # this is the route the the new passowrd will post to
  app.post '/user/reset/:token', user.updatePassword

  app.get '/connect/fitbit', isLoggedIn, passport.authorize 'fitbit'

  app.get '/connect/fitbit/callback', isLoggedIn,
  passport.authorize('fitbit', failureRedirect: '/login'), (req, res) ->
    res.redirect '#/main/stream'

  ###
   FITNESS DATA
  ###
  app.get '/api/user/:from?/:to?', isLoggedIn, user.userActivity

  ###
    GROUPS
  ###

  app.get '/user/groups/:email', user.groups


  ###
    COMPETITION
  ###
  app.post '/user/compete/new', user.newChallenge
  app.get '/competition/verify/:comp/:decision', user.verifyChallenge
  app.get '/user/competitions/:id', user.getChallenges



