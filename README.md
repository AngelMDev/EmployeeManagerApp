# EmployeeManagerApp

A test-driven multitenant web application for managing employees of a company, built with Ruby on Rails.

## Usage

Clone the project and run ```bundle install```, ```rake db:create```, ```rake db:migrate```.
Use ``` rake db:seed ``` to populate the database with 3 fake companies, along with 3 departments per company and 4 employees by department 
plus an admnistrator for each company. You can change these numbers in the seeds file. The app uses the [Faker gem](https://github.com/stympy/faker) to generate fake data.

run ```rails server``` to start the application setup by default to localhost:3000

To run tests use ```rspec```.

 Upon navigating to the homepage you'll need to 'sign in' using the drop down list, if you wish to login as an administrator look for employees with an (Administrator) tag, otherwise choose another employee.
 Pressing sign in will then redirect you to the company page if you're an administrator, or your personal page if you're a regular employee.
 
As an administrator you can access features such as a list of all employees for the company, view the top 3 earners of each department, and edit each employee information, including compensation (salary, bonus, benefits, etc.)

As a regular employee you only have access to your own information and to edit some information like the address, phone, etc.

## Development

### DB Schema



|       Companies       | *|     Departments     | *|       Employees        |
|-----------------------|--|---------------------|--|------------------------|
| has_many :departments | *| belongs_to :company | *| belongs_to: department |
|-----------------------| *| has_many: employees | *| --------               |
| id                    | *|---------------------| *|id                      |
| name                  | *| id                  | *| name                   |
|                       | *| name                | *| admin?                 |
|                       | *| company_id          | *| salary                 |
|                       | *|                     | *| bonus                  |
|                       | *|                     | *| department_id          |

### Tools

This application was (mostly) developed using a test-driven methodology to ensure that requirements were met and to ease the development as the application grew. I used [Rspec](http://rspec.info/) for controller and model tests and [Capybara](https://github.com/teamcapybara/capybara) for feature tests. The application uses the [RackTest](https://github.com/teamcapybara/capybara#racktest) driver so no additional browser driver configuration is needed. 

The [Bootstrap](https://getbootstrap.com/) library was used to give styling to the UI, no custom CSS was implemented.

Sqlite3 is the default DB engine for the application.

### In-depth

There are three important requirements for this app:
1. Regular employees cannot access administrator views
2. Users cannot view other companies' data
3. Depending on the privileges of the user, they can edit their or others' information

It is evident that a basic permission system, and testing what users can and cannot see is necessary to fulfill these requirements.
One of the elements to achieve this is the dummy SessionsControllers, which is meant to simulate user authentication without the hassle of a real authentication system such as Devise. It merely uses a browser cookie to store session information and the available users for all companies are available in a dropdown list. In this app there are only two roles: 'admin' or 'employee', as such, a boolean flag was added to the employees table to indicate this. To restrict users from accessing areas of the application that they aren't supposed to access, several "before_action" filters were added were appropriate, these determine whether to let the user pass through or redirect them to an area they can access. One such filter is the ```verify_access``` method in the employees controller, which, for the controller actions that is applied, determines if the user is the same as the employee they are trying to access OR if the user is an administrator for the company THEN allow access. There is also ```authenticate_user``` and ```authenticate_admin``` which work as expected simiarly to how Devise implements them, just a lot simpler.

Another important requirement was the addition of the top earners table, which show three employees per department that earn the most, sorted first by department name and then by salary. To implement this a scope in the employee model was added: 
```  
scope :top_earners_for_company, ->(company) {
    company.employees
           .select(:id, :name, :department_id, :department_name, :salary)
           .order('department_name', salary: :desc)
  }
  ```
  
  This will: Get employees for the specified company, select the needed columns and then order them first by department name and then by descending salary, and return an ActiveRecord relation with the data we need.
  We then process this data with the ```top_earners_by_department``` class method, which limits the number of employees per department to 3.
  
  There's a different approach to solve this problem: Querying the database by each company department, limiting the results to 3 and then mergin all the results. However the approach I used was favored instead, because it is more performant to make a single query than several small queries, specially if the company has many departments. 
  
  ## The future
  
  There are still things I'd like to add to make this a better application:
  1. The ability to add or modify company information.
  2. The ability to add, remove, employees and departments of a company.
  3. A more robust permission system that allows for different roles.
  4. More validations to check for 'numericality', phone and email format, etc.
  
