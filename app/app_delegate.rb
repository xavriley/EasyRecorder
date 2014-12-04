class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    mgr = DBAccountManager.alloc.initWithAppKey(App::ENV['DROPBOX_KEY'], secret:App::ENV['DROPBOX_SECRET'])
    DBAccountManager.setSharedManager(mgr)

    @timerController = TimerController.alloc.init

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @timerController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
    if DBAccountManager.sharedManager.handleOpenURL(url) then
      NSLog("App linked successfully!")
      @timerController.reload
      true
    end

    false
  end
end
