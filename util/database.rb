require "sqlite3"

module Util
  class Database
    attr_accessor :db

    def initialize(db_file_name)
      @db_file_name = db_file_name
      @db = SQLite3::Database.new(@db_file_name)
      @db.results_as_hash = true
    end

    def query(sql)
      rows = []
      @db.execute(sql) do |row|
        rows << row
      end
      return rows
    end
  end
end
