# README

![Pinscher](images/pinscher.png)

# Video
Here's a video with the [application working](https://youtu.be/cZqwpbxnQCo)

# Tooling

## Versions
- **Ruby**: 3.2.2
- **Rails**: 7.1.2

## Frontend
- **Hotwire**: Includes gems `turbo-rails` and `stimulus-rails`, used to add Turbo and Stimulus functionality, respectively.
- **Bulma**: CSS framework used for web design.

## Database and Storage
- **pg**: Connector and adapter for PostgreSQL database.
- **redis**: Used for working with Redis data storage.

## Application Features
- **Money-rails**: Integrates the `money` gem into Rails, making it easier to work with monetary values.
- **Pagy**: Lightweight and efficient pagination gem.
- **Prawn**: Provides features for generating PDFs.
- **u-case**: Simplifies the creation and use of use cases.

## Testing
- **FactoryBotRails**: Used to easily create test objects with fake data.
- **Faker**: Generates random data for testing.
- **Rspec-rails**: Testing framework for Rails.
- **Capybara**: Used for integration tests, simulating how users interact with the application.
- **Shoulda-matchers**: Provides simplifications for testing Rails functionality.
- **Simplecov**: Generates test coverage reports.

## Development
- **BetterErrors**: Enhances the Rails error page for more efficient debugging.
- **Brakeman**: Static security analyzer for Rails applications.
- **Rubocop**: Code style analyzer and linter.

# Features Implemented

- [x] Generate Access Token
  - Generate a token that can be used for authentication.

- [x] Login via Token
  - Authenticate using the generated token for secure access.

- [x] List Invoices (Filters: Invoice Number, Date)
  - View a list of invoices with filtering options by invoice number and date.

- [x] View Invoice
  - Display detailed information about a specific invoice.

- [x] Create and Send Invoice
  - Create new invoices and send them via email. Email includes: Email Body, Link for Visualization, Attachment, PDF Version of the Invoice

- [x] Logout
  - Log out from the system to end your session.

- [x] API
  - API endpoints to be used.

# Testing

The Invoice Management System has been thoroughly tested to ensure functionality and reliability. Below is a summary of the testing efforts:

- [x] **Use Cases**
  - Comprehensive testing of all use cases to validate core functionality.

- [x] **Integration Tests (WEB)**
  - Integration testing of web-based interactions and features.

- [x] **Integration Tests (API)**
  - Integration testing of API functionality to ensure proper communication.

- [x] **Mailers**
  - Testing of email functionality, including email content, links, and attachments.

**Test Coverage**: The testing process has achieved a branch coverage of 86.71%.

## Getting Started

To get started, ensure that you have the following prerequisites installed on your system:

- Ruby (version 3.2.2)
- Rails (version 7.1.2)
- PostgreSQL (for the database)
- Redis (for background jobs)
- Chrome or Headless Chrome (for integration tests)

### Setup

1. Clone the repository to your local machine.

```bash
  git clone https://github.com/diegolinhares/pinscher_invoices
```

2. Navigate to the project directory.

```bash
  cd pinscher_invoices
```

3. Run the following command to set up the project, which will install dependencies, create the database, and perform necessary setup tasks.

```bash
bin/setup
```

### Running the project

```bash
bin/dev
```

This will start the development server, and you can access the application at http://localhost:3000.


### Running tests
```bash
bundle exec rspec spec
```

This command will execute all the tests, including use case tests, integration tests (using headless Chrome), and mailer tests.

Note: Integration tests use headless Chrome, which may have dependencies or configurations that could cause issues on some machines. Ensure that your system meets the requirements for headless Chrome to avoid any problems during testing.

### Manual Testing of Email and Token

#### Email Testing

- Use `elonmusk@pinscher.com` to check for the system's email delivery.

#### Token Testing for Login

- Use the token `4f91348a9fe9936f785ee14d799ee4813a1e92dc` for testing the login process.
- Enter the token on the login page and verify if access is granted.

# User Authentication

## Access Tokens

Each user account can be associated with multiple access tokens.

Each token has these key attributes:

- **Value**: A unique identifier used for authentication.
- **Expiration Date**: The date and time when the token becomes invalid.
- **Active Status**: Indicates whether the token is currently in use.

## User Login and Logout

A valid, active token is required for user login. This is verified during the login attempt.

Users can activate tokens in two ways:

1. **Generate New Token**: Users request a new token via email. They receive an activation link to enable the token.
2. **Login with Existing Token**: Users can also log in by entering a valid token.

A new token requires activation through a link sent to the user's email. This activates the token and logs the user in.

Only one token can be active at a time. Generating a new token deactivates the previous one, but the old token remains active until the new one is activated through the email link.

## Email and Token Encryption

- For security, emails are encrypted using a secure method.
- Access token values are encrypted for additional security.

## Notes

