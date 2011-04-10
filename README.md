# Jammit Sinatra

## Introduction

Jammit-Sinatra is a jammit wrapper that allows Jammit to work properly in Sinatra/Padrino web apps.

It includes middleware and fixed up view helpers (`include_javascripts` and `include_stylesheets`).

## Installation

To install jammit-sinatra, just use:

    gem install jammit-sinatra

If you are using bundler, add it to your project's `Gemfile`:

    gem 'jammit-sinatra'


## With Sinatra

  In your app code, you'll need to register Jammit:

      register Jammit


  You'll also need to load the jammit configuration file. So in your configure block, run:

    ::RAILS_ENV = "development" # this is needed to work around a Jammit limitation
    Jammit.load_configuration("/path/to/config/assets.yml")


## With Padrino

jammit-sinatra includes a hook that automatically loads `#{Padrino.root}/config/assets.yml`. In your app, you'll just need to add

    register Jammit
