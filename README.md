Intranet Assets
===============
City of Malmö’s _Intranet Assets_ are served from a central asset host and are consumed by web applications on the organizations intranet. The asset contains a common base of UI elements such as a masthead, footer, form styling, page layouts, widgets, boxes, context menus, an autocomplete component and styling of article body copy etc.

Purpose of the common assets:

* It gives all web applications a conistent UI for the user.
* It speeds up the development.
* Common changes are deployed in one place and the changes are reflected imediately in all web applications.

Apart from the global assets consumed by all applications, each one might contain it’s own unique assets for additional features not included in the global assets.

Documentation of the [usage of the assets](wiki/Usage-of-The-Assets) in an application to be built or adapted for The City of Malmö and [development guidelines](wiki/development) are found on a separate wiki pages.

For more information, contact kominteamet@malmo.se.

## Dependencies for Development and Deployment
* Ruby >= 1.9.3
* Rubygems and Bundler

## Dependencies for Asset Hosting
A web server optimized to serve static files is recommend. Ruby is not needed on the server.

## Development
The assets are developed in a stripped down Ruby on Rails-application using Sprockets and the asset pipeline. The application is only used for development, testing, build and deployment. Only static files are deployed to the server. You can use the application as a local asset host when you are developing or adapting other applications to the common assets.

### Local installation
To be able to perform development of the assets, you need to set up your local environment. The asset framework is installed as a Ruby on Rails application. The stripped down Rails application has no database and no migrations. To install the required Ruby gems, run:

```
$ bundle install
```

Start the local asset server:
```
$ rails s -p 3001
```

Use the local views in the asset application that can be accessed at `http://your.local.machine:3001/` for the visual part of the development. You can also point another locally installed web application to the started asset server.

## Build and Deployment
Capistrano is used for build and deployment. Sass and Javascript files are concatenated and minified. Run the deployment script by including the environment name in the command:

```
$ cap staging deploy
$ cap production deploy
```

The compression levels for CSS and Javascript files are configured in `config/environments/` for development, staging and production.

Adapt the Capistrano deployment configuration. Copy `config/deploy.yml.example` and change the settings. Edit `config/deploy.rb` and the environment files in the `config/deploy/` directory if necessary.

### Third Party Code
Third party code resides in `vendor/assets`. The code is included in the global stylesheet and Javascript file in the development environment as well as in the build process.

## Licence
Licensed under GPL v3.0. The directory `vendor` contains third party code that may be released under other licenses stated in the top of each file.
