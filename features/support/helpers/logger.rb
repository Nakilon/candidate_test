require_relative "colored_string"
def logger_initialize
  $logger = Logger.new(STDOUT)
  $logger.formatter = proc do |severity, datetime, _progname, msg|
    colored_string(
      "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity} -- #{msg}\n",
      {
        'UNKNOWN' => :gray,
        'FATAL' => :bg_red,
        'ERROR' => :red,
        'WARN' => :brown,
        'INFO' => :blue,
        'DEBUG' => :bg_gray,
      }.fetch(severity){ raise "Unknown severity #{severity.inspect}" }
    )
  end
end
