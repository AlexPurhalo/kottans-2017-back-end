### Usage
    $ bundle install
    $ sequel -m db/migrations sqlite://db/database.db
    $ foreman start
    
### Work with DB
    $ racksh
    > User.create(username: "alex", bcrypted_password: "$2a$04$u2sIANr.4hkB2ruF9YQJkOAhvc1EALJneSXZhJjEdQvRl2CeF.7zK")
    
### Testing
    $ sequel -m db/migrations sqlite://db/test.db
    $ rspec
    
#### CI (Continuous Integration)
[link to travis](https://travis-ci.org/AlexPurhalo/kottans-2017-back-end)
