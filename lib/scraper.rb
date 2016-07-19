module Scrappy
  class Scraper
    URL = "aHR0cDovL2NsYXNzaWZ5Lm9jbGMub3JnL2NsYXNzaWZ5Mi9DbGFzc2lmeURlbW8/c2VhcmNoLXN0YW5kbnVtLXR4dD0lcyZzdGFydFJlYz0w"

    def initialize
      @sleep_time = (3..7).to_a
      @changer = [false, true, false, false, false]
    end

    def start isbns, &block
      Array(isbns).each do |isbn|
        page = agent.get url(isbn)
        block.call PageParser.new(page)
        config_next_request
      end
    end

    private

    def agent
      set_agent unless @agent
      @agent
    end

    def set_agent
      @agent     = Mechanize.new
      @agent.log = Logger.new "log/mechanize.log"
      change_user_agent
      @agent
    end

    def url str
      Base64.decode64(URL) % str
    end

    def change_user_agent
      @agent.user_agent = random_agent
    end

    def config_next_request
      sleep @sleep_time.sample
      change_user_agent if @changer.sample
    end

    def random_agent
      Mechanize::AGENT_ALIASES[(Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample]
    end
  end
end
