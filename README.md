Intranet Assets
===============
City of Malmö’s intranet assets are served from a central asset host and are consumed by web applications on the organizations intranet. The assets contains a common base for the UI such as a masthead, footer, form styling, page layouts, styling for articles, widgets, and components. The assets assume that the application that uses them has a responsive design.

Purpose of the intranet assets:

* It gives all web applications a consistent UI for the user.
* Common changes are deployed in one place and the changes are reflected immediately in all web applications.
* It decreases the load time for the end user since the majority of stylesheet and Javascript code will be cached in the browser instead of being fetch from each application.
* It speeds up development.

Apart from the common assets consumed by all applications, each application contains it’s own unique assets for additional features not included in the common assets. The application specific assets are served by the applications themselves.

You might want to read the [How to Use the Assets](https://github.com/malmostad/intranet-assets/wiki/How-to-Use-The-Assets) in an application to be built or adapted for The City of Malmö and [Development Guidelines](https://github.com/malmostad/intranet-assets/wiki/Development-Guidelines) for the assets in the wiki.

For more information, contact kominteamet@malmo.se.

## Dependencies for Development and Deployment
* Ruby 2.0
* Rubygems and Bundler

## Dependencies for Asset Hosting
A web server optimized to serve static files. Ruby is not needed on the server.

## Development Setup
The assets are developed using Sprockets and the Asset Pipeline in a stripped down Ruby on Rails-application. The application is only used for development, testing, build and deployment. You can use the application as a local asset host when you are developing or adapting other applications to the global assets.

To install the required Ruby gems, run:

```
$ bundle install
```

Start the local asset server:

```
$ rails s -p 3001
```

You might need to map a domain name to your local host like `www.local.malmo.se` to debug and test some of the Javascript code.

Use the local views in the asset application for the visual part of the development. You can also point another locally installed web application your started asset server.

## Build and Deployment
Capistrano is used for build and deployment to the server. Sass and Javascript files are concatenated and minified. Run the deployment script by including the environment name in the command:

To change the Capistrano deployment configuration:

1. Copy `config/deploy.yml.example` to `config/deploy.yml` and change the settings.
2. Edit `config/deploy.rb` and the environment files in the `config/deploy/` directory if necessary.

```
$ cap staging deploy
$ cap production deploy
```

The compression levels for CSS and Javascript files are configured in `config/environments/` for development, staging and production.

## License
Released under AGPL version 3.

The `vendor` directory contains third party code that may be released under other licenses stated in the start of each file.

