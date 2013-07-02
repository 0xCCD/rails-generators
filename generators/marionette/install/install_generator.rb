require 'generators/marionette/resource_helpers'

module Marionette
	module Generators
		class InstallGenerator < Rails::Generators::Base
			include Marionette::Generators::ResourceHelpers

			source_root File.expand_path("../templates", __FILE__)
			
			# desc "This generator installs backbone.js with a default folder layout in app/assets/javascripts/backbone"

			# class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
			#													:desc => "Skip Git ignores and keeps"

			# def inject_backbone
			#		inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree" do
			#			"//= require underscore\n//= require backbone\n//= require backbone_rails_sync\n//= require backbone_datalink\n//= require backbone/#{application_name.underscore}\n"
			#		end
			# end
			#
			
			def name_your_javascript_app
				if no? "The default marionette application name is: #{suggested_app_name} -- Is this ok? (y/n)"
					@app_name = ask("What would you like to name your Marionette Application?").camelize
				end
				
				create_file "config/initializers/marionette.rb" do					
					"#{rails_application_name}::Application.config.marionette_app_name = '#{suggested_app_name}'"
				end
			end
		
			## gets each of the external libs and places them in the lib directory
			def get_vendor_dependencies
				external_libs.each do |name, lib|
					get lib, "vendor/assets/javascripts/#{name}.js"
				end
			end			
			
			## appends each of the lib dependencies in applications.js in the correct order
			def append_vendor_dependencies
				%w{underscore backbone marionette}.each do |lib|
					append_to_file "#{javascript_path}/application.js" do
						"\n//= require vendor/#{lib}"
					end
				end
				append_to_file "#{javascript_path}/application.js" do
					"\n//= require_tree ./vendor"
				end
			end
			
			def create_dir_layout
				%w{apps config entities views components controllers}.each do |dir|
					empty_directory "#{javascript_path}/backbone/#{dir}"
				end
			end
			
			def append_app_files 
				append_to_file "#{javascript_path}/application.js" do
					"\n//= require_tree ./backbone/config\n" +
					"//= require backbone/app\n" +
					"//= require_tree ./backbone/controllers\n" +
					"//= require_tree ./backbone/entities\n" +
					"//= require_tree ./backbone/views\n" +
					"//= require_tree ./backbone/components\n" +
					"//= require_tree ./backbone/apps\n"
				end
			end
			
			def create_app_file
				@current_user = yes? "Do you need to work with an authenticated current user (y/n)"
				template "app.js.coffee", "#{javascript_path}/backbone/app.js.coffee"
			end
			
			## TODO: SHOULD ASK ABOUT STARTING UP ANY SPECIFIC MODULES 
			
			## TODO: SHOULD ASK ABOUT DEFAULT ROUTE
			
			## TODO: SHOULD ASK ABOUT WHICH REGIONS THE USER WANTS ADDED ON TOP OF MAINREGION
			
			def start_marionette_app
				destination = "app/views/application/index.html.erb"
				create_file destination unless File.exist? destination
				append_to_file destination do
					embed_template "index.html.erb"
				end
			end
			
			## TODO: SHOULD ALSO WORK ON APPLICATION.HTML.ERB AND APPEND BEFORE THE END TO START THE DEMO APP + HANDLE CURRENT USER
			
			private
			
			def suggested_app_name
				@app_name || rails_application_name
			end

		end
	end
end