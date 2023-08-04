# README

This README would normally document whatever steps are necessary to get the
application up and running.

To run this app on your local machine, follow the subsequent steps:

### 1. Install the correct versions of Ruby, Rails, and other dependencies

This app was created with:

* *ruby 3.2.1*

* *rails 6.1.7.3*

* *postgresql 15.3-1*

* *node v16.20.1*

* *yarn 1.22.19*

* *elasticsearch 7.17.7*

Make sure you have the correct versions of the above-mentioned software installed on your local system.

### 3. Install the necessary dependencies

```sh 
bundle install && yarn install
```

### 4. Create, migrate, and seed the databases

```sh 
rails db:setup
```

### 5. Create the elasticsearch indices

Make sure that elasticsearch is running at `localhost:9200`

Open the rails console:

rails c

Then, inside rails console, run the following commands:

Resturant.import force: true

### 6. Finally, run the server

rails s

Then for direct login,
admin_email : sumitava@example.com

### 6. To add latitude and longitude in form
https://www.google.com/maps/preview/@#{latitude},#{longitude},10z

take from here