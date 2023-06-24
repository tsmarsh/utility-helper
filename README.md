# Utility Helper

This is a tech demo to show how to configure [GridQL](https://github.com/tsmarsh/gridql) to be an actual application.

Like all good demos this would actually scratch a real itch that I have at work, but all names etc have been changed to protect the guilty.


Hopefully you will see around 15 'forms' arranged into roughly 30 microservices and a probably a similar number of supporting FaaS. 

## Ground Rules

### Developer workflow

1. [x] A developer must be able to clone this, 
2. [x] Run `docker build -t <tag> .` 
3. [x] run `docker-compose up` and see
   1. [x] mongo start
   2. [x] kubernetes start
   3. [x] mongo-event-builders start
4. [x] Run `node index` and have the application run against compose
5. [x] Run `docker run -t -v "$(pwd)/docker_environment:/app/config/environment" -p 3000:3000 <tag>` and have the image run against compose
6. [x] Query the application [http://localhost:3030](http://localhost:3030) and be presented with a screen that describes what to do next
7. [ ] run 'make performance' and get a sense of local performance

As you can see most of that is work that has yet to happen. Leave me alone.

### Releasing

1. [ ] The image created during the developer workflow must be releasable
   1. that is, it should be identical to the image created by the pipeline.
2. [ ] There will be a github action that releases the app into GCP
3. [ ] GCP itself will probably be configured in a different repo?!
4. [ ] There will be a performance suite that runs in the cloud against a 'real' environment.

