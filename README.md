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

  In order to use the `include_javascripts` and `include_stylesheets` you'll need to have working implemetnations of javascript_include_tag and stylesheets_include_tag. You can easily pull these helpers into your existing Sinatra app from Padrino. See instructions [here](http://www.padrinorb.com/guides/standalone-usage-in-sinatra).

## With Padrino

    padrino-gen plugin jammit
