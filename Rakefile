$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-cocoapods'
require 'bubble-wrap/core'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Timer'
  app.frameworks += ["AVFoundation"]
  app.pods do
    pod 'Dropbox-iOS-SDK'
  end

  # app.vendor_project('vendor/Pods/Dropbox-iOS-SDK/dropbox-ios-sdk-1.3.13/DropboxSDK.framework', :static,
  #                    :products => ['DropboxSDK'],
  #                   )

  app.detect_dependencies = true
end
