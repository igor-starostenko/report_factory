# Report Factory

*Report Factory* is a storage for your test reports with intuitive API to manage all your projects test results.

## Preconditions

The provided API are based on the <a href="http://jsonapi.org">JSON API</a> convention.

- Add `Content-Type` header with `application/vnd.api+json`

## Available API

To return all available projects
```json
GET  /api/v1/projects
```

To create a new project
```json
POST /api/v1/projects

{
    "data":{
        "type":"project",
        "attributes":{
            "project_name":"MyAwesomeProject"
        }
    }
}
```

To get project by name
```json
GET  /api/v1/projects/:project_name
```

To update a project
```json
PUT  /api/v1/projects/:project_name  # => Updates project

{
    "data":{
        "type":"project",
        "attributes":{
            "project_name":"UpdatedProjectName"
        }
    }
}
```

To return all reports within a project:
```json
GET  /api/v1/projects/:project_name/reports
```

To get all RSpec reports within a project:
```json
GET  /api/v1/projects/:project_name/reports/rspec
```

To submit an RSpec report:
```json
POST /api/v1/projects/:project_name/reports/rspec

{
  "data": {
    "type": "rspec_report",
    "attributes": {
      "version": "3.7.0",
      "examples": [
        {
          "spec_id": "./spec/routing/routes_spec.rb[1:4:1]",
          "description": "routes GET /api/v1/projects/:project_name/reports/rspecto rspec_reports#index",
          "full_description": "routing /api/v1/projects/:project_name/reports/rspec routes GET /api/v1/projects/:project_name/reports/rspecto rspec_reports#index",
          "status": "passed",
          "file_path": "./spec/routing/routes_spec.rb",
          "line_number": 59,
          "run_time": 0.001341,
          "pending_message": null,
          "exception": null
        },
        ...
      ]
      "summary": {
        "duration": 0.747558,
        "example_count": 53,
        "failure_count": 3,
        "pending_count": 0,
        "errors_outside_of_examples_count": 0
      },
      "summary_line": "53 examples, 3 failures",
    }
  }
}
```

To view an existing RSpec report:
```json
GET  /api/v1/projects/:project_name/reports/rspec/:id
```
