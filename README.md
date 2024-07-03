
<img src="https://github.com/user-attachments/assets/26448eb1-a990-4aab-b9a2-edb64b3ded8e" width="400" height="400" />

### Description

Exlibris is set to revolutionize library management with a cutting-edge online automation system designed to streamline the administration and access of library resources. This innovative web-based platform will provide a seamless and intuitive experience for both library staff and users, combining advanced technology with user-centric design to enhance operational efficiency and resource accessibility.

### Features

- **Catalog Management:**
- *Resource Handling:* Efficiently manage a broad spectrum of library materials including physical books, digital journals, articles, multimedia files, and more.
- *Record Operations:* Effortlessly add, edit, and delete catalog records, enriching each entry with comprehensive metadata, tags, and classifications to enhance searchability and organization.
- *-Status and Location Tracking:* Track the real-time status and location of each resource, whether it is available, checked out, or in transit, to improve inventory management and user satisfaction.


- **Admin Management:**
- User Account Administration: Create, modify, and manage user accounts for library patrons, staff, and administrators, with customizable roles and access levels to ensure appropriate permissions.
- Activity Monitoring: Monitor and review user and staff activities to ensure adherence to library policies and operational standards.
- Access Control: Implement detailed access controls to regulate system usage and protect sensitive data, enhancing overall security and efficiency.

- **Enhanced Circulation Management:**
- Lending and Returning: Simplify the process of borrowing and returning resources, with features for handling renewals, extensions, and the management of overdue items.
- Overdue Tracking: Automatically track overdue items, generate timely notifications for users, and manage late fees to encourage prompt returns.
- Reservation System: Facilitate item reservations, allowing users to place holds, view reservation status, and manage their reservation queue with ease.
- Rating and Reviews: Enable users to rate and review resources, fostering community engagement and providing valuable feedback for other patrons.

- **Detailed Reporting and Analytics:**
- Custom Reports: Generate comprehensive reports covering various aspects of library operations, including circulation statistics, inventory status, and user engagement.
- Data Visualization: Utilize interactive charts, graphs, and dashboards to visualize key performance indicators and trends, supporting informed decision-making.
- Operational Insights: Analyze usage patterns, engagement metrics, and other critical data to optimize library services, improve resource allocation, and enhance overall effectiveness.

- **Robust Security and Access Control:**
- User Authentication: Implement secure authentication mechanisms, including options for single sign-on (SSO) and multi-factor authentication (MFA), to protect user accounts and system access.
- Permission Management: Define and manage access levels and permissions to control user interactions with the system and safeguard sensitive information.
- Data Protection: Employ advanced encryption and security measures to protect library data and ensure compliance with privacy regulations.


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

![deer](https://github.com/user-attachments/assets/39f06a98-9a20-4202-b32b-a6cddb1935ac)

<img src="https://github.com/user-attachments/assets/d276911b-be1b-4528-ac9b-3c50ca41bf7b" width="400" height="400" />
by @fevzikilas and @muratcanbastug 2023
