# Development

Build docker image of app:

```sudo docker build . -t 'uchi-test:0.1'```

Launch docker container:

```sudo docker run --name utc -p 3000:3000 uchi-test:0.1```

Open in browser: http://localhost:3000

# Deployment

Push to Heroku:

```sudo heroku container:push web -a uchi-test```

Release on Heroku:

```sudo heroku container:release web -a uchi-test```

App can be found here: https://uchi-test.herokuapp.com