# System Design Documentation

## Management Webpage API

### Overview

**System Objective:** Provide functionality for managing employees, projects, and associated technologies.

**Key Features:**
- Full CRUD operations for Employees, Projects, and Technologies.
- Employee data import via spreadsheet (CSV/XLSX).
- Model associations with validation logic.
- JSON-based API for frontend integration (SPA or mobile).

---

### Data Modeling
#### Entities & Relationships

1. **Project:**
    - `has_many :employees` — A Project can have multiple Employees.
    - `has_and_belongs_to_many :technologies` — Represents the required skills for the project.

2. **Employee:**
    - `belongs_to :project` — Each Employee belongs to a single Project.
    - `has_and_belongs_to_many :technologies` — Represents the skills the employee has.
    - **Business Rule:** An Employee can only be assigned to a Project if they share at least one Technology with it. This constraint is enforced by a class method.

3. **Technology:**
    - `has_and_belongs_to_many :projects` — A Technology can be associated with multiple Projects.
    - `has_and_belongs_to_many :employees` — A Technology can be associated with multiple Employees.

---

### Association Rules Summary:

| Relationship              | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| **Project ↔ Employees**    | One-to-many. An employee is linked to only one project.                     |
| **Project ↔ Technologies** | Many-to-many. Projects define the required skills for employees.            |
| **Employee ↔ Project**     | Conditional: Only allowed if a shared Technology exists.                     |
| **Employee ↔ Technology**  | Many-to-many. Defines the expertise of an employee.                          |

---

### Employee Import Process

1. **Endpoint:** `POST /employees/import`
    - **Accepts:** file (multipart-form with 3 columns: `user_name`, `project`, `technology_name`)
    - **Example file:** `spec/fixtures/files/employees.xlsx`

2. **Temporary Storage:**
    - The file is saved to `tmp/uploads/`.
    - This prevents the processing of incomplete or corrupted files for security/integrity.

3. **Async Job Execution** (`Employees::ImportFileJob`):
    - Reads the file using `Roo::Spreadsheet`.
    - Maps headers to model attributes.
    - For each row:
        - Creates an Employee.
        - Splits technologies.
        - Uses `find_or_create_by` to associate technologies.
        - Validates the employee's compatibility with the project.

4. **Cleanup:**
    - Deletes the file after processing.

5. **Response:**
    - Returns HTTP `202 Accepted`.

---

### Architecture

- **Architecture Style:** Monolithic — All logic resides within a single Ruby on Rails application.
- **Pattern:** MVC (Model-View-Controller)
    - **Model:** Core business logic and relationships.
    - **Controller:** HTTP handling and coordination.
    - **View:** Not applicable (API-only).

---

### Technologies Used:
- Ruby 3.1.3, Rails 6.1.7
- SQLite3 (development/test), PostgreSQL (production)
- Puma web server
- Sidekiq + Redis for background processing
- Foreman for process management
- rack-cors for CORS handling
- active_model_serializers for serialization

---

### Database Schema

**Entity-Relationship Tables:**

| Table                    | Fields                                  |
|--------------------------|-----------------------------------------|
| `employees`              | `id`, `user_name`, `project_id`        |
| `projects`               | `id`, `title`                          |
| `technologies`           | `id`, `name`                           |
| `employees_technologies` | `employee_id`, `technology_id`         |
| `projects_technologies`  | `project_id`, `technology_id`          |

**Indexes:**
- `index_employees_on_project_id`
- Join table indexes: `employee_id`, `project_id`, `technology_id`

---

### TODO:
- Update import header keys: Rename `user_name` to "User name" and adjust header mapping.
- Integrate with frontend: GitHub - Management Webpage Frontend.
- Implement frontend logic to support employee file import.

