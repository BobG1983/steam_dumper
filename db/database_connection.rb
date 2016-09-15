require 'sequel'
require 'singleton'

# Singleton class for handling DB connection
class DatabaseConnection
  include Singleton

  def database
    @database ||= new_database_connection
  end

  def new_database_connection(use_test = true)
    @database = if use_test
                  Sequel.connect(test_db_name)
                else
                  Sequel.connect(production_db_name)
                end
  end

  def test_db_name
    'sqlite://./db/test.db'
  end

  def production_db_name
    'sqlite://./db/steam_store.db'
  end

  def database_name
    test_db_name
  end
end

DB = DatabaseConnection.instance.database
