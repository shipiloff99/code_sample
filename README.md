# Backend support engineer coding challenge

General Cobot concepts:

- Cobot customers are coworking spaces, so each customer is modeled as a `Space` on Cobot.
- Spaces have members, each of which is modeled as a `Membership`.
- Spaces have plans which determine how much each member has to pay.
- A plan is associated with each member via the `plan_id` when the membership is created.
- Memberships are invoiced regularly. One of the relevant fields is
  `first_invoice_at`, which determines when a member's first invoice is sent.
- Memberships can be created/imported before they start. The `starts_at` field
  determines when a membership actually starts.

You can find the Cobot API docs at https://www.cobot.me/api-docs.

Before you start:

This is a stripped-down Rails app to help save you time for your implementation.

- API credentials are hard-coded and won't work against the live Cobot system (see `ImportService`)
- No user authentication
- No CSS
- There is a class called `ImportService` that will take care of actually sending data to the Cobot API

The intended audience for this app is our internal support team.
You should spend not more than 2h on the tasks below.

Your tasks are as follows:

## Implement Excel upload

Our customers regularly want us to add members to their account in bulk. For this, they send us Excel files with lists of people. So far we've been doing this by hand, but now we want to automate this task. You are tasked with implementing an app that allows our support team to upload the Excel files sent by our customers and which then automatically imports the members into their Cobot account.

- Add controllers, views, etc. to let a user upload an Excel file (see the `fixtures` folder - you can assume that all Excel files will have the same structure as the one in the repo).
- You must not make any changes to the Excel file.
- Add at least one test that demonstrates uploading a file and posting it to the API.
  - We recommend using [Capybara](https://github.com/teamcapybara/capybara/blob/3.34_stable/README.md) to upload the file in the test.
  - You can use [Webmock](https://github.com/bblimke/webmock/blob/master/README.md) to mock and assert that the data was sent to the API.
  - [RSpec](https://relishapp.com/rspec) is already set up so we recommend using it for testing.
- Create a new git branch and submit your work by creating a PR aginst the `main` branch of this repository on GitHub.
- You are only done once your PR's CI checks pass on GitHub Actions (see _.github/workflows/rubyci.yml_).

### Additional information

- The Excel file contains a column "Plan" which contains plan names, but the endpoint expects plan ids. You can pull plans via [our plans endpoint](https://www.cobot.me/api-docs/plans#list-plans).
- To interact with the API you can use the [Cobot Client](https://github.com/cobot/cobot_client) that is already part of the Gemfile.

The `/membership_import` import endpoint (see `ImportService`) is a private endpoint and not publicly documented. It expects the following attributes as JSON:

```json
{
  "membership": {
    "address": {
      "name": "Mike Smith",
      "company": "Company",
      "full_address": "1189 Kafvuh Drive"
    },
    "phone": "(341) 638-5789",
    "email": "mail@domain.com",
    "plan": {
      "id": "59774b78-835e-5a76-a551-59efc2e1e3c5"
    },
    "starts_at": "2015/01/01",
    "first_invoice_at" "2015/01/10"
  }
}
```

- `address` is required
  - Either `name` or `company` are required
  - `full_address` is required
- `plan` -> `id` is required
- `starts_at` is required
- `first_invoice_at` is required
- Dates must be formatted as `YYYY/MM/DD`

For any errors the endpoint will return a 422 HTTP status and a JSON document describing the error:

```json
{
  "errors": {
    "address": ["Name or company missing"]
  }
}
```
