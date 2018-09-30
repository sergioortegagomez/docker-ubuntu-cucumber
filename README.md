# Docker Ubuntu 18.10 Mate Desktop with Cucumber

Docker container for automatize your cucumber test in browser Chrome and FireFox with screenshots.

## Libraries preload.

- [cucumber](https://rubygems.org/gems/cucumber)
- [gherkin](https://rubygems.org/gems/gherkin)
- [capybara](https://rubygems.org/gems/capybara)
- [pry](https://rubygems.org/gems/pry)
- [rspec](https://rubygems.org/gems/rspec)
- [selenium-webdriver](https://rubygems.org/gems/selenium-webdriver)
- [selenium-cucumber](https://rubygems.org/gems/selenium-cucumber)
- [cucumber-api](https://rubygems.org/gems/cucumber-api)
- [cucumber-screenshot](https://rubygems.org/gems/cucumber-screenshot)

## Generate a test skeleton

```console
- ./test/
  - features/
    - mytest.feature
    - screenshot/
    - step_definitions/
    - support/
      - env.rb
      - cucumber-screenshot.rb
```

### env.rb file

Chrome example:

```ruby
require 'selenium-webdriver'
require 'selenium-cucumber'

caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--disable-web-security", "--no-sandbox" ]})

$driver = Selenium::WebDriver.for :remote, desired_capabilities: caps
```

FireFox example:

```ruby
require 'selenium-webdriver'
require 'selenium-cucumber'

$driver = Selenium::WebDriver.for :remote, desired_capabilities: :firefox
$driver.manage().window().maximize()
```

### cucumber-screenshot.rb file

```ruby
begin
  require 'cucumber_screenshot'
  World(CucumberScreenshot::World)

  After do |scenario|
    if scenario.failed?
      screenshot
    end
  end

  AfterStep('@screenshot') do |scenario|
    if screenshot_due?
      screenshot
    end
  end
  rescue Exception => e
    puts "Snapshots not available for this environment.\n"
end
```

### Your features test

By using predefined steps you can automate your test cases more quickly, more efficiently and without much coding.

The predefined steps are located [here](https://github.com/selenium-cucumber/selenium-cucumber-ruby/blob/master/doc/canned_steps.md)

## Run in docker

```console
docker run --volume ./test:/opt/cucumber sergioortegagomez/docker-ubuntu-cucumber
```

## Run in docker-compose

```yml
services:
  test:
    image: sergioortegagomez/docker-ubuntu-cucumber
    volumes:
      - ./test:/opt/cucumber
```

## Examples

- [Dynamic-Content-System](https://github.com/segodev/dynamic-content-system)