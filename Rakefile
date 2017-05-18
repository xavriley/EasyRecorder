$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-cocoapods'
require 'bubble-wrap/core'

Motion::Project::App.setup do |app|
  app.name = 'Timer'
  app.frameworks += ['AVFoundation','Security','QuartzCore']
  app.libs += ['/usr/lib/libz.dylib']
  app.pods do
    pod 'ObjectiveDropboxOfficial'
  end

  app.detect_dependencies = true

  App::ENV.each do |key, value|
    app.info_plist["ENV_#{key}"] = value
  end

  app.info_plist['DROPBOX_KEY'] = ENV['DROPBOX_KEY']

  app.info_plist['LSApplicationQueriesSchemes'] = [
    "dbapi-8-emm",
    "dbapi-2"
  ]

  app.info_plist['CFBundleURLTypes'] = [
    {
      'CFBundleURLSchemes' => ["db-#{App::ENV['DROPBOX_KEY']}"],
      'CFBundleURLName'    => ''
    }
  ]
end
