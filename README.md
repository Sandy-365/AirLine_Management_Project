# ✈️ Airline Management System

A full-stack **Airline Management System** built using **.NET 10, ASP.NET Core Web API, Angular, SQL Server, RabbitMQ, Redis, Ocelot API Gateway, JWT, Serilog, and Docker**.

The application follows a **microservices architecture** in which airline business domains are separated into independently deployable services. Each service maintains its own database and communicates through REST APIs and asynchronous RabbitMQ events.

The frontend is developed using Angular and communicates with the backend through the centralized Ocelot API Gateway.

---

## 📌 Project Overview

The Airline Management System is designed to provide a centralized digital platform for managing airline operations, passengers, dealers, administrators, and ground operations.

The system is divided into multiple independent microservices based on business responsibilities.

### Main Roles

* **Admin**
* **Passenger**
* **Dealer**
* **Ground Operations Staff**

Each role has access to functionality appropriate to its responsibilities through **JWT authentication and role-based authorization**.

---

## 🎯 Objectives

The primary objectives of the project are:

* Build a scalable airline management platform.
* Separate business functionality into independent microservices.
* Provide secure RESTful APIs.
* Implement centralized API routing through Ocelot.
* Implement JWT-based authentication and authorization.
* Use RabbitMQ for asynchronous communication.
* Use Redis for distributed caching.
* Maintain separate databases for individual services.
* Containerize application infrastructure using Docker.
* Provide a modern Angular frontend.
* Maintain loose coupling between services.
* Improve fault isolation and independent scalability.

---

# 🏗️ System Architecture

The application follows a **microservices architecture** with an Angular frontend, API Gateway, backend services, individual databases, RabbitMQ and Redis.

```text
                              ┌───────────────────────┐
                              │      Angular UI       │
                              │       Frontend        │
                              └───────────┬───────────┘
                                          │
                                          │ HTTP / HTTPS
                                          ▼
                              ┌───────────────────────┐
                              │    Ocelot Gateway     │
                              │                       │
                              │ • API Routing         │
                              │ • JWT Validation      │
                              │ • Authorization       │
                              │ • Rate Limiting       │
                              └───────────┬───────────┘
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    │                     │                     │
                    ▼                     ▼                     ▼
          ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
          │  Admin Service   │  │ Passenger Service│  │  Dealer Service  │
          │                  │  │                  │  │                  │
          │ ASP.NET Core API │  │ ASP.NET Core API │  │ ASP.NET Core API │
          └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
                   │                     │                     │
                   ▼                     ▼                     ▼
             ┌───────────┐         ┌───────────┐         ┌───────────┐
             │ Admin DB  │         │Passenger DB│        │ Dealer DB │
             │ SQL Server│         │ SQL Server │        │ SQL Server│
             └───────────┘         └───────────┘         └───────────┘

                              ┌──────────────────────┐
                              │ Ground Operations    │
                              │       Service        │
                              └──────────┬───────────┘
                                         │
                                         ▼
                                   ┌───────────┐
                                   │ Ground DB │
                                   │ SQL Server│
                                   └───────────┘


             ┌──────────────────────────────────────────────┐
             │                   RabbitMQ                   │
             │        Asynchronous Event Messaging         │
             └──────────────────────────────────────────────┘

             ┌──────────────────────────────────────────────┐
             │                    Redis                     │
             │              Distributed Cache               │
             └──────────────────────────────────────────────┘
```

---

# 🧩 Microservices

The backend is divided into independent services according to business responsibilities.

## 👨‍💼 Admin Service

The Admin Service provides administrative functionality for managing the airline platform.

Responsibilities include:

* User management
* Airline data management
* Flight management
* Administrative operations
* Role-related operations
* System-level management

The service exposes RESTful APIs consumed through the API Gateway.

---

## 👤 Passenger Service

The Passenger Service handles passenger-related functionality.

Responsibilities include:

* Passenger registration
* Passenger profile management
* Flight information
* Flight search
* Booking operations
* Reservation management
* Passenger-specific operations

The service maintains its own database and exposes APIs through Ocelot.

---

## 🤝 Dealer Service

The Dealer Service handles dealer-related airline operations.

