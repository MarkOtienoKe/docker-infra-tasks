# How to reproduce my solution

For the backend
- create a .env file to store the database credentials
- install python-dotenv to manage .env files
- Install sqlalchemy flask-sqlalchemy for mysql database connection and table schema defination
- Configure the database connection
- Define the message model
- Initialize the database
- Use the model to insert the message and retrieve the msg_id
- Use the model to get msg from DB and return it, if the message does not exist return a message not found error message and a 404 HTTP status code

For the Frontend
  - Once the backend application is running, copy its URL and update the BACKEND_URL variable in the App.js file with the copied URL.


- The Backend service URL is: https://backend-761958992403.africa-south1.run.app/

- The Frontend service Url is: https://frontend-761958992403.africa-south1.run.app/


## How to run IoC code
Initialize terraform
- terraform init

Plan the infrastructure:
- terraform plan

Apply the configuration:
- terraform apply