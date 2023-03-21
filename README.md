# Mailbox

## Setup
```
bundle exec rails db:setup
bundle exec rails s
bundle exec sidekiq
```
## ENV
```
GMAIL_CLIENT_ID=
GMAIL_CLIENT_SECRET=
```

# Docs
## Description
The initial idea is to first enable user to login with google oauth2. Since the code authorization with user consent is required `devise` gem is used in combination with `omniauth` just for the sake of simplicity so we're able to test the client side as well, otherwise we would authenticate on the client side and hand over a jwt to keep our web service stateless.

After successful authentication a sidekiq job is scheduled asynchronously to perform a mailbox sync.

## Worker - Import emails

  In order to sync emails for a user we need to fetch them from gmail api. There are two types of the sync.
* Full sync - used for the first-time login
  - this means when user authenticates with our service for the very first time we need to call `messages.list` multiple times using pagination in batches in order to fetch old messages
  - to determine whether it's a full sync we simply check if there are any messages persisted for a particular user in the db
* Partial sync
  - to fetch the messages starting from a particular date or state we need to call `history.list` endpoint providing it with the last history id persisted in the db
  - this is not the best solution since history records are typically available for a short time period, so in our case it could potentially be very slow to sync the mailbox
  - the better solution would be using [push notifications](https://developers.google.com/gmail/api/guides/push) since we would get the messages almost instantly and there are also two options - push and pull type of notification

After each import is done, regardless of the type, a worker is rescheduled to keep the mailbox in sync. The access token is used to check whether a user has an active session so sync could be cancelled eventually, but again in the world of stateless web services this would be a bad solution thus we would need to implement some kind of tracking a user activity on the mailbox page in case we want to go with history approach rather than push notifications.

## Error handling
There are two types of errors we need to handle - internal and external (3rd party). `UnrecoverableError` is introduced to break the mail sync if anything goes wrong causing our sync not being retryable e.g. if user is missing in the db or in case authorization fails on gmail calls. All other errors are supposed to retry a job.

## Routes
* API
  - `/api/mails` - web service endpoint for performing a search on mailbox
* Client
  - `/mails` - used for testing the search
  - `/sign_in`, `sign_out` - used for session handling
  - `/users/auth/google_oauth2/callback` - handling the successful authorization

## Classes
For Classes documentation please refer to [doc](./doc/).

## Improvements
Some improvements are done to make the service stateless. 
Please check https://github.com/zametica/mailbox/tree/improvements.
