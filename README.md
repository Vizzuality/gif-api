# Description
This is the API and Back-Office application for Green Infrastructures for Flood Management. 

This new online platform will serve as a dynamic digital repository of nature-based adaptation projects from around the world and from different organizations. This platform will be a place for collating current and past projects, as well as a place to keep track of future projects relevant to the topic. Additionally, the platform will serve as a hub for guidance on how to design a nature-based adaptation project, including lessons learned and best practices. This guidance is being developed by partner organizations and will be agreed upon before being hosted on the platform. 

### URL
34.200.136.32

### Ruby version
2.4.0

### System dependencies
PostgreSQL

### Configuration
Rename .env.sample to .env and fill accordingly 

###  Database creation
run `rake db:create`

###  Database initialization
run `rake db:migrate db:seed`

###  How to run the test suite
run `rspec`

### Deployment instructions
run `cap production deploy`