Responsibilities include:

* Dealer-related information
* Dealer operations
* Dealer-specific workflows
* Communication with other services where required

The service follows the same independent-service architecture and maintains its own data boundary.

---

## 🛫 Ground Operations Service

The Ground Operations Service handles functionality associated with airport and ground operations.

Responsibilities include:

* Ground-operation workflows
* Operational information
* Ground staff functionality
* Event-driven operational processing

---

# 🌐 API Gateway — Ocelot

The application uses **Ocelot API Gateway** as the centralized entry point for backend APIs.

Instead of allowing the Angular frontend to communicate directly with every microservice, requests are routed through Ocelot.

```text
Angular
   │
   ▼
Ocelot API Gateway
   │
   ├──► Admin Service
   │
   ├──► Passenger Service
   │
   ├──► Dealer Service
   │
   └──► Ground Operations Service
```

### Gateway Responsibilities

* Request routing
* Authentication
* Authorization
* JWT validation
* Rate limiting
* Centralized API access
* Hiding internal service endpoints

This approach prevents the frontend from becoming tightly coupled to individual backend services.

---

# 🔐 Authentication & Authorization

The application uses **JWT-based authentication**.

The authentication flow is:

```text
User
 │
 ▼
Angular Login
 │
 ▼
Authentication API
 │
 ▼
JWT Token
 │
 ▼
Angular
 │
 ▼
HTTP Request + Bearer Token
 │
 ▼
Ocelot Gateway
 │
 ▼
JWT Validation
 │
 ▼
Role Authorization
 │
 ▼
Microservice
```

The system supports role-based access for:

```text
Admin
Passenger
Dealer
Ground Operations Staff
```

A JWT contains the required claims that allow the application to determine the identity and role of the authenticated user.

---

# 🔄 Inter-Service Communication

The application uses two primary communication patterns.

## Synchronous Communication

REST APIs are used when the requesting service needs an immediate response.

```text
Angular
   │
   ▼
Ocelot
   │
   ▼
Microservice
   │
   ▼
SQL Server
   │
   ▼
Response
```

---

## Asynchronous Communication

**RabbitMQ** is used for event-driven communication.

```text
Service A
    │
    │ Publish Event
    ▼
 RabbitMQ
    │
    │ Consume Event
    ▼
Service B
```

This reduces direct dependencies between services and allows consumers to process events independently.

### Benefits

* Loose coupling
* Asynchronous processing
* Improved fault isolation
* Better scalability
* Independent service processing
* Event-driven architecture

---

# 🐇 RabbitMQ

RabbitMQ acts as the message broker for asynchronous communication.

A typical workflow is:

```text
Producer
   │
   ▼
RabbitMQ Exchange / Queue
   │
   ▼
Consumer
   │
   ▼
Business Processing
```

RabbitMQ allows a service to publish an event without requiring the receiving service to process it immediately.

This is particularly useful for operations where synchronous communication would unnecessarily couple services.

---

# ⚡ Redis Caching

The system uses **Redis** as a distributed caching mechanism.

```text
Application
     │
     ▼
 Check Redis
   /     \
 Hit     Miss
 │         │
 ▼         ▼
Return   SQL Server
Data        │
            ▼
       Store in Redis
```

Redis can reduce repeated database queries for frequently accessed data.

### Advantages

* Reduced database load
* Faster read operations
* Improved response time
* Distributed cache support
* Better scalability

---

# 🗄️ Database Architecture

The project follows the **Database-per-Service** approach.

Each microservice owns its data and database.

```text
Admin Service
     │
     ▼
Admin Database

Passenger Service
     │
     ▼
Passenger Database

Dealer Service
     │
     ▼
Dealer Database

Ground Operations Service
     │
     ▼
Ground Operations Database
```

This prevents a single shared database from becoming a tight coupling point between microservices.

### Database Technology

**Microsoft SQL Server** is used for persistent application data.

The backend can interact with SQL Server through the .NET data-access layer and Entity Framework Core where configured.

---

# 🖥️ Angular Frontend

The frontend is implemented using **Angular**.

The frontend acts as the presentation layer and communicates with backend APIs through Ocelot.

```text
Angular Components
       │
       ▼
Angular Services
       │
       ▼
HTTP Client
       │
       ▼
Ocelot API Gateway
       │
       ▼
.NET Microservices
```

## Frontend Architecture

The frontend uses modern Angular concepts including:

* Standalone components
* Angular Signals
* RxJS
* Dependency Injection
* Lazy-loaded routes
* Route guards
* HTTP services
* Authentication
* Role-based navigation
* Forms
* API integration

---

# 🛡️ Angular Route Guards

Route guards protect frontend routes based on authentication and authorization requirements.

Conceptually:

```text
User
 │
 ▼
Protected Route
 │
 ▼
Auth Guard
 │
 ├── Not Authenticated → Login
 │
 └── Authenticated
          │
          ▼
      Role Guard
          │
          ├── Authorized → Component
          │
          └── Unauthorized → Access Denied
```

This prevents unauthorized users from navigating to restricted parts of the application.

---

# 📡 HTTP Communication

Angular communicates with backend services through HTTP APIs.

Typical flow:

```text
Angular Component
       │
       ▼
Angular Service
       │
       ▼
HttpClient
       │
       ▼
Ocelot Gateway
       │
       ▼
.NET API
```

The frontend receives JSON responses from the backend and uses them to update the UI.

---

# 🧱 Backend Technology

The backend is built using **ASP.NET Core Web API on .NET 10**.

The backend follows standard layered application concepts such as:

```text
Controller
    │
    ▼
Service / Business Logic
    │
    ▼
Data Access
    │
    ▼
SQL Server
```

### Backend Responsibilities

* HTTP request handling
* Model binding
* Validation
* Authentication
* Authorization
* Business logic
* Database operations
* API responses
* Logging
* Exception handling
* Inter-service communication

---

# 📋 RESTful APIs

The backend exposes RESTful endpoints for application functionality.

The API design follows HTTP methods such as:

```text
GET      → Retrieve data
POST     → Create data
PUT      → Update data
DELETE   → Delete data
```

Example conceptual API:

```text
GET    /api/flights
GET    /api/flights/{id}
POST   /api/flights
PUT    /api/flights/{id}
DELETE /api/flights/{id}
```

Actual routes depend on the individual microservice controllers.

---

# 🧬 DTOs

Data Transfer Objects are used to control the data exposed through APIs.

Instead of directly exposing internal database entities, the application can use DTOs to define API request and response structures.

```text
Database Entity
      │
      ▼
Service Layer
      │
      ▼
DTO
      │
      ▼
API Response
      │
      ▼
Angular
```

DTOs help provide:

* Data encapsulation
* Controlled API contracts
* Reduced over-posting
* Separation between database models and API models
* Cleaner API design

---

# 🗺️ Dependency Injection

ASP.NET Core's built-in Dependency Injection system is used to register and resolve application dependencies.

Typical dependency lifetimes include:

```text
AddTransient()
AddScoped()
AddSingleton()
```

For example:

```csharp
builder.Services.AddScoped<IFlightService, FlightService>();
```

This allows controllers and other classes to depend on abstractions rather than creating service objects directly.

---

# 📝 Logging

The backend uses **Serilog** for structured application logging.

Logging can be used for:

* Application startup
* HTTP requests
* Errors
* Exceptions
* Business operations
* Debugging
* Operational monitoring

Structured logging makes application behavior easier to investigate in development and production environments.

---

# 📖 Swagger / OpenAPI

The backend provides API documentation through **Swagger / OpenAPI**.

Swagger allows developers to:

* View available endpoints
* Inspect request models
* Inspect response models
* Test APIs
* Understand API contracts
* Authorize using JWT where configured

Typical Swagger endpoint:

```text
/swagger/index.html
```

The exact URL depends on the service configuration.

---

# 🐳 Docker

The project includes Docker configuration and a Docker Compose setup.

Docker provides a consistent runtime environment for application services and infrastructure.

Conceptually:

```text
                    Docker Compose
                         │
       ┌─────────────────┼─────────────────┐
       │                 │                 │
       ▼                 ▼                 ▼
   .NET APIs         SQL Server         RabbitMQ
                                         
                         │
                         ▼
                       Redis
```

