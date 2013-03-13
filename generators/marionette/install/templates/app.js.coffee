@<%= js_app_name %> = do (Backbone, Marionette) ->
	
	App = new Marionette.Application	
	<% if @current_user %>
	# App.rootRoute = Routes.users_path()
	# 
	# App.on "initialize:before", (options) ->
	# 	@currentUser = App.request "set:current:user", options.currentUser
	
	# App.reqres.addHandler "get:current:user", ->
	# 	App.currentUser
	<% end %>	
	App.addRegions
		mainRegion: "#main-region"
	
	# App.addInitializer ->
	# 	App.module("HeaderApp").start()
	# 	App.module("FooterApp").start()
	
	App.on "initialize:after", (options) ->
		if Backbone.history
			Backbone.history.start()
			# @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""
	
	App