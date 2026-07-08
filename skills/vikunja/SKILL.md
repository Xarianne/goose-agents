---
name: vikunja
description: "Interact with Vikunja — a self-hosted task management app with kanban boards, Gantt charts, and a full REST API. Use for creating/listing/updating/deleting projects, tasks, labels, and kanban buckets."
---

# Vikunja Skill

Interact with Vikunja — a self-hosted task management app with kanban boards, Gantt charts, and a full REST API.

## Setup

Vikunja runs in Docker at `http://localhost:3456`. The API token is stored in the user's context.

**API Base:** `http://localhost:3456/api/v1`
**Auth Header:** `Authorization: Bearer <token>`

## API Reference

### Projects

| Action | Method | Endpoint | Notes |
|--------|--------|----------|-------|
| List all | `GET` | `/projects` | Returns array of projects with views |
| Get one | `GET` | `/projects/:id` | Single project with permissions |
| Create | `PUT` | `/projects` | Body: `{"title", "description", "hex_color"}` |
| Update | `POST` | `/projects/:id` | Body: partial fields |
| Delete | `DELETE` | `/projects/:id` | |

### Tasks

| Action | Method | Endpoint | Notes |
|--------|--------|----------|-------|
| List in project | `GET` | `/projects/:id/tasks` | Query: `?filter_by=done&filter_value=false` |
| List in view | `GET` | `/projects/:id/views/:vid/tasks` | |
| Create | `PUT` | `/projects/:id/tasks` | Body: `{"title", "description", "priority", "due_date", "labels"}` |
| Update | `POST` | `/tasks/:id` | Body: partial fields (`title`, `done`, `priority`, `due_date`, `description`, `project_id` to move) |
| Delete | `DELETE` | `/tasks/:id` | |
| Get one | `GET` | `/tasks/:id` | |

### Kanban Buckets

| Action | Method | Endpoint | Notes |
|--------|--------|----------|-------|
| List | `GET` | `/projects/:id/views/:vid/buckets` | |
| Create | `PUT` | `/projects/:id/views/:vid/buckets` | Body: `{"title"}` |
| Rename | `POST` | `/projects/:id/views/:vid/buckets/:bid` | Body: `{"title"}` |
| Delete | `DELETE` | `/projects/:id/views/:vid/buckets/:bid` | |
| Move task to bucket | `POST` | `/tasks/:id` | Body: `{"bucket_id": <bid>}` |

### Labels

| Action | Method | Endpoint | Notes |
|--------|--------|----------|-------|
| List all | `GET` | `/labels` | |
| Create | `PUT` | `/labels` | Body: `{"title", "hex_color"}` |
| Delete | `DELETE` | `/labels/:id` | |

### Views

Each project has 4 default views: `list`, `gantt`, `table`, `kanban`.

## Priority Mapping

| Level | Value |
|-------|-------|
| None | 0 |
| Low | 1 |
| Medium | 2 |
| High | 3 |
| Urgent | 4 |

## Common Workflows

### Create a project with kanban
```bash
curl -X PUT "$BASE/projects" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"title":"My Project"}'
# Kanban view is auto-created with To-Do / Doing / Done buckets
```

### Add a task
```bash
curl -X PUT "$BASE/projects/1/tasks" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"title":"Buy milk","priority":2,"due_date":"2026-07-10T12:00:00Z"}'
```

### Mark task complete
```bash
curl -X POST "$BASE/tasks/5" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"done":true}'
```

### Move task to another project
```bash
curl -X POST "$BASE/tasks/5" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"project_id":2}'
```

### Move task to a kanban bucket
```bash
curl -X POST "$BASE/tasks/5" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"bucket_id":2}'
```

### Delete a task
```bash
curl -X DELETE "$BASE/tasks/5" -H "Authorization: Bearer $TOKEN"
```

## Notes

- Vikunja uses `PUT` for **creating** resources and `POST` for **updating** (unusual convention)
- The API token is stored in the user's context — do not expose it in responses
- All endpoints return JSON
- Pagination headers: `x-pagination-total-pages`, `x-pagination-result-count`
- Permission header: `x-max-permission` (0=read, 1=write, 2=admin)
