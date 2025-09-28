# ✅ Todo List API

A compact **Rails API** demonstrating **production-ready patterns** a senior backend engineer would use.  
This project is designed as a portfolio-ready showcase, emphasizing clean code, maintainability, and real-world practices.

---

## ✨ Features

- 🔑 **Authentication** — JWT-based (stateless, expires in 30 minutes)  
- 🔒 **Secure Passwords** — hashed with `bcrypt`  
- 👤 **Role-based Authorization** — via CanCanCan (`Ability` class)  
- 📌 **Ownership Model** — `User` has_many `Task`; access enforced by permissions  
- ⚡ **Centralized Error Handling** — consistent JSON error responses  
- 🧩 **JSON Serialization** — clean, client-ready responses with serializers  

---

## 🚀 Quick Start

1. **Install dependencies**
   ```bash
   bundle install
   ```

2. **Set environment variables**  
   Create `JWT_SECRET_KEY` or configure Rails credentials:
   ```bash
   export JWT_SECRET_KEY=your_secret_key
   ```

3. **Run database setup**
   ```bash
   rails db:create db:migrate
   ```

4. **Start the server**
   ```bash
   bin/rails server
   ```

Server will be available at: `http://localhost:3000`

---

## 📡 API Endpoints

### 🔐 Authentication

#### **POST /auth/signup**
Create a new user account (default role = `user`).

Request:
```json
{
  "user": { "email": "a@b.com", "password": "pass", "password_confirmation": "pass" }
}
```

Response:
```json
{ "token": "<jwt>", "user": { "id": 1, "email": "a@b.com", "role": "user" } }
```

---

#### **POST /auth/login**
Authenticate a user and return a JWT valid for 30 minutes.

Request:
```json
{
  "user": { "email": "a@b.com", "password": "pass" }
}
```

Response:
```json
{ "token": "<jwt>", "user": { "id": 1, "email": "a@b.com", "role": "user" } }
```

---

### ✅ Tasks  
(*Require `Authorization: Bearer <jwt>` header*)

- **GET /tasks**  
  - Admins: fetch all tasks  
  - Users: fetch their own tasks  

- **GET /tasks/:id**  
  - Fetch a specific task (must own it unless admin).  

- **POST /tasks**  
  Create a new task.  

  Request:
  ```json
  {
    "task": { "title": "Buy milk" }
  }
  ```

- **PATCH /tasks/:id** or **PUT /tasks/:id**  
  Update an existing task.  

  Request:
  ```json
  {
    "task": { "done": true }
  }
  ```

- **DELETE /tasks/:id**  
  Delete a task (owner or admin only).  

---

## 🖥️ Example Usage (cURL)

### 1. Signup
```bash
curl -X POST http://localhost:3000/auth/signup   -H "Content-Type: application/json"   -d '{"user": {"email":"me@example.com", "password":"secret123", "password_confirmation":"secret123"}}'
```

### 2. Login
```bash
curl -X POST http://localhost:3000/auth/login   -H "Content-Type: application/json"   -d '{"user": {"email":"me@example.com", "password":"secret123"}}'
```

### 3. Create a Task
```bash
curl -X POST http://localhost:3000/tasks   -H "Content-Type: application/json"   -H "Authorization: Bearer <TOKEN>"   -d '{"task": {"title":"Buy milk"}}'
```

---

## 🛠️ Ideas for Further Enhancements

- ✅ Integration tests with **RSpec**  
- 📊 Request throttling & audit logs  
- 🔄 Refresh tokens & token rotation  
- 🖥️ Admin dashboard (RailsAdmin or custom UI)  

---

