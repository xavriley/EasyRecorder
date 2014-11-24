class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    mgr = DBAccountManager.alloc.initWithAppKey("xoit9j3uwj9vmdv", secret:"dkc3edahiij64jl")
    DBAccountManager.setSharedManager(mgr)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = TimerController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
