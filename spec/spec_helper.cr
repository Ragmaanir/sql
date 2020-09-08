require "spec"
require "../src/onyx-sql"

alias BulkQuery = Onyx::SQL::BulkQuery

Log.setup(:warn)

# Log.setup do |c|
#   backend = Log::IOBackend.new

#   c.bind "onyx.sql.repository.*", :debug, backend
# end
