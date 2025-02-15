# Create user
mongosh mongodb://mongo-0.db-svc:27017/weblog -u admin -p P@ssw0rd --authenticationDatabase admin ./adduser.js

# Create collection & insert initial data
mongosh mongodb://mongo-0.db-svc:27017/weblog -u admin -p P@ssw0rd --authenticationDatabase admin ./insert.js
