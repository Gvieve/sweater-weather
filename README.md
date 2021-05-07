# Sweater Weather

This is a backend API that provides the foundation for a weather application. This application can be used to to communicate with a frontend application using five API JSON endpoints. It stores only user information in the database, and all of the weather and location based data are consumed via third party APIs.

### Created by:
- [Genevieve Nuebel](https://github.com/Gvieve) | [LinkedIn](https://www.linkedin.com/in/genevieve-nuebel)

#### Built With
* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)

This project was tested with:
* RSpec version 3.10
* [Postman](https://www.postman.com/) Explore and test the API endpoints using Postman, and use Postman’s CLI to execute collections directly from the command-line.

## Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
- [Endpoints](#endpoints)   
- [Database Schema](#database-schema)  
- [Testing](#testing)
- [How to Contribute](#how-to-contribute)
- [Roadmap](#roadmap)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

### Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system. Endpoints can be added. If you plan to use this engine with the frontend web application, if the endpoints are changed subsequent updates will be necessary on the Frontend repository code.

#### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. _Please ensure you install the version of ruby noted above._

* __Rails__
  ```sh
  gem install rails --version 5.2.5
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres app.

* __Mapquest API__
  - Visit the [mapquest developer tools](https://developer.mapquest.com/) to create an account and follow the instructions to obtain an api key.

* __OpenWeatherMap API__
  - Visit the [OpenWeatherMap API](https://openweathermap.org/api) to create an account and follow the instructions to obtain an api key.

* __Unsplash API__
  - Visit the [Unsplash developers tools](https://unsplash.com/developers) to create an account and follow the instructions to obtain an api key.

#### Installing

1. Clone the repo
  ```
  $ git clone https://github.com/Yardsourcing/yardsourcing-frontend
  ```

2. Bundle Install
  ```
  $ bundle install
  ```

3. Create, migrate and seed rails database
  ```
  $ rails db:{create,migrate}
  ```

4. Set up Environment Variables:
  - run `bundle exec figaro install`
  - add the below variable to the `config/application.yml` for the existing third party API service calls.
  ```
  mapquest_key: <your_api_key>
  open_weather_key: <your_api_key>
  unsplash_key: <your_api_key>
  ```
  GET /api/v1/forecast
  GET  /api/v1/backgrounds
  POST /api/v1/users
  POST /api/v1/sessions
  POST /api/v1/road_trip

### Endpoints
| HTTP verbs | Paths  | Used for |
| ---------- | ------ | --------:|
| GET | /api/v1/forecast | Get the forecast for a city, state. It includes the forecast for current, 48 hours and 7 days. |
| GET | /api/v1/backgrounds  | Get an image that can be used as a background using city, state |
| POST | /api/v1/users  | Create a new user and generate a unique api key |
| POST | /api/v1/sessions  | Login an existing user |
| POST | /api/v1/road_trip | Create a road trip and provides the forecast for the destination upon arrival|


#### API Documentation
Please see the [API Documentation](https://github.com/Yardsourcing/yardsourcing-engine/blob/main/APIContract.md) for detailed information about each endpoint, existing parameters, and expected json data input and output.

### Database Schema
<p style="text-align:center;"><img src="Schema_yardsourcing.png" height="350"></p>

### Testing
##### Running Tests
- To run the full test suite run the below in your terminal:
```
$ bundle exec rspec
```
- To run an individual test file run the below in tour terminal:
```
$ bundle exec rspec <file path>
```
for example: `bundle exec rspec spec/requests/api/v1/forecast/index_spec.rb`

#### Postman
- To run postman endpoints, start the Sweater Weather application locally
    `rails s`
- Utilize this [link](https://www.getpostman.com/collections/55f23801919b398512bf) to download the postman suite

### How to Contribute

In the spirit of collaboration, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this API they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request

### Roadmap

See the [open issues](https://github.com/Gvieve/sweater-weather/issues) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.

### Contributors
  See also the list of
  [contributors](https://github.com/Gvieve/sweater-weather/graphs/contributors)
  who participated in this project.

### Acknowledgments
  - My amazing and supportive Instructors at [Turing School of Software and Design](https://turing.io/):
    * Ian Douglas
    * Alex Robinson
    * Tim Tyrell
