# exLibris.md

![exlibris logo](https://user-images.githubusercontent.com/51405534/236638080-7ce8bd2e-d2e6-4f2b-8b83-817481d6dad3.jpg)


### Description
Exlibris aims to develop an online library automation system that enables users to efficiently manage and access their library resources. The system will be web-based and will provide a comprehensive and efficient experience for both library staff and users.

### Features

- **Catalog Management:** The system will allow library staff to manage their library
resources, including books, journals, articles, and other material. Catalog management
will include adding, editing, and deleting records, as well as updating the status and
location of library resources.

- **Admin Management:** The system will enable library administrators to manage user accounts, including account creation, deletion, and access levels. Administrators can also monitor and track the activity of staff and administrators.

- **Circulation Management:** The system will facilitate the lending and borrowing of library resources, including issuing and returning books, tracking overdue books, rating books and managing book reservations.

- **Reporting and Analytics:** The system will provide detailed reports and analytics to library

- **Security and Access Control:** The system will ensure the security of the library's
resources by implementing access controls, including user authentication, permission,
and access restrictions.

### ER DIAGRAM
![ER diagram V5](https://github.com/muratcanbastug/exLibris/assets/51405534/f7ea8f22-ff94-4445-a3b1-715f7899b730)

### USAGE

To set up the tables and relationships in the ER diagram, you can execute the `create.sql` file located in the `.sql` folder within your database. This file contains SQL statements to create the necessary tables and define their relationships.

In addition, the `view.sql` file allows you to create views that can be used in the backend. These views provide a way to present data from multiple tables or apply filters to the data.

To populate your tables with sample data for testing purposes, you can use the `insert.sql` file. This file contains SQL statements to insert random data into your tables.

Please ensure that you fill in the .env file with your specific database information. The `.env` file typically contains configuration variables such as the database host, port, username, password, and database name. Make sure to provide accurate and up-to-date details to establish a successful connection to your database.

```
PGUSER = {postgresql_user_name}
PGHOST = {host_address}
PGDATABASE = {database_name}
PGPASSWORD = {database_password}
PGPORT = {database_port}

PORT = {server_port}

ACCES_TOKEN_SECRET = {authentication_access_token}
REFRESH_TOKEN_SECRET = {authentication_refresh_token}

AUTH_EMAIL = {authentication_email}
AUTH_CLIENT_ID = {authentication_client_id}
AUTH_CLIENT_SECRET = {authentication_client_secret}
AUTH_REFRESH_TOKEN = {authentication_refresh_token}
```

For testing the APIs in the backend, you can utilize the `exLibris.postman_collection.json` file. This file provides a collection of requests in the Postman format, which you can import into the **Postman** program. Using this collection, you can perform tests and interact with the APIs effectively.

