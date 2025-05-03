# Management Webpage Backend

API backend for the **Management Webpage** application, responsible for managing projects, technologies, and employees.  
Built with **Ruby on Rails 6.1**, using **Sidekiq** + **Redis** for asynchronous processing, and **RSpec** + **FactoryBot** for automated testing.

---

## Overview

This backend provides:

### Project Management
- Full CRUD operations (create, read, update, delete)
- Association of multiple technologies and employees per project

### Employee Management
- Profile CRUD
- Technology assignment
- Allocation to projects based on skill compatibility
- Batch import via spreadsheets (`roo`)

### Technologies
- CRUD for managing and linking technologies to projects and employees

### Asynchronous Processing
- Long-running tasks (e.g., spreadsheet import) handled via **Sidekiq** + **Redis**

### Automated Testing
- 100+ tests using **RSpec** + **FactoryBot**
- Covers business rules and system integrity
- Follows principles of **test isolation**

---

## Prerequisites

Before getting started, ensure you have the following installed:

- **Ruby** `3.1.3`
- **Rails** `6.1.7.6`
- **Database**:
  - SQLite3 (development)
  - PostgreSQL (production)
- **Redis** (required for Sidekiq)
- **Foreman** or **Overmind** (to manage Procfile-based services)

---

## Installation & Local Execution

1. **Clone the repository**

    ```bash
    git clone https://github.com/your-username/management_webpage_backend.git
    cd management_webpage_backend
    ```

2. **Install dependencies**

    ```bash
    bundle install
    ```

3. **Set up the database**

    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Start the services with Foreman**

    ```bash
    bundle exec foreman start
    ```

   The `Procfile` includes:

    ```procfile
    redis:  redis-server
    web:    bundle exec rails server -p 3000
    worker: bundle exec sidekiq
    ```

---

## Tests

- **Run the full test suite**

    ```bash
    bundle exec rspec .
    ```

- **Run a specific test file**

    ```bash
    bundle exec rspec spec/models/employee_spec.rb
    ```

---

## System Design Documentation

The complete system design documentation is available at [docs/system_design_documentation.md](docs/system_design_documentation.md).
