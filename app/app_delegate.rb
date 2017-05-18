class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    DBClientsManager.setupWithAppKey(NSBundle.mainBundle.objectForInfoDictionaryKey('ENV_DROPBOX_KEY'))

    @timerController = TimerController.alloc.init

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = @timerController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def application(application, handleOpenURL:url)
    authResult = DBClientsManager.handleRedirectURL(url)

    if (authResult != nil)
      if (authResult.isSuccess)
        NSLog("Success! User is logged into Dropbox.")
        return true
      elsif (authResult.isCancel)
        NSLog("Authorization flow was manually canceled by user!")
      elsif(authResult.isError)
        NSLog("Error: %@", authResult)
      end
    end

    false
  end

end
