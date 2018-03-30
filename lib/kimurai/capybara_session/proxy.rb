module Capybara
  class Session
    def set_proxy(proxy)
      if ["http", "socks5"].include?(proxy[:type])
        case driver_type
        when :poltergeist
          Kimurai::Logger.debug "Session: setting #{proxy[:type]} proxy: #{proxy[:ip]}:#{proxy[:port]}"
          driver.set_proxy(proxy[:ip], proxy[:port], proxy[:type], proxy[:user], proxy[:password])
        when :mechanize
          # todo: add socks support
          # http://www.rubydoc.info/gems/mechanize/Mechanize:set_proxy
          if proxy[:type] == "http"
            Kimurai::Logger.debug "Session: setting http proxy: #{proxy[:ip]}:#{proxy[:port]}"
            driver.browser.agent.set_proxy(proxy[:ip], proxy[:port], proxy[:user], proxy[:password])
          else
            Kimurai::Logger.debug "Session: mechanize driver only supports http proxy. Skipped this step."
          end
        when :selenium
          message = "Session: can't set proxy: Selenium don't allow to set proxy dynamically. " \
            "Only while creating a new instance. Skipped this step."
          Kimurai::Logger.debug message
        end
      else
        raise "Session: Wrong type of proxy #{proxy[:type]}. Allowed only http and sock5."
      end
    end
  end
end
