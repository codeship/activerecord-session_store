require 'helper'
require 'active_record/session_store'

module ActiveRecord
  module SessionStore
    class SessionTest < ActiveSupport::TestCase

      attr_reader :session_klass

      def setup
        super
        ActiveRecord::Base.connection.schema_cache.clear!
        Session.drop_table! if Session.table_exists?
        @session_klass = Class.new(Session)
      end

      def test_data_column_name
        # default column name is 'data'
        assert_equal 'data', Session.data_column_name
      end

      def test_table_name
        assert_equal 'sessions', Session.table_name
      end

      def test_create_table!
        assert !Session.table_exists?
        Session.create_table!
        assert Session.table_exists?
        Session.drop_table!
        assert !Session.table_exists?
      end

      def test_find_by_session_id
        Session.create_table!
        session_id = "10"
        s = session_klass.create!(:data => 'world', :session_id => session_id)
        t = session_klass.find_by_session_id(session_id)
        assert_equal s, t
        assert_equal s.data, t.data
        Session.drop_table!
      end

      def test_loaded?
        Session.create_table!
        s = Session.new
        assert !s.loaded?, 'session is not loaded'
      end
    end
  end
end
