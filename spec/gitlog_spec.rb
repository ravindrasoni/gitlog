require 'gitlog'

describe GitLog::Log do
  it "check same log" do
    expect(GitLog::Log.dolog("Broccoli")).to eql("Broccoli")
  end
end