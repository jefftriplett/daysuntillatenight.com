# Days until late night

# Development

The site can be built and seen by running the following command:

    $ grunt

# Updating for the next year

1. Edit index.html to replace the hardcoded date.
2. Edit js/main.js with the new date.
3. `$ grunt`

# Deployment

Deployment is done by a basic shell script that builds the site and
deploys the built directory to the server:

    $ bash bin/deploy
