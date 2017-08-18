require 'pg'

task :default do
  conn = PG.connect(dbname: 'postgres')
  conn.exec("CREATE DATABASE ips_monitor")
  conn.exec("CREATE TABLE issues (
      id        integer PRIMARY KEY,
      user_ids  integer[]
  );")
end