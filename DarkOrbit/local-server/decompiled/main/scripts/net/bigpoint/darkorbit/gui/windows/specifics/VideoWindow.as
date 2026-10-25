package net.bigpoint.darkorbit.gui.windows.specifics
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.LogMessageVO;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class VideoWindow extends SimpleWindow implements IFrameObserver
   {
      
      public static const NOTIFICATION_FPS:int = 9876;
      
      public var startX:int = 0;
      
      public var startY:int = 0;
      
      public var targetX:int = 0;
      
      public var targetY:int = 0;
      
      public var align:String = "n";
      
      public var scrollSpeed:Number = 0.5;
      
      protected var simpleContainer:SimpleContainer;
      
      protected var videoElement:VideoElement;
      
      protected var textAreaElement:TextAreaElement;
      
      public var videoID:int;
      
      public var videoClassID:int;
      
      public var languageKeys:Vector.<String> = new Vector.<String>();
      
      protected var continueButton:ButtonElement;
      
      protected var fasterButton:ButtonElement;
      
      private var logCharIndex:int = 0;
      
      private var noiseChannel:SoundChannel;
      
      private var logMessage:LogMessageVO;
      
      private var valid:Boolean;
      
      protected var _showButtons:Boolean;
      
      private var logWriteTime:Number = 0;
      
      private var logWriteTimerOn:Boolean = false;
      
      private var factionID:int;
      
      private var _serverWindowID:int;
      
      public function VideoWindow(param1:GuiManager, param2:FeatureWindowVO, param3:int, param4:int, param5:int, param6:String, param7:Boolean, param8:int = 0)
      {
         super();
         this._serverWindowID = param3;
         param2.definition.draggable = true;
         param2.definition.closeable = param5 != VideoElement.CLASS_COMMANDER;
         var _loc9_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("window"));
         preinitialize(param2,param1,_loc9_);
         this.videoID = param4;
         this.videoClassID = param5;
         this.factionID = param8;
         this.align = param6;
         this._showButtons = param7;
         ScreenManager.addObserver(this);
      }
      
      protected function init() : void
      {
         this.simpleContainer = new SimpleContainer(_guiManager,SimpleContainer.CLASS_DEFAULT);
         this.initVideoElement();
         this.initTextAreaElement();
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         if(this._showButtons)
         {
            this.initFastButton(_loc1_);
            this.initContinueButton(_loc1_);
            this.updateContinueButtonLabel();
         }
         this.addContainer(this.simpleContainer);
         this.simpleContainer.x = 15;
         this.simpleContainer.y = 35;
         var _loc2_:int = resizeDimension.x;
         var _loc3_:int = resizeDimension.y;
         switch(this.align)
         {
            case "n":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = -_loc3_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = 5;
               break;
            case "ne":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = 5;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = 5;
               break;
            case "e":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               break;
            case "se":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               this.targetX = ScreenManager.getScreenWidth() - _loc2_ - 30;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "s":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = ScreenManager.getScreenHeight() - 10;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "sw":
               this.startX = -_loc2_ - 10;
               this.startY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               this.targetX = 5;
               this.targetY = ScreenManager.getScreenHeight() - _loc3_ - 30;
               break;
            case "w":
               this.startX = -_loc2_ - 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               this.targetX = 5;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
               break;
            case "nw":
               this.startX = -_loc2_ - 10;
               this.startY = 65;
               this.targetX = 5;
               this.targetY = 65;
               break;
            case "c":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.startY = -_loc3_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc2_ / 2;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc3_ / 2;
         }
         this.x = this.startX;
         this.y = this.startY;
         ScreenManager.getWindowLayer().addChild(this);
      }
      
      protected function initContinueButton(param1:SWFFinisher) : void
      {
         this.continueButton = new ButtonElement(ButtonElementTypes.TYPE_TUTORIAL_CONTINUE,"",param1.getEmbeddedMovieClip("button1"));
         this.continueButton.addEventListener(MouseEvent.CLICK,this.handleContinueButtonClick);
         this.simpleContainer.addElement(this.continueButton,SimpleContainer.NO_ALIGN);
         this.continueButton.y = this.videoElement.height - this.continueButton.height;
         this.continueButton.visible = false;
      }
      
      protected function initFastButton(param1:SWFFinisher) : void
      {
         this.fasterButton = new ButtonElement(ButtonElementTypes.TYPE_TUTORIAL_FASTER,BPLocale.getItem("video_btn_showAll"),param1.getEmbeddedMovieClip("button1"));
         this.fasterButton.addEventListener(MouseEvent.CLICK,this.handleFasterButtonClick);
         this.fasterButton.x = this.textAreaElement.textArea.width + this.videoElement.width - this.fasterButton.width;
         this.fasterButton.y = this.videoElement.height - this.fasterButton.height;
         this.fasterButton.visible = false;
         this.simpleContainer.addElement(this.fasterButton,SimpleContainer.NO_ALIGN);
      }
      
      protected function initTextAreaElement() : void
      {
         this.textAreaElement = new TextAreaElement(238,125,TextFormatAlign.LEFT);
         this.simpleContainer.addElement(this.textAreaElement,SimpleContainer.ALIGN_HORIZONTAL);
      }
      
      protected function initVideoElement() : void
      {
         this.videoElement = new VideoElement(this.videoID,this.videoClassID,this.factionID);
         this.simpleContainer.addElement(this.videoElement);
      }
      
      private function updateContinueButtonLabel() : void
      {
         var _loc1_:String = this.getLastStateKey();
         if(this.languageKeys.length > 0)
         {
            _loc1_ = "video_btn_continue";
         }
         this.continueButton.labelText = BPLocale.getItem(_loc1_);
         this.continueButton.x = this.textAreaElement.textArea.width + this.videoElement.width - this.continueButton.width;
      }
      
      protected function getLastStateKey() : String
      {
         return "label_close";
      }
      
      public function attemptToShow() : void
      {
         this.setHeaderText();
         this.valid = true;
         var _loc1_:String = VideoElement.getContentResKey(this.videoClassID,this.videoID);
         if(ResourceManager.fileCollection.isLoaded(_loc1_))
         {
            this.show();
         }
         else
         {
            ResourceManager.fileCollection.load(_loc1_,this.handleClipLoaded);
         }
      }
      
      private function setHeaderText() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(this.videoClassID == VideoElement.CLASS_COMMANDER)
         {
            _loc1_ = BPLocale.getItem("video_window_header");
            _loc2_ = BPLocale.getItem("video_name_" + this.videoID);
            if(_loc2_.length > 0 && _loc2_ != "{video_name_" + this.videoID + "}")
            {
               _loc1_ += " [" + _loc2_ + "]";
            }
         }
         else if(this.videoClassID == VideoElement.CLASS_HELPMOVIE)
         {
            _loc1_ = BPLocale.getItem("title_helpvideo");
         }
         _titleLabel.text = _loc1_;
      }
      
      private function handleClipLoaded(param1:SWFFinisher = null) : void
      {
         if(this.valid)
         {
            this.show();
         }
      }
      
      private function show() : void
      {
         this.init();
         this.x = this.startX;
         this.y = this.startY;
         TweenLite.to(this,this.scrollSpeed,{
            "x":this.targetX,
            "y":this.targetY,
            "onComplete":this.handleShowComplete
         });
      }
      
      public function hide() : void
      {
         this.valid = false;
         this.x = this.targetX;
         this.y = this.targetY;
         TweenLite.to(this,this.scrollSpeed,{
            "ease":Linear.easeNone,
            "x":this.startX,
            "y":this.startY,
            "onComplete":this.handleHideComplete
         });
         if(Boolean(this.videoElement) && Boolean(this.videoElement.interference))
         {
            this.videoElement.interference.alpha = 1;
         }
         if(maximized)
         {
            this.noiseChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_NOISE);
         }
         TweenMax.delayedCall(0.25,this.stopSound);
      }
      
      private function stopSound() : void
      {
         if(this.noiseChannel != null)
         {
            AudioManager.removeLoop(this.noiseChannel);
         }
      }
      
      private function handleHideComplete() : void
      {
         this.simpleContainer.removeAllElements();
         this.videoElement.cleanup();
         this.cleanup();
         this.removeLogWriter();
         ScreenManager.removeObserver(this);
         _guiManager.deleteWindow(_id);
         _guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.USER_INTERFACE,[ServerCommands.VIDEO_WINDOW,ServerCommands.WINDOW_DESTROYED,id]);
      }
      
      private function startLogTimer() : void
      {
         this.logWriteTimerOn = true;
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(this.logWriteTimerOn)
         {
            this.logWriteTime += param1;
            if(this.logWriteTime > 24)
            {
               if(this.logMessage.isCompleted())
               {
                  this.removeLogWriter();
                  if(this._showButtons)
                  {
                     this.fasterButton.visible = false;
                     this.updateContinueButtonLabel();
                     this.continueButton.visible = true;
                  }
                  return;
               }
               _loc2_ = "";
               _loc3_ = this.logMessage.getPartialMessage(2);
               _loc4_ = _loc3_.charAt(_loc3_.length - 1);
               if(_loc4_ == "<")
               {
                  _loc5_ = 0;
                  while(_loc4_ != ">")
                  {
                     if(_loc5_ > 20)
                     {
                        break;
                     }
                     _loc3_ = this.logMessage.getPartialMessage(1);
                     _loc4_ = _loc3_.charAt(_loc3_.length - 1);
                     _loc2_ = _loc2_ + _loc3_ + "\n";
                     _loc5_++;
                  }
               }
               _loc2_ = _loc2_ + _loc3_ + "\n";
               if(this.logCharIndex % FastMath.getRandomCount(1,6) == 0)
               {
                  AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SIGNAL_0);
               }
               ++this.logCharIndex;
               this.textAreaElement.textArea.htmlText = _loc2_;
               this.textAreaElement.textArea.verticalScrollPosition = this.textAreaElement.textArea.maxVerticalScrollPosition;
               this.logWriteTime = 0;
            }
         }
      }
      
      private function handleShowComplete() : void
      {
         if(this.videoElement.interference)
         {
            this.videoElement.interference.alpha = 0.1;
         }
         this.noiseChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_NOISE);
         TweenMax.delayedCall(0.25,this.stopSound);
         this.startTextWriter();
      }
      
      public function startTextWriter() : void
      {
         if(this.languageKeys.length == 0)
         {
            return;
         }
         var _loc1_:String = BPLocale.getItem(this.languageKeys[0]);
         _loc1_ = this.replaceHTML(_loc1_);
         this.setText(_loc1_);
         this.languageKeys.shift();
         if(this._showButtons && this.fasterButton != null && this.continueButton != null)
         {
            this.fasterButton.visible = true;
            this.continueButton.visible = false;
         }
      }
      
      private function replaceHTML(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:Array = PatternManager.videoWindowColorPatterns;
         for(_loc3_ in _loc2_)
         {
            param1 = param1.replace(new RegExp("<" + _loc3_ + ">","g"),"<font color=\'#" + _loc2_[_loc3_] + "\'>");
            param1 = param1.replace(new RegExp("</" + _loc3_ + ">","g"),"</font>");
         }
         return param1;
      }
      
      public function setText(param1:String) : void
      {
         this.logCharIndex = 0;
         this.logMessage = new LogMessageVO(param1);
         this.startLogTimer();
      }
      
      protected function handleContinueButtonClick(param1:MouseEvent) : void
      {
         this.nextPage();
      }
      
      public function nextPage() : void
      {
         if(this.languageKeys.length != 0)
         {
            this.startTextWriter();
         }
         else
         {
            this.handleLastButtonClick();
         }
      }
      
      protected function handleLastButtonClick() : void
      {
         _guiManager.removeVideoWindow(id + this._serverWindowID);
      }
      
      protected function handleFasterButtonClick(param1:MouseEvent) : void
      {
         this.removeLogWriter();
         this.textAreaElement.textArea.htmlText = this.logMessage.getMessage();
         this.textAreaElement.textArea.verticalScrollPosition = this.textAreaElement.textArea.maxVerticalScrollPosition;
         this.fasterButton.visible = false;
         this.updateContinueButtonLabel();
         this.continueButton.visible = true;
      }
      
      private function removeLogWriter() : void
      {
         this.logWriteTimerOn = false;
      }
      
      public function set showButtons(param1:Boolean) : void
      {
         if(this._showButtons != param1)
         {
            this._showButtons = param1;
            this.invalidateButtons();
         }
      }
      
      protected function invalidateButtons() : void
      {
         var _loc1_:SWFFinisher = null;
         if(this._showButtons)
         {
            _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            this.initFastButton(_loc1_);
            this.initContinueButton(_loc1_);
            this.updateContinueButtonLabel();
         }
         else
         {
            this.removeFastButton();
            this.removeContinueButton();
         }
      }
      
      protected function removeContinueButton() : void
      {
         this.simpleContainer.removeElementById(ButtonElementTypes.TYPE_TUTORIAL_CONTINUE);
      }
      
      protected function removeFastButton() : void
      {
         this.simpleContainer.removeElementById(ButtonElementTypes.TYPE_TUTORIAL_FASTER);
      }
   }
}