### Benefits

* Consistent development environment
* Simplified deployment
* Service isolation
* Easy infrastructure setup
* Reproducible environments
* Container-based scaling

---

# 📦 Repository Structure

```text
AirLine_Management_Project/
│
├── AirlineManagementSystem/
│   │
│   ├── Microservices
│   │   ├── Admin
│   │   ├── Passenger
│   │   ├── Dealer
│   │   └── Ground Operations
│   │
│   └── API Gateway
│
├── AirlineManagementSystem_Frontend/
│   │
│   ├── src/
│   ├── components/
│   ├── services/
│   ├── guards/
│   ├── models/
│   └── ...
│
├── sqlserver-docker/
│   └── SQL Server Docker Configuration
│
├── docker-compose.yml
│
└── .gitignore
```

---

# 🔁 Complete Request Flow

A typical authenticated request follows this architecture:

```text
┌─────────────┐
│   Angular   │
└──────┬──────┘
       │
       │ HTTP Request
       │ + JWT
       ▼
┌─────────────┐
│   Ocelot    │
│   Gateway   │
└──────┬──────┘
       │
       │ Validate JWT
       │ Route Request
       ▼
┌─────────────┐
│ Microservice│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Controller  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Service   │
│ Business    │
│   Logic     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Data Access │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ SQL Server  │
└─────────────┘
```

For asynchronous operations:

```text
Microservice A
      │
      ▼
   RabbitMQ
      │
      ▼
Microservice B
      │
      ▼
   Database
```

---

# 🔒 Security Architecture

The project applies security at multiple levels.

### Frontend

* Authentication state
* Route guards
* Role-based navigation
* Protected routes

### API Gateway

* JWT validation
* Authorization
* Routing
* Rate limiting

### Backend

* `[Authorize]` protected endpoints
* Role-based authorization
* Input validation
* Controlled API models

### Infrastructure

* Isolated service databases
* Containerized infrastructure
* Configuration-based secrets

Secrets such as database passwords and JWT signing keys should be supplied through secure configuration or environment variables rather than committed to Git.

---

# 📊 Advantages of the Architecture

## Independent Deployment

Each microservice can be deployed independently.

## Fault Isolation

A failure in one service does not necessarily bring down the complete application.

## Independent Scaling

High-traffic services can be scaled independently.

## Loose Coupling

RabbitMQ reduces direct dependencies between services.

## Database Isolation

Each service owns its data.

## Centralized API Access

Ocelot provides a single entry point for frontend API communication.

## Performance

Redis reduces repeated database operations.

## Containerization

Docker makes the development and deployment environment reproducible.

---

# 🛠️ Technology Stack

| Layer                   | Technology               |
| ----------------------- | ------------------------ |
| Frontend                | Angular                  |
| Programming Language    | TypeScript               |
| Backend                 | .NET 10                  |
| API Framework           | ASP.NET Core Web API     |
| API Gateway             | Ocelot                   |
| Authentication          | JWT                      |
| Authorization           | Role-Based Authorization |
| Database                | Microsoft SQL Server     |
| ORM                     | Entity Framework Core    |
| Messaging               | RabbitMQ                 |
| Caching                 | Redis                    |
| Logging                 | Serilog                  |
| API Documentation       | Swagger / OpenAPI        |
| Containerization        | Docker                   |
| Container Orchestration | Docker Compose           |
| Version Control         | Git / GitHub             |

---

# ⚙️ Prerequisites

Install the following before running the project:

* Git
* .NET 10 SDK
* Node.js
* npm
* Angular CLI
* Docker Desktop

Infrastructure required by the application:

* SQL Server
* RabbitMQ
* Redis

Docker can be used to simplify infrastructure setup.

---

# 🚀 Installation

## 1. Clone the Repository

```bash
git clone https://github.com/Sandy-365/AirLine_Management_Project.git
```

Navigate into the project:

```bash
cd AirLine_Management_Project
```

---

## 2. Start Docker Infrastructure

From the project root:

```bash
docker compose up -d
```

Check running containers:

```bash
docker ps
```

---

## 3. Backend Setup

