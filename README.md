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

<strong style="font-size: 20px;">Database Schema Documentation</strong>

```markdown
## Database Schema

### Table: Employees
- **id** (integer, primary key)
- **first_name** (string)
- **last_name** (string)
- **email** (string, unique)
- **role** (integer, Enum_type)
- **password_digest** (string, Encrypted)

### Table: Teams
- **id** (integer, primary key)
- **team_name** (string)
- **description** (string)
- **team_owner_id** (integer)
- **max_member** (integer)
- **manager_id** (foreign key referencing `employees` table)

### Table: EmployeeTeams
- **employee_id** (integer, foreign key referencing `employees` table, index: for querying employees quickly.)
- **team_id** (integer, foreign key referencing `teams` table, index: for quering employee teams)

### Table: Skills
- **id** (integer, primary key)
- **name** (string)

### Table: EmployeesSkills
- **id** (false)
- **employee_id** (integer, foreign key referencing `employees` table)
- **skill_id** (integer, foreign key referencing `employees` table)
`````

<strong style="font-size: 20px;">Testing Instruction</strong>

* Signup Employee based on different roles, like, **Software_Engineer_1**, **Software_Engineer_2**,
    **Team_Lead**, **Manager**, **QA**.

* Login with the Employee and try to perform the actions like : 
        - Create Team
        - Update Team
        - Destroy Team
        - See Team Member details
        - List all the Teams
        - List Available Employees for assigning into the team
        - List Available Team Leads to make team owners
        - See Team Members List
        - See Team Details
        - Check List of all employees for Connecting
        - Create Skills
        - Check List of Skills

All these actions are restricted on Role-Based . So while performing you might face some errors like -
        * Unauthorized
        * Not Found
        * Unprocessable Entity
        * Success
        * Missing Parameters
        * Field can't be blank error. and many more

To test the flow correctly we need to pass all the datas correctly.

## Testing With Rspec

- The project uses RSpec for unit and integration testing.
- To run the tests:
  ```bash
  bundle exec rspec 
  or
  rspec spec
  ```

  ## Error Handling

Common errors include:
- **401 Unauthorized**: Returned when authentication fails or token is missing.
- **404 Not Found**: When a requested resource does not exist.
- **422 Unprocessable Entity**: Validation errors on input data.
- **400 Bad Request**: When Token passed or wrong token passed.
- **200 Success**: When a process successfully gives expected response with some data.