# Light Words
Words for the Alias (Crocodile) game.

## Description
The application simply shows you a card with five random words - you should explain them.

As an administrator, you can add new words and modify existing cards. Visit http://lightwords.ru/admin page.
Use the `SECRET_KEY_BASE` variable to set the password for accessing the admin panel.

## Launch

Install dependencies:
```bash
rbenv install
bundle install
yarn install
```

Set environment variables:
```bash
export RAILS_ENV='production'
export RAILS_SERVE_STATIC_FILES='true'
export RAILS_MASTER_KEY='123..'
export SECRET_KEY_BASE='admin-password-123'
```

Set up the database and start the server:
```bash
rails db:setup
rails server
```

Or run via docker:
```bash
docker-compose up
```
