$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-cocoapods'
require 'bubble-wrap/core'
require 'dotenv'

# .env pattern from https://gist.github.com/dblandin/8509457
# for handling secrets
environment_variables = Dotenv.load

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Timer'
  app.frameworks += ['AVFoundation','Security','QuartzCore']
  app.libs += ['/usr/lib/libz.dylib']
  app.pods do
    pod 'Dropbox-Sync-API-SDK'
  end

  app.detect_dependencies = true

  environment_variables.each do |key, value| 
    app.info_plist["ENV_#{key}"] = value 
  end

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleTypeRole'   => 'Editor',
      'CFBundleURLName'    => 'Dropbox',
      'CFBundleURLSchemes' => ["db-#{App::ENV['DROPBOX_KEY']}"] }
  ]
end
