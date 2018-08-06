# Instructions to setup FriendlyManagement

## For demo purpose, you can use this url (replace with `http://localhost:3000/`)

```
https://friendly-management.herokuapp.com/
```

## Deployment

##### Using Docker Compose
```
$ docker-compose run web rails new . --force --database=postgresql
$ docker-compose build
$ docker-compose run web rake db:create
$ docker-compose up
```

#### 1. As a user, I need an API to create a friend connection between two email addresses.

```
POST http://localhost:3000/friendships
```

```JSON
{
	"friends":
	[
		"andy@example.com",
		"john@example.com"
	]
}
```

base on statement above, if the user (andy) and his friend (john) are not exists in the friendship table in database, it will create the relationship.

Here is the JSON response if the request is success

```JSON
{
    "success": true
}
```

if the relationship is already exists, it will return

```JSON
{
    "message": "Relationship already establish"
}
```

#### 2. As a user, I need an API to retrieve the friends list for an email address.

```
GET http://localhost:3000/friendlist?email=andy@example.com
```

base on statement above, if the email address is found in user list, it will return:

```JSON
{
    "success": true,
    "friends": [
        "john@example.com"
    ],
    "count": 1
}
```

but if the email is not found, it will return

```JSON
{
    "message": "email not found"
}
```

#### 3. As a user, I need an API to retrieve the common friends list between two email addresses.

```
GET http://localhost:3000/common?friends=["andy@example.com","lisa@example.com"]
```

lisa should be exists first in db (first step), coz need to create relationship to return common friend list

here is the respond

```JSON
{
    "success": true,
    "friends": [
        "john@example.com"
    ],
    "count": 1
}
```

if the user email in request is not found, it will return

```JSON
{
    "message": "user email not found"
}
```

#### 4. As a user, I need an API to subscribe to updates from an email address.

```
POST http://localhost:3000/subscribe
```

```JSON
{
	"requestor": "andy@example.com",
	"target": "john@example.com"
}
```

if success, it will return

```JSON
{
    "success": true
}
```

but if `requestor` email is not exists, it will return

```JSON
{
    "success": false,
    "message": "Requestor Email not found"
}
```

but if `target` email is not exists, it will return

```JSON
{
    "success": false,
    "message": "Target Email not found"
}
```

or if both `requestor` & `target` email is not exists, it will return

```JSON
{
    "success": false,
    "message": "Both Email not found"
}
```

and if `requestor` email is similar with `target` email, it will return

```JSON
{
    "success": false,
    "message": "You can't subscribe yourself"
}
```

#### 5. As a user, I need an API to block updates from an email address.

```
PUT http://localhost:3000/block
```

```JSON
{
	"requestor": "andy@example.com",
	"target": "lisa@example.com"
}
```

if success, it will return,

```JSON
{
    "success": true
}
```

or if either `requestor` or `target` email is not exists, it will return

```JSON
{
    "success": false,
    "message": "email not found"
}
```

#### 6. As a user, I need an API to retrieve all email addresses that can receive updates from an email address.

```
POST http://localhost:3000/receive_update
```

```JSON
{
	"sender": "john@example.com",
	"text": "Hello World! kate@example.com"
}
```

if success, it will return,

```JSON
{
    "success": true,
    "recipients": [
        "kate@example.com"
    ]
}
```

if `sender` email is not found, it will return,

```JSON
{
    "success": false,
    "message": "Sender email not found"
}
```
