class DeadOrAlive::ControllerRepo
  def controller!(controller,action,ts = Time.now)
    subjects(controller,action,ts).each(&:incr!)
  end

  def worker!(worker, ts = Time.now)
    WorkerRecord.new(self.class.redis, worker, nil, ts).incr!
  end

  def workers(since=1.week)
    iterate_and_sort(range(since),WorkerRecord)
  end

  def actions(since=1.week)
    iterate_and_sort(range(since),ActionRecord)
  end

  def controllers(since=1.week)
    iterate_and_sort(range(since),ControllerRecord)
  end

  protected

  def subjects(controller,action,ts)
    [ControllerRecord, ActionRecord].map do |model|
      model.new(self.class.redis, controller, action, ts)
    end
  end

  def iterate(range, klass)
    range.map{|t| klass.new(self.class.redis,nil, nil, t) }.inject(Hash.new(0)) do |memo, rec|
      rec.find.inject(memo) do |acc, (key, value)|
        memo[key]+=value.to_i
        memo
      end
    end
  end

  def iterate_and_sort(range,klass)
    iterate(range,klass).to_a.sort_by(&:last).reverse.map do |(k,v)|
      ReportItem.new(k,v)
    end
  end

  def range(since)
    t = (Time.now - since).to_date
    t.upto(Time.now.to_date).to_a
  end

  class ReportItem < Struct.new(:name, :count)
  end

  class BaseRepo < Struct.new(:redis,:controller, :action, :ts)
    def incr!
      redis.zincrby key,1, member
      redis.expire key, 1.year.to_i
    end

    def find
      redis.zrangebyscore(key, "0", "+inf", :with_scores => true)
    end

    def timestamp
      ts.strftime("%Y-%m-%d")
    end
  end

  class WorkerRecord < BaseRepo
    def key
      "alive:#{timestamp}:workers"
    end

    def member
      controller
    end
  end

  class ControllerRecord  < BaseRepo
    def key
      "alive:#{timestamp}:controllers"
    end

    def member
      controller
    end
  end

  class ActionRecord < BaseRepo
    def key
      "alive:#{timestamp}:actions"
    end

    def member
      [controller,action].join("#")
    end
  end

  class << self
    def redis
      DeadOrAlive.redis
    end
  end
end
