# C&S Slack inviter

Forked from [tech404/inviter](https://github.com/tech404/inviter), the application behind the [tech404 automatic invitation system](http://tech404.io).

## Usage

### `POST /invitations`

To enqueue an invitation request:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"andy@example.com\"}" \
  http://localhost:3000/invitations
```

The route is meant to be used by a JavaScript client. You can whitelist CORS origins in `config/initializers/cors.rb`.

## Development

### Prerequisites

* PostgreSQL: `brew install postgresql`
* Redis: `brew install redis` or `docker run -d --rm redis` and prepend `rails`
    with `REDISTOGO_URL=redis://localhost:6379` to set the required envvar.

### Required Configuration

Configuration items are stored in environment variables.

* `SLACK_SUBDOMAIN`: e.g., tech404 for tech404.slack.com
* `SLACK_TOKEN`: an API token for an administrator of the organization
* `SIDEKIQ_USERNAME`: username for the sidekiq administration area
* `SIDEKIQ_PASSWORD`: password for the sidekiq administration area

## Deployment

Deployed on Heroku. In production, we run a puma process in the same dyno as a sidekiq worker. It's a hack to keep it free.

