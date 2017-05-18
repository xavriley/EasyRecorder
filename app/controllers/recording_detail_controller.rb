class RecordingDetailController < UIViewController
  attr_accessor :parent_controller

  def initWithParentController(parent_controller)
    self.initWithNibName(nil, bundle: nil)
    @parent_controller = parent_controller
    self
  end

  def viewDidLoad
    super

    self.title = "Recording finished!"
    self.view.backgroundColor = UIColor.whiteColor
    @text_field = UITextField.alloc.initWithFrame(CGRectZero)
    @text_field.borderStyle = UITextBorderStyleRoundedRect
    @text_field.textAlignment = textAlignment = UITextAlignmentCenter
    @text_field.placeholder = "Give it a name"
    @text_field.frame = [CGPointZero, [150,32]]
    @text_field.center = [self.view.frame.size.width / 2,
                          self.view.frame.size.height / 2 - 170]
    self.view.addSubview(@text_field)

    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.setTitle("Save", forState: UIControlStateNormal)
    @button.frame = [[
      @text_field.frame.origin.x,
      @text_field.frame.origin.y + @text_field.frame.size.height + 10
    ],
    @text_field.frame.size]

   self.view.addSubview(@button)

   @button.addTarget(self,
                    action: "validate_and_save",
                    forControlEvents: UIControlEventTouchUpInside)
  end

  def validate_and_save

    client = DBClientsManager.authorizedClient

    if client
      fileData = NSData.dataWithContentsOfFile parent_controller.getRecordingUrl.path

      # For overriding on upload
      mode = DBFILESWriteMode.alloc.initWithOverwrite

      uploadTask = client.filesRoutes.uploadData("/#{@text_field.text}.wav", mode:mode, autorename: true, clientModified:nil, mute: false,inputData:fileData)

      uploadTask.setResponseBlock(lambda { |result,routeError, networkError|
        if (result)
          NSLog("%@\n", result)
        else
          NSLog("%@\n%@\n", routeError, networkError)
        end
      })

      uploadTask.setProgressBlock(lambda { |bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded|
        NSLog("\n%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded)
      })
    end

    self.dismissViewControllerAnimated(true, completion: lambda {})
  end
end