- The system doesn't use `generates_token_for`, a Rails feature for token management. A custom method is chosen for better control over token activation and invalidation, involving user activation links.

# Invoice Management

## User's Invoices

- Users can have several invoices linked to their accounts.

## Invoice Details

- Each invoice is identified by a unique number, created using a PostgreSQL sequence in the database.
- To ensure privacy and security, all invoice data (like company and billing details, total value) is encrypted.

## Money Handling

- **`money-rails` Gem**: This gem is utilized for efficient handling of invoice values.

## Invoice Email Notifications

- Each invoice has `invoice_email` records to store email addresses of recipients.
- Recipients are sent the invoice in PDF format and a link to view it online.

## Background Job for Invoice Creation

- After creating an invoice, a background job (managed by Active Job) generates a temporary PDF of the invoice.
- This job also handles sending the PDF to all the email addresses specified in the form, using Rails' mailers.

## Notes

- For development purposes, the `letter_opener` gem is used. This allows developers to view the email delivery process as if they were a user, with emails opening in a web browser window. It simulates the experience of a user receiving and opening the invoice email in their inbox.

## Extensive Use of Hotwire

- The application makes extensive use of Hotwire, an advanced set of techniques for building modern web applications with minimal JavaScript.
- Through Hotwire, rich, real-time user interactions were implemented, making the application more responsive and dynamic.
- Hotwire allowed for the efficient building of complex front-end features, without the overhead of managing extensive JavaScript codebases.

# Code Design Overview

- The code is structured using namespaces like `Api::V1` and `Invoices`, which helps in clearly separating different areas such as API functionality and invoice management.
- Rails conventions are used for database interactions (ActiveRecord) and RESTful routes. This ensures efficiency and consistency with Rails' standards.
- The structure is flexible, allowing for easy integration of new features or complex components like repositories or service objects as needed.
- The code is divided into modules, each responsible for a specific set of functions. This makes maintenance and testing more manageable, as changes in one module do not heavily impact the others.
- By sticking to Rails best practices and ensuring clear separation of concerns, the codebase is designed to be easily understandable and maintainable, reducing long-term technical complications.

# Code Quality

This project emphasizes code quality by using Lefthook, a tool that takes the place of a traditional Continuous Integration (CI) system. Lefthook is configured to run a series of checks and tests before each commit, ensuring that only high-quality code is integrated into the main codebase. This approach streamlines the development process while maintaining strict standards for code quality.

# API Documentation

## Endpoints

### GET /api/v1/invoices

Returns a list of invoices, with support for filtering and pagination.

#### Parameters

- `issue_date` (optional): Filters invoices by issue date.
- `invoice_number` (optional): Filters invoices by the invoice number.
- `items` (optional): Sets the number of items per page (for pagination).
- `page` (optional): Specifies the current page (for pagination).

#### Headers

- `Authorization`: Authentication token.

#### Responses

- **200 OK**: Successful retrieval of the invoice list.
- **401 Unauthorized**: Invalid or expired token.

### POST /api/v1/invoices

Creates a new invoice.

#### Parameters

- `invoice`:
  - `user_id`: User ID associated with the invoice.
  - `issue_date`: Issue date of the invoice.
  - `company`: Name of the company.
  - `billing_to`: Invoice recipient.
  - `total_value`: Total value of the invoice.
  - `invoice_emails_attributes`: Attributes for emails related to the invoice.

#### Headers

- `Authorization`: Authentication token.

#### Responses

- **200 OK**: Successful creation of the invoice.
- **422 Unprocessable Entity**: Validation errors in the invoice data.
- **401 Unauthorized**: Invalid or expired token.

### GET /api/v1/invoices/:id

Returns a specific invoice by ID.

#### Parameters

- `id`: Invoice ID.

#### Headers

- `Authorization`: Authentication token.

#### Responses

- **200 OK**: Successful retrieval of the invoice.
- **404 Not Found**: Invoice not found.
- **401 Unauthorized**: Invalid or expired token.

# Potential Improvements

- Introduce `Kind::Value` to create value objects for key entities like user ID, email, etc. This would add more structure and type safety, making the data handling more robust and clear.
- If needed, database queries can be isolated in repositories. This separation can improve the organization of the codebase and make it easier to manage and optimize data access.
- The links sent to users for viewing invoices could be set to expire after a certain period. This would add an additional layer of security, preventing unauthorized access to invoice details.
- Instead of using sequential numbers for invoices, implementing slugs can make it harder for someone to guess and access invoices. This would enhance the security and privacy of invoice data.
- For a production environment, deployment could be handled using Kamal. This approach would suit the production requirements.
- To collect and monitor application metrics in a production environment, implementing a gem like `yabeda` can be beneficial. It would provide valuable insights and performance metrics.

## Notes

- The current application is designed for a development environment. These improvements would be particularly relevant if scaling up to a production environment, where security, data management, and performance monitoring become crucial.
