# Report Factory

*Report Factory* is a storage for your test reports with intuitive API to manage all your projects test results.

The provided API are based on the [JSON API](http://jsonapi.org) convention.

## Preconditions

- Add `Content-Type` header with `application/vnd.api+json`
- Add your account's `X-API-KEY` to header

## Available API

### Users

To login and get your `X-API-KEY`:

_POST_ `/api/v1/users/login`

```json
{
    "data":{
        "type":"users",
        "attributes":{
            "email":"new_user@mailinator.com",
            "password":"Password1"
        }
    }
}
```

---

To return all registered users:

_GET_  `/api/v1/users`

---

To create a user (Admin only):

_POST_ `/api/v1/users/create`

```json
{
    "data":{
        "type":"users",
        "attributes":{
            "name":"UserName",
            "email":"new_user@mailinator.com",
            "password":"Password1"
        }
    }
}
```

---

To update a user (Admin only):

_PUT_ `/api/v1/users/:id`

```json
{
    "data":{
        "type":"users",
        "attributes":{
            "name":"UpdatedName",
            "email":"updated_user@mailinator.com"
        }
    }
}
```
*Note:* You can promote user to Admin by passing `"type":"Admin"`

---

To get your user information:

_GET_  `/api/v1/users/:id`

---

To get all reports of a user:

_GET_  `/api/v1/users/:id/reports`

---

To delete a user (Admin only):

_DELETE_  `/api/v1/users/:id`

---
### Projects

To return all available projects:

_GET_  `/api/v1/projects`

---

To create a new project:

_POST_ `/api/v1/projects`

```json
{
    "data":{
        "type":"project",
        "attributes":{
            "project_name":"MyAwesomeProject"
        }
    }
}
```

---

To get project by name:

_GET_  `/api/v1/projects/:project_name`

---

To update a project:

_PUT_  `/api/v1/projects/:project_name`

```json
{
    "data":{
        "type":"project",
        "attributes":{
            "project_name":"UpdatedProjectName"
        }
    }
}
```

### Reports

To return all reports within a project:

_GET_  `/api/v1/projects/:project_name/reports`

---

To get all RSpec reports within a project:

_GET_  `/api/v1/projects/:project_name/reports/rspec`

---

To submit an RSpec report:

_POST_ `/api/v1/projects/:project_name/reports/rspec`

```json
{
  "data": {
    "type": "rspec_report",
    "attributes": {
      "version": "3.7.0",
      "examples": [
        {
          "id": "./spec/routing/routes_spec.rb[1:4:1]",
          "description": "routes GET /api/v1/projects/:project_name/reports/rspecto rspec_reports#index",
          "full_description": "routing /api/v1/projects/:project_name/reports/rspec routes GET /api/v1/projects/:project_name/reports/rspecto rspec_reports#index",
          "status": "passed",
          "file_path": "./spec/routing/routes_spec.rb",
          "line_number": 59,
          "run_time": 0.001341,
          "pending_message": null,
        },
        {
          "id": "./spec/requests/rspec_reports_api_spec.rb[1:1:1]",
          "description": "gets all rspec reports within project",
          "full_description": "RspecReports GET index gets all rspec reports within project",
          "status": "failed",
          "file_path": "./spec/requests/rspec_reports_api_spec.rb",
          "line_number": 11,
          "run_time": 0.032876,
          "pending_message": null,
          "exception": {
            "class": "RSpec::Expectations::ExpectationNotMetError",
            "message": "\nexpected: 200\n     got: 204\n\n(compared using ==)\n",
            "backtrace": [
              "./gems/rspec-support-3.7.0/lib/rspec/support.rb:97:in `block in \u003cmodule:Support\u003e'",
              "./gems/rspec-support-3.7.0/lib/rspec/support.rb:106:in `notify_failure'",
              "./gems/rspec-expectations-3.7.0/lib/rspec/expectations/fail_with.rb:35:in `fail_with'",
              "./gems/rspec-expectations-3.7.0/lib/rspec/expectations/handler.rb:38:in `handle_failure'",
              "./gems/rspec-expectations-3.7.0/lib/rspec/expectations/handler.rb:50:in `block in handle_matcher'",
            ]
          }
        }
      ]
      "summary": {
        "duration": 0.747558,
        "example_count": 2,
        "failure_count": 1,
        "pending_count": 0,
        "errors_outside_of_examples_count": 0
      },
      "summary_line": "2 examples, 1 failures",
    }
  }
}
```

---

To view an existing RSpec report:

_GET_  `/api/v1/projects/:project_name/reports/rspec/:id`
