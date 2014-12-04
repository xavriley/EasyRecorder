$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-cocoapods'
require 'bubble-wrap/core'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Timer'
  app.frameworks += ['AVFoundation','Security','QuartzCore']
  app.libs += ['/usr/lib/libz.dylib']
  app.pods do
    pod 'Dropbox-Sync-API-SDK'
  end

  app.detect_dependencies = true
end
