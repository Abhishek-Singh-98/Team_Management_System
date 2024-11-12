# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

<strong>Team Management System</strong>

This is an Only API application for managing multiple teams in an Organization.

<strong style="font-size: 20px;">Setup Instructions</strong>

* **Create a New Project:** 
    ```bash
    rails new project_name -d postgresql
    ```

* **Add the following gems in the Gemfile:**
    ```ruby
    gem 'dotenv'
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'faker'
    gem 'active_model_serializers'
    gem 'jwt'
    gem 'kaminari'
    gem 'simplecov', require: false
    ```

* **Install the gems:**
    ```bash
    bundle install
    ```

* **FactoryBot Setup:** 
    Configure `application.rb` to initialize FactoryBot in a custom directory.
    ```ruby
    config.generators do |g|
        g.factory_bot dir: 'spec/factories'
    end
    config.factory_bot.definition_file_paths = ["spec/factories"]
    ```

* **SimpleCov Setup in `rails_helper.rb`:**
    ```ruby
    SimpleCov.start 'rails' do
        add_filter '/app/channels'
        # Additional filters can be added here
    end
    ```

* **JWT Token-Based Authentication:**
    - The `jwt` gem is used for token-based authentication.
    - A module concern was created to handle common encode/decode methods, making them reusable throughout the project.

* **Test Coverage:**
    - Used `rspec-rails` gem and `Simple-Cov` gem to Write Test cases for the APIs, Validations, Corner Cases.
    - And Simple Cov will generate a index.html file where we can check the coverage of our code.

