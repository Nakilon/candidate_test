# frozen_string_literal: true

require_relative 'helpers/logger'

require 'rest-client'
require_relative 'helpers/rest_wrapper'

require 'capybara/cucumber'
def browser_setup(browser)
  case browser
  when 'chrome'
    require "capybara/cuprite"
    Capybara.javascript_driver = :cuprite
    Capybara.default_driver = :cuprite
    Capybara.current_driver = :cuprite
    Capybara.register_driver :cuprite do |app|
      Capybara::Cuprite::Driver.new(app, {
        browser_options: {"no-sandbox": nil},
        "headless": "darwin" != Gem::Platform.local.os,
      } )
    end
    Capybara.save_path = Dir.pwd + '/features/tmp/'
  when 'firefox'
    require 'selenium-webdriver'
    Capybara.register_driver :firefox_driver do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      Selenium::WebDriver::Firefox.driver_path = 'configuration/geckodriver'
      profile['browser.download.folderList'] = 2 # custom location
      profile['browser.download.dir'] = Dir.pwd + '/features/tmp/'
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, text/xml'
      profile['pdfjs.disabled'] = true
      Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, port: Random.rand(7000..7999))
    end
    Capybara.default_driver = :firefox_driver
  else
    raise "bad browser #{browser.inspect}"
  end
end
browser_setup('chrome')

configuration = YAML.load_file 'configuration/default.yml'
$rest_wrap = RestWrapper.new url: 'https://testing4qa.ediweb.ru/api',
                             **configuration[:credentials]
logger_initialize
