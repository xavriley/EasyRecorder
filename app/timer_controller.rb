class TimerController < UIViewController
  attr_reader :timer, :player, :playback_error, :recorder
  attr_accessor :manager, :account, :store

  def viewDidLoad
    margin = 20

    # recording code
    # taken from http://davidstalin.blogspot.co.uk/2014/08/audio-recording-rubymotion.html
    @recording_url = getRecordingUrl
    recording_configs = {
      :AVFormatIDKey => KAudioFormatLinearPCM,
      :AVNumberOfChannelsKey => 2,
      :AVEncoderBitRateKey => 16,
      :AVEncoderAudioQualityKey => ::AVAudioQualityMax.to_i,
      :AVSampleRateKey => 44100,
      :AVLinearPCMIsBigEndianKey => 0,
      :AVLinearPCMIsFloatKey => 0
    }
    recording_err_ptr = Pointer.new(:object)

    # initialize recorder
    @recorder = AVAudioRecorder.alloc.initWithURL @recording_url, settings: recording_configs, error: recording_err_ptr
    # setup AV session
    recording_error = Pointer.new(:object)
    sessionInstance = AVAudioSession.sharedInstance
    sessionInstance.setCategory(AVAudioSessionCategoryPlayAndRecord, error: recording_error)
    if recording_error.value
      NSLog "Couldn't set audio category: error code: #{recording_error.value.localizedDescription}"
    end
    sessionInstance.setActive(true, error: recording_error)
    if recording_error[0]
      NSLog "Couldn't set audio session active, error code: #{recording_error[0].localizedDescription}"
    end

    # setup playback - wasn't using the same AV session when placed inside a method
    @playback_error = Pointer.new(:object)
    @player = AVAudioPlayer.alloc.initWithContentsOfURL getRecordingUrl, error: playback_error

    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(30)
    @state.text = 'Tap to start'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 200], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@state)

    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Start', forState:UIControlStateNormal)
    @action.setTitle('Stop', forState:UIControlStateSelected)
    @action.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    @action.frame = [[margin, 260], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@action)

    @play = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @play.setTitle("Play sound", forState:UIControlStateNormal)
    @play.frame = [[margin, 300], [view.frame.size.width - margin * 2, 40]]
    @play.addTarget(self, action:'playSound', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@play)

    @linkToDropbox = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @linkToDropbox.setTitle("Link To Dropbox", forState:UIControlStateNormal)
    @linkToDropbox.frame = [[margin, 340], [view.frame.size.width - margin * 2, 40]]
    @linkToDropbox.addTarget(self, action: 'linkToDropbox', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@linkToDropbox)
  end

  def actionTapped

    if DBClientsManager.authorizedClient
      if @timer
        @timer.invalidate
        @timer = nil
        @recorder.stop

        #ask for name or delete here
        recording_detail_controller = RecordingDetailController.alloc.initWithParentController(self)
        self.presentViewController(
          UINavigationController.alloc.initWithRootViewController(recording_detail_controller),
          animated: true,
          completion: lambda {})
      else
        @duration = 0
        if @recorder.prepareToRecord
          @recorder.record
          @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
        else
          NSLog("Failed to prepare to record")
        end
      end
      @action.selected = !@action.selected?
    else

      NSLog("no dropbox link")
      #      UIAlertView.alloc.initWithTitle("No Dropbox link", message: "Please link app with Dropbox first", delegate: self, cancelButtonTitle: 'Cancel', otherButtonTitles: "OK")
    end
  end

  def alertView(alertView, clickedButtonAtIndex: indexPath)
    # do nothing...
  end



  def playSound
    @player.prepareToPlay unless @playback_error
    @player.delegate = self
    @player.play
    if @playback_error.value
      NSLog "Couldn't play sound: error code: #{@playback_error}"
    end
  end

  def getRecordingUrl
    NSURL.fileURLWithPath(App.documents_path + "/record.caf")
  end

  def timerFired
    @state.text = "%.1f" % (@duration += 0.1)
  end

  def reload
    # navigationItem.leftBarButtonItem.title = if self.account then 'Unlink' else 'Link' end
    # navigationItem.rightBarButtonItem.enabled = (self.account != nil)
    self.store.sync(nil) if @store
    # tableView.reloadData
  end

  def linkToDropbox
    DBClientsManager.authorizeFromController(UIApplication.sharedApplication, controller:self, openURL:lambda {|url|
      UIApplication.sharedApplication.openURL(url)
    })
  end
end
