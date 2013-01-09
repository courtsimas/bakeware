# Bakeware [![Build Status](https://secure.travis-ci.org/courtsimas/bakeware.png?branch=master)](http://travis-ci.org/courtsimas/bakeware)

Bakeware is the base Rails application (usually) used at [ovenbits](http://ovenbits.com).

Installation
------------

First install the bakeware gem:

    gem install bakeware

Then run:

    bakeware projectname

This will create a Rails 3.2 app in `projectname`. This script creates a
new git repository. It can also optionally create 2 new heroku apps.
It is not meant to be used against an existing repo. 
Bakeware comes in two modes: lean, and meaty.


Lean Mode
---------

This is the default mode. Comes with

* [Airbrake](/airbrake/airbrake) for exception notification
* [haml](/haml/haml) for haml - because we should all use it
* [newrelic_rpm](/newrelic/rpm) for analytics about the performance of your app
* [pg](/ged/ruby-pg) for PostgreSQL 

Meaty Mode
---------

You can optionally opt for Meaty mode:

    bakeware projectname --meaty true

This comes with:    

* [Airbrake](/airbrake/airbrake) for exception notification
* [asset_sync](/rumblelabs/asset_sync) syncing assets between rails and s3
* [aws-sdk](/aws/aws-sdk-ruby) for the amazon sdk
* [challah](/ovenbits/challah) for simple and effective authentication
* [challah-facebook](/jdtornow/challah-facebook) extends Challah for FB authentication
* [Compass](/chriseppstein/compass) for Sass mixins and standardization
* [haml](/haml/haml) for haml - because we all should use it
* [hirefireapp](/meskyanichi/hirefireapp) for auto scaling dynos on heroku
* [newrelic_rpm](/newrelic/rpm) for analytics about the performance of your app
* [Paperclip](/thoughtbot/paperclip) for file uploads
* [pg](/ged/ruby-pg) for PostgreSQL
* [rack-timeout](/kch/rack-timeout) for killing your app's hung processes before heroku times out (set to 29 seconds)
* [redis](/antirez/redis) for redis
* [resque](/defunkt/resque) for resque background processing
* [Unicorn](/defunkt/unicorn) for a better http server


Testing
----------

Bakeware also comes with testing gems, including (but not limited to):

* [Factory Girl](/thoughtbot/factory_girl) for test data
* [simplecov](/colszowka/simplecov) for testing coverage analytics
* [Timecop](/jtrupiano/timecop) for testing time

We don't use RSpec often, and even less often do we use minitest. So manually include those if you want.


Other goodies
-------------

Bakeware also comes with:

* Override recipient emails in staging environment.
* Rails' flashes set up and in application layout.
* [Heroku-recommended asset pipeline
  settings](https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar/).

Heroku
------

You can optionally create Heroku staging and production apps:

    bakeware projectname --heroku true

This has the same effect as running:

    heroku create projectname-staging --remote staging
    heroku create projectname-production --remote production

Github
------

You can optionally create a Github repository:

    bakeware projectname --github organization/project

This has the same effect as running:

    hub create organization/project


Test::Unit
----------

You can optionally skip Test::Unit files:

    bakeware projectname --skip_test_unit true

Dependencies
------------

Some gems included in Bakeware have native extensions. You should have GCC installed on your
machine before generating an app with Bakeware.

Use [OS X GCC Installer](/kennethreitz/osx-gcc-installer/) for Snow Leopard
(OS X 10.6).

Use [Command Line Tools for XCode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Issues
------

If you have problems, please create a [Github Issue](/courtsimas/bakeware/issues).

Contributing
------------

Please see CONTRIBUTING.md for details.

Credits
-------

![Oven Bits](http://ovenbits.com/images/logo-color.png)

Bakeware is maintained and funded by [Oven Bits](http://ovenbits.com)

The names and logos for Oven Bits are trademarks of Oven Bits

License
-------

Bakeware is Copyright © 2013 Oven Bits. It is free software, and may be
redistributed under the terms specified in the LICENSE file.