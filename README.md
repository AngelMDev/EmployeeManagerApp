# EmployeeManagerApp

A test-driven multitenant web application DEMO for managing company employees, built with Ruby on Rails.

## Demo requirements
Here are the requirement and constraints of this application: 

System Assumptions:
1. There are multiple companies containing their own information
2. Platform is intended for use by users of the company
3. Each company has many employees, each employee will reside in one department
4. Departments do not have a nested relationship
5. Each user has one of two roles (`administrator` and `employee`)
a. These can be predefined in the database and don’t need to be managed in the app
6. Administrators have access to view and edit all their company’s employees personal information (ie. Name,
Phone, Address, etc)
7. Administrators have access to view and edit all the company’s employee’s personal compensation
information (ie. salary, bonus, etc)
8. Employee can only see their personal information and change it (ie. change address)
9. Employee can only see their compensation information
10. Companies’ data should not be accessible for other companies

Asks:
1. Create a simple multi tenant application reflecting the assumptions above
2. Create roles reflecting the assumptions above
3. Create a “employee” profile page allowing employees to view and update their own information
4. Create an company page showcasing company level information
a. Page should only be accessible by administrators
b. Administrators should be able to update their company’s employees information
i. Feel free to keep this as simple as possible
c. Admins should be able to view a summary report of up to top three earners by department (sorted
by first department then by salary)

5. Code should be tested

## Installation

Clone the project and run ```bundle install```, ```rake db:create```, ```rake db:migrate```.
Use ``` rake db:seed ``` to populate the database with 3 fake companies, along with 3 departments per company and 4 employees by department 
plus an administrator for each company. You can change these numbers in the seeds file. The app uses the [Faker gem](https://github.com/stympy/faker) to generate fake data.

run ```rails server``` to start the application setup by default to localhost:3000

To run tests use the ```rspec``` command in the project's root directory.

## Usage

 Upon navigating to the homepage you'll need to 'sign in' using the drop down list, if you wish to login as an administrator look for employees with an (Administrator) tag, otherwise choose another employee.
 Pressing sign in will then redirect you to the company page if you're an administrator, or your personal page if you're a regular employee.
 Once logged in you will only see users from the same company in the dropdown, to view all employees from other companies you need to logout.
 
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
One of the elements to achieve this is the dummy SessionsControllers, which is meant to simulate user authentication without the hassle of a real authentication system such as Devise. It merely uses a browser cookie to store session information and the available users for all companies are available in a dropdown list. In this app there are only two roles: 'admin' or 'employee', as such, a boolean flag was added to the employees table to indicate this. To restrict users from accessing areas of the application that they aren't supposed to access, several "before_action" filters were added were appropriate, these determine whether to let the user pass through or redirect them to an area they can access. One such filter is the ```verify_access``` method in the employees controller, which, for the controller actions that is applied, determines if the user is the same as the employee they are trying to access OR if the user is an administrator for the company THEN allow access. There is also ```authenticate_user``` and ```authenticate_admin``` which work as expected similarly to how Devise implements them, just a lot simpler.

Another important requirement was the addition of the top earners table, which show the top three employees per department that earn the most in the company, sorted first by department name and then by salary. In order to implement this, we use the following query:
```  
      SELECT id, name, salary, department_id, department_name, company_id
      FROM (
        SELECT employees.id id, name, department_id, department_name, salary, company_id, RANK() 
          OVER (PARTITION BY department_id 
                ORDER BY department_name, salary DESC) 
          AS rank 
        FROM employees 
        INNER JOIN departments ON employees.department_id = departments.id 
        INNER JOIN companies ON companies.id = departments.company_id 
        WHERE company_id = #{id}) 
      WHERE rank <= 3
  ```
  
Using a window query and the rank() function we are able to select and order the employees of the company by department name and salary, we then select only the top three results per partition. OVER and PARTITION BY allow us to divide a given result set into groups (in this case, by department) AND to perform operations on each group, in this case we are ordering the results within each subset and ranking them using the Rank() SQL function which will assign a rank to each of the subsets based on the result of the order, which then allow us to filter so that we can select those with a rank of less than 3, effectively giving us the top three.
  
  ## The future
  
  There are still things I'd like to add to make this a better application:
  1. The ability to add or modify company information.
  2. The ability to add, remove, employees and departments of a company.
  3. A more robust permission system that allows for different roles.
  4. More validations to check for 'numericality', phone and email format, etc.
  