Navigate to the backend:

```bash
cd AirlineManagementSystem
```

Restore .NET dependencies:

```bash
dotnet restore
```

Build the backend:

```bash
dotnet build
```

Run the required microservices using their configured projects.

---

## 4. Frontend Setup

Navigate to the Angular application:

```bash
cd AirlineManagementSystem_Frontend
```

Install packages:

```bash
npm install
```

Start the development server:

```bash
ng serve
```

The Angular application is typically available at:

```text
http://localhost:4200
```

---

# 🧪 Testing the APIs

After starting the backend services, open the Swagger UI for the corresponding API.

```text
http://localhost:<PORT>/swagger/index.html
```

Use Swagger to:

1. Authenticate.
2. Obtain the JWT token.
3. Authorize the Swagger client.
4. Execute protected endpoints.
5. Inspect API responses.

---

# 🔧 Configuration

Before running the application, configure environment-specific settings such as:

* SQL Server connection strings
* JWT configuration
* RabbitMQ connection
* Redis connection
* Ocelot routes
* Service ports
* CORS settings

Example configuration concepts:

```text
SQL Server
     │
     ├── Connection String
     │
     ▼
Microservice

RabbitMQ
     │
     ├── Host
     ├── Username
     └── Password

Redis
     │
     └── Connection String
```

Do not commit production credentials or secrets to GitHub.

---

# 📁 Development Workflow

A typical development workflow is:

```text
1. Start infrastructure
        ↓
2. Start backend services
        ↓
3. Start Ocelot Gateway
        ↓
4. Start Angular frontend
        ↓
5. Authenticate
        ↓
6. Access role-specific functionality
        ↓
7. Backend processes request
        ↓
8. Database / Redis / RabbitMQ
        ↓
9. Response returned to Angular
```

---

# 📈 Scalability Model

Because the application uses microservices, individual services can be scaled independently.

For example:

```text
                 Ocelot
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
 Passenger Service       Admin Service
     /      \                 │
    /        \                ▼
Instance 1  Instance 2    Instance 1
```

If passenger traffic increases, additional Passenger Service instances can be deployed without necessarily scaling the Admin Service.

---

# 🧠 Software Engineering Concepts Demonstrated

This project demonstrates practical implementation of:

* Object-Oriented Programming
* SOLID Principles
* Dependency Injection
* RESTful API Design
* Microservices Architecture
* Database-per-Service
* Event-Driven Architecture
* JWT Authentication
* Role-Based Authorization
* API Gateway Pattern
* Distributed Caching
* Asynchronous Messaging
* Containerization
* Separation of Concerns
* DTO-based API contracts
* Layered architecture
* Logging and monitoring concepts

---

# 🔮 Future Improvements

Possible future enhancements include:

* Kubernetes deployment
* GitHub Actions CI/CD
* Automated unit and integration testing
* OpenTelemetry distributed tracing
* Centralized log aggregation
* API health checks
* Prometheus and Grafana monitoring
* Payment gateway integration
* Email/SMS notifications
* Real-time flight tracking
* Advanced booking workflows
* Automated database migrations
* Cloud deployment
* Service mesh integration

---

# 📸 Application Screenshots

Add screenshots of the application here to make the repository easier to understand.

Recommended screenshots:

```text
1. Login Page
2. Admin Dashboard
3. Passenger Dashboard
4. Flight Management
5. Flight Search
6. Booking Page
7. Dealer Dashboard
8. Ground Operations Dashboard
9. Swagger API
10. Docker Containers
```

Example:

```markdown
![Login](docs/images/login.png)

![Admin Dashboard](docs/images/admin-dashboard.png)

![Flight Management](docs/images/flight-management.png)
```

---

# ⭐ Repository

**Airline Management System**

GitHub Repository:

https://github.com/Sandy-365/AirLine_Management_Project

If you find the project useful for learning **.NET, Angular, Microservices, RabbitMQ, Redis, Docker, SQL Server, and API Gateway architecture**, consider giving the repository a ⭐.

---

# 📄 License

This project is primarily intended for **educational, learning, and demonstration purposes**.

Refer to the repository for the applicable licensing and usage terms.
