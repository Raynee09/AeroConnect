# AeroConnect — Airline Reservation & Management System

A Java EE web application built with Jakarta Servlets, JSP, JDBC, and MySQL.
MVC architecture. Runs on Apache Tomcat 10.1.

---

## Tech Stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| Language    | Java 17                           |
| Web tier    | Jakarta Servlets + JSP + JSTL     |
| Data tier   | JDBC + MySQL 8.x                  |
| Build       | Maven (WAR packaging)             |
| Server      | Apache Tomcat 10.1                |
| Security    | BCrypt password hashing, sessions |
| Frontend    | HTML5, CSS3, vanilla JavaScript   |

---

## Prerequisites

1. **Java 17** — [adoptium.net](https://adoptium.net)
2. **Maven 3.9+** — [maven.apache.org](https://maven.apache.org)
3. **MySQL 8.x** — see installation below
4. **Apache Tomcat 10.1** — [tomcat.apache.org](https://tomcat.apache.org/download-10.cgi)

---

## MySQL Installation

### Windows
1. Download MySQL Installer from [dev.mysql.com/downloads/installer](https://dev.mysql.com/downloads/installer/).
2. Run the installer, choose **Developer Default** or at minimum **MySQL Server**.
3. Set a root password when prompted — note it down.
4. Ensure the MySQL service is running (check in Windows Services).

### macOS (Homebrew)
```bash
brew install mysql
brew services start mysql
mysql_secure_installation   # follow prompts to set root password
```

### Ubuntu / Debian
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
```

---

## Database Setup

1. Open a MySQL client:
   ```bash
   mysql -u root -p
   ```

2. Run the initialization script:
   ```bash
   mysql -u root -p < sql/schema.sql
   ```
   This creates the `aeroconnect` database, all tables, and sample data including:
   - Admin account: `admin@aeroconnect.com` / `Admin@123`
   - Sample passenger: `john.doe@example.com` / `Pass@1234`
   - 4 aircraft and 8 sample scheduled flights

---

## Application Configuration

Edit `src/main/resources/db.properties` with your MySQL credentials:

```properties
db.url=jdbc:mysql://localhost:3306/aeroconnect?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&allowPublicKeyRetrieval=true
db.username=root
db.password=YOUR_PASSWORD_HERE
```

**Alternative — environment variables** (recommended for production):
```
AEROCONNECT_DB_URL=jdbc:mysql://localhost:3306/aeroconnect?...
AEROCONNECT_DB_USER=root
AEROCONNECT_DB_PASSWORD=your_password
```
Environment variables take priority over `db.properties`.

---

## Build

```bash
cd path/to/Aeroconnect
mvn clean package
```

The WAR file will be at `target/aeroconnect.war`.

---

## Deployment (Tomcat 10.1)

1. Copy the WAR to Tomcat's webapps directory:
   ```bash
   cp target/aeroconnect.war $CATALINA_HOME/webapps/
   ```

2. Start Tomcat:
   ```bash
   $CATALINA_HOME/bin/startup.sh     # Linux/macOS
   %CATALINA_HOME%\bin\startup.bat   # Windows
   ```

3. Access the application:
   ```
   http://localhost:8080/aeroconnect/
   ```

---

## Application Routes

### Public
| URL                        | Description            |
|----------------------------|------------------------|
| `/`                        | Home page              |
| `/auth/login`              | Login                  |
| `/auth/register`           | Registration           |
| `/auth/logout`             | Logout                 |
| `/flights/search`          | Flight search          |

### Passenger (requires login)
| URL                              | Description         |
|----------------------------------|---------------------|
| `/passenger/dashboard`           | Passenger dashboard |
| `/passenger/bookings`            | My bookings list    |
| `/passenger/bookings?id={id}`    | Booking detail      |
| `/passenger/profile`             | Profile management  |

### Admin (requires ADMIN role)
| URL                              | Description           |
|----------------------------------|-----------------------|
| `/admin/dashboard`               | Admin overview        |
| `/admin/flights`                 | Manage flights        |
| `/admin/passengers`              | Manage passengers     |
| `/admin/bookings`                | Manage bookings       |

---

## Default Credentials

| Role      | Email                      | Password    |
|-----------|----------------------------|-------------|
| Admin     | admin@aeroconnect.com      | Admin@123   |
| Passenger | john.doe@example.com       | Pass@1234   |

> **Change these passwords immediately after first login in any real deployment.**

---

## Project Structure

```
src/
├── main/
│   ├── java/com/aeroconnect/
│   │   ├── controller/           # Servlets (public, passenger, admin)
│   │   ├── model/                # Domain objects (User, Flight, Booking, ...)
│   │   ├── dao/                  # Data access (JDBC, PreparedStatements)
│   │   ├── service/              # Business logic
│   │   ├── util/                 # DB, password, validation utilities
│   │   └── filter/               # Auth & encoding filters
│   ├── resources/
│   │   ├── db.properties         # Database configuration
│   │   └── logback.xml           # Logging configuration
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml           # Servlet/filter configuration
│       │   └── views/
│       │       ├── common/       # Shared JSP fragments (navbar, footer, etc.)
│       │       ├── public/       # Home, login, register, search, errors
│       │       ├── passenger/    # Dashboard, bookings, profile
│       │       └── admin/        # Dashboard, flights, passengers, bookings
│       ├── assets/
│       │   ├── css/main.css      # Design system & all styles
│       │   └── js/main.js        # Shared JS utilities
│       └── index.jsp             # Root redirect
sql/
└── schema.sql                    # Full database schema + seed data
pom.xml                           # Maven project descriptor
```

---

## Development Notes

- **No SQL in JSPs** — all queries go through DAO classes.
- **BCrypt** (cost 12) for all password storage.
- **PreparedStatements** throughout — no string-concatenated SQL.
- **AuthFilter** protects `/passenger/*` and `/admin/*` routes.
- The design system uses CSS custom properties (variables) defined in `:root`.
- JSTL uses the `jakarta.tags.*` URIs (compatible with Tomcat 10.1 / Jakarta EE 10).

---

## Upcoming Modules

The following will be implemented in subsequent tasks:
- Full booking creation workflow (seat selection → payment simulation)
- Boarding pass generation
- Admin flight CRUD (form submission handling)
- Passenger booking cancellation
- Advanced admin analytics
