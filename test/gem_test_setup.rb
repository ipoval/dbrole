GemTestSetup = class GemTestSetupClass
  attr_accessor :shardB_master_file
  attr_accessor :shardB_replica_file

  def initialize
    @shardB_master_file = `mktemp`
    @shardB_replica_file = `mktemp`

    puts "\e[32mTOUCH SQLITE DB FILE #{@shardB_master_file}\e[0m"
    puts "\e[32mTOUCH SQLITE DB FILE #{@shardB_replica_file}\e[0m"
  end

  # unlink temp files
  def finalize
    `rm #{@shardB_master_file}`
    `rm #{@shardB_replica_file}`

    puts "\e[32mUNLINK SQLITE DB FILE #{@shardB_master_file}\e[0m"
    puts "\e[32mUNLINK SQLITE DB FILE #{@shardB_replica_file}\e[0m"
  end

  new
end
