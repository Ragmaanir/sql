require "../repository_spec"

describe Repository do
  db = MockDB.new
  repo = Repository.new(db)

  describe "#exec" do
    context "with paramsless Query" do
      it "calls DB#exec with valid sql and no params" do
        result = repo.exec(Query(User).new.update.set("foo = 42"))

        db.latest_exec_sql.should eq <<-SQL
        UPDATE users SET foo = 42
        SQL

        db.latest_exec_params.not_nil!.should be_empty
      end
    end

    context "with params Query" do
      it "calls DB#exec with valid sql and params" do
        result = repo.exec(Query(User).new.update.set(active: true))

        db.latest_exec_sql.should eq <<-SQL
        UPDATE users SET activity_status = ?
        SQL

        db.latest_exec_params.should eq [true]
      end
    end
  end
end
