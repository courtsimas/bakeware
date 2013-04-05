require 'aruba/cucumber'

When 'I run rake' do
  in_current_dir do
    run_simple 'bundle exec rake'
  end
end

When 'I run the rake task "$task_name"' do |task_name|
  in_current_dir do
    run_simple "bundle exec rake #{task_name}"
  end
end

When 'I generate "$generator_with_args"' do |generator_with_args|
  in_current_dir do
    run_simple "bundle exec rails generate #{generator_with_args}"
  end
end

When 'I ensure no databases exist for the "$project_name"' do |project_name|
  run_simple "dropdb #{project_name}_development"
  run_simple "dropdb #{project_name}_test"
end

When 'I bake a project called "$project_name"' do |project_name|
  bakeware_bin = File.expand_path(File.join('..', '..', 'bin', 'bakeware'), File.dirname(__FILE__))
  run_simple "#{bakeware_bin} #{project_name}"
end

When /^I bake a project called "([^"]*)" with:$/ do |project_name, arguments_table|
  bakeware_bin = File.expand_path(File.join('..', '..', 'bin', 'bakeware'), File.dirname(__FILE__))
  arguments = arguments_table.hashes.inject([]) do |accum, argument|
    accum << "#{argument['argument']}=#{argument['value']}"
  end.join
  run_simple "#{bakeware_bin} #{project_name} #{arguments}"
end

When 'I cd to the "$test_project" root' do |dirname|
  cd dirname
end

Then 'I can cleanly rake the project' do
  steps %{
    And I run the rake task "db:create"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "cucumber"
  }
end

Then /^the "([^"]*)" Heroku app should exist$/ do |app_name|
  FakeHeroku.should have_created_app(app_name)
end

Then /^the "([^"]*)" Github repo should exist$/ do |repo_name|
  FakeGithub.should have_created_repo(repo_name)
end

Then 'unicorn should be installed' do
  in_current_dir do
    system("bundle show unicorn 2>&1 > /dev/null").should be_true
  end
end
