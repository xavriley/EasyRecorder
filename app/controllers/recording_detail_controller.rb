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
    # Steps required to send file to Dropbox
    filesystem = DBFilesystem.alloc.initWithAccount(@parent_controller.account)
    DBFilesystem.setSharedFilesystem(filesystem)
    newPath = DBPath.root.childPath("#{@text_field.text}.wav")
    file = DBFilesystem.sharedFilesystem.createFile(newPath, error: nil)
    file.writeContentsOfFile(parent_controller.getRecordingUrl.path, shouldSteal: false, error: nil)
    # for the table view
    #filesystem.listFolder(DBPath.root, error: nil).inspect
    self.dismissViewControllerAnimated(true, completion: lambda {})
  end
end
