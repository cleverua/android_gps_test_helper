require 'net/telnet'

module AndroidEmulator

  CONNECTION_OPTIONS = {
    'Timeout' => 3,
    'Port'    => 5554,
    'Prompt'  => /(OK|\AKO.*\z)/
  }

  class Connection

    def initialize(connection)
      @emulator_connection = connection
    end

    def wait(secs)
      puts "> sleeping for #{secs} secs ..."
      sleep secs
    end

    def geofix(attrs)
      action = 'geo fix ' + if attrs.is_a? Hash
        attrs[:alt] = 0 unless attrs[:alt]
        "#{attrs[:lon]} #{attrs[:lat]} #{attrs[:alt]}"
      else
        # if attrs == "-87.651891 41.86953", then append it with zero altitude
        attrs += ' 0' if attrs.split(' ').size == 2
        attrs # e.g. "-87.651891 41.86953 0"
      end
      puts "> execute \"#{action}\""
      @emulator_connection.cmd(action)
    end

    def close
      @emulator_connection.close if @emulator_connection # just in case
    end

  end

  def self.connect(options = {}, &block)
    options = CONNECTION_OPTIONS.merge(options)
    c = Connection.new(Net::Telnet::new(options))
    c.instance_eval &block
    puts '> job is done, exiting ...'
  rescue => e
    puts "> Got error: #{e}. Exiting ..."
  ensure
    c.close
  end

end