module Bakeware
  class AppBuilder < Rails::AppBuilder
    include Bakeware::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def raise_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def provide_setup_script
      copy_file 'script_setup', 'script/setup'
      run 'chmod a+x script/setup'
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'
      inject_into_file 'config/environments/staging.rb',
        "\n  config.action_mailer.delivery_method = :override_recipient_smtp, to: 'staging@example.com'",
        :after => 'config.action_mailer.raise_delivery_errors = false'
    end

    def initialize_on_precompile
      inject_into_file 'config/application.rb',
        "\n    config.assets.initialize_on_precompile = false",
        :after => 'config.assets.enabled = true'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      template 'bakeware_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        :force => true
    end

    def create_common_javascripts
      directory 'javascripts', 'app/assets/javascripts'
    end

    def add_jquery_ui
      inject_into_file 'app/assets/javascripts/application.js',
        "//= require jquery-ui\n", :before => '//= require_tree .'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
        :after => /source 'https:\/\/rubygems.org'/
    end

    def add_custom_gems
      additions_path = find_in_source_paths('Gemfile_additions')
      new_gems = File.open(additions_path).read
      inject_into_file 'Gemfile', "\n#{new_gems}",
        :after => /gem 'jquery-rails'/
    end
    
    def add_meaty_gems
      meaty_path = find_in_source_paths('Gemfile_extra_meat')
      meaty_gems = File.open(meaty_path).read
      inject_into_file 'Gemfile', "\n#{meaty_gems}",
        :after => /gem 'haml'/
    end
    
    def add_extra_config
      copy_file 'unicorn_config', 'config/unicorn.rb'
    end

    def configure_time_zone
      time_zone_config = <<-RUBY
    config.active_record.default_timezone = :utc
      RUBY
      inject_into_class "config/application.rb", "Application", time_zone_config
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      copy_file 'config_locales_en.yml', 'config/locales/en.yml'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def setup_guard_spork
      copy_file 'Guardfile', 'Guardfile'
    end

    def setup_foreman
      copy_file 'sample.env', 'sample.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      copy_file 'app/assets/stylesheets/application.css',
        'app/assets/stylesheets/application.css.scss'
      remove_file 'app/assets/stylesheets/application.css'
      concat_file 'import_scss_styles', 'app/assets/stylesheets/application.css.scss'
      create_file 'app/assets/stylesheets/_screen.scss'
    end

    def gitignore_files
      concat_file 'bakeware_gitignore', '.gitignore'
      [
        'app/models',
        'app/assets/images',
        'app/views/pages',
        'db/migrate',
        'log'
      ].each do |dir|
        empty_directory_with_gitkeep dir
      end
    end

    def init_git
      run 'git init'
    end

    def create_heroku_apps
      path_addition = override_path_for_tests
      run "#{path_addition} heroku create #{app_name}-production --remote=production"
      run "#{path_addition} heroku create #{app_name}-staging --remote=staging"
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def copy_libraries
      copy_file 'override_recipient_smtp.rb', 'lib/override_recipient_smtp.rb'
    end

    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
      EOS
      style_tags =<<-EOS
<link href='/assets/application.css' media='all' rel='stylesheet' type='text/css' />
      EOS
      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<style.+>.+<\/style>/mi, style_tags.strip
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do.*end/m,
        "Application.routes.draw do\nend"
    end

    def add_email_validator
      copy_file 'email_validator.rb', 'app/validators/email_validator.rb'
    end

    def setup_default_rake_task
      # append_file 'Rakefile' do
      #   "task(:default).clear\n"
      # end
    end

    private

    def override_path_for_tests
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        "PATH=#{support_bin}:$PATH"
      end
    end

    def simplecov_init
      IO.read find_in_source_paths('simplecov_init.rb')
    end
  end
end
