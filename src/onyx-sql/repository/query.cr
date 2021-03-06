module Onyx::SQL
  class Repository
    # Call `db.query(sql, params)`.
    def query(sql : String, params : Enumerable(DB::Any)? = nil)
      sql = prepare_query(sql)

      log_with_timing("[#{driver}] #{sql}") do
        if params && !params.empty?
          db.query(sql, args: params)
        else
          db.query(sql)
        end
      end
    end

    # Call `db.query(sql, *params)`.
    def query(sql : String, *params : DB::Any)
      query(sql, params)
    end

    # Call `db.query(sql, params)` and map the result to `Array(T)`.
    def query(klass : T.class, sql : String, params : Enumerable(DB::Any)? = nil) : Array(T) forall T
      rs = query(sql, params)
      klass.from_rs(rs)
    end

    # Call `db.query(sql, *params)` and map the result to `Array(T)`.
    def query(klass : T.class, sql : String, *params : DB::Any) : Array(T) forall T
      query(klass, sql, params)
    end

    # Call `db.query(*query.build)` and map the result to `Array(T)`.
    def query(query : Query(T)) : Array(T) forall T
      query(T, *query.build(postgresql?))
    end

    # ditto
    def query(query : BulkQuery(T)) : Array(T) forall T
      query(T, *query.build(postgresql?))
    end
  end
end
