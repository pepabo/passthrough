require "net/ssh/gateway"

module Passthrough
  @conns = {}
  @m     = Mutex.new

  def self.create(name, gateway_host, gateway_user, ssh_options = {})
    @m.synchronize {
      @conns[name] = Connection.new(gateway_host, gateway_user, ssh_options)
    }
  end

  def self.set(name, key, value)
    @m.synchronize {
      conn_of(name).set(key, value)
    }
  end

  def self.get(name, key)
    @m.synchronize {
      conn_of(name).get(key)
    }
  end

  def self.open(name)
    @m.synchronize {
      conn_of(name).open
    }
  end

  def self.close(name)
    @m.synchronize {
      conn_of(name).close
    }
  end

  def self.conn_of(name)
    c = @conns[name]
    unless c
      raise ArgumentError, "no such connection: #{name}"
    end
    c
  end

  class Connection
    def initialize(gateway_host, gateway_user, ssh_options)
      @gateway_host  = gateway_host
      @gateway_user  = gateway_user
      @ssh_options   = ssh_options
      @params        = {}

      @original_host
      @original_port
    end

    def set(key, value)
      @params[key] = value
    end

    def get(key)
      @params[key]
    end

    def open
      @conn = Net::SSH::Gateway.new(@gateway_host, @gateway_user, @ssh_options)
      port = @conn.open(@params[:host], @params[:port])

      # Replace the destination with local gateway
      @original_host = @params[:host]
      @params[:host] = '127.0.0.1'
      @original_port = @params[:port]
      @params[:port] = port
    end

    def close
      # Recover original destination
      @params[:host] = @original_host
      @original_host = nil
      @params[:port] = @original_port
      @original_port = nil

      @conn.shutdown!
    end
  end
end
