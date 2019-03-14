# testRouting

### Requirements

* ActiveRecord
* Sqlite3
* Ruby version 2.3+

### Run

To use the project just run on your terminal
```
$ ruby scheduler.rb
```

### Files

There are multiple files:
* _seeds.rb:_ create a database on memory and populate the schemas with random information
* model.rb: contains the models used
* constant.rb: includes constants used to populate the database
* scheduler.rb: contains the logic used to solve the assignation problem.

The program create data for one day and use that data to solve the assignation problem for that day. 

### Assumptions

* In this case I assume that every driver has his own vehicle and each vehicle has a driver
