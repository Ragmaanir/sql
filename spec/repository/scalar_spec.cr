require "../repository_spec"

describe Repository do
  db = MockDB.new
  repo = Repository.new(db)

  describe "#scalar" do
    context "with paramsless Query" do
      it "calls DB#scalar with valid sql and no params" do
        result = repo.scalar(Query(User).new.update.set("foo = 42").returning(:uuid))

        db.latest_scalar_sql.should eq <<-SQL
        UPDATE users SET foo = 42 RETURNING users.uuid
        SQL

        db.latest_scalar_params.not_nil!.should be_empty
      end
    end

    context "with params Query" do
      it "calls DB#scalar with valid sql and params" do
        result = repo.scalar(Query(User).new.update.set(active: true).returning(:active))

        db.latest_scalar_sql.should eq <<-SQL
        UPDATE users SET activity_status = ? RETURNING users.activity_status
        SQL

        db.latest_scalar_params.should eq [true]
      end
    end
  end
end
