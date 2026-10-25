package net.bigpoint.darkorbit.mvc.gui.messages.view
{
   import fl.controls.TextArea;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.LogMessageVO;
   
   public class LogWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "LogWindowMediator";
      
      protected var _logWindow:SimpleWindow;
      
      protected var _logTextArea:TextArea;
      
      protected var _messageBuffer:Array = [];
      
      protected var _useHTMLLog:Boolean = false;
      
      public function LogWindowMediator()
      {
         super(NAME);
         this.setUp();
      }
      
      protected function setUp() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:TextAreaElement = null;
         var _loc1_:GuiManager = GuiManager.instance;
         this._logWindow = _loc1_.getWindow(GuiConstants.LOG_WINDOW);
         if(this._logWindow == null)
         {
            this._logWindow = _loc1_.createWindow(GuiConstants.LOG_WINDOW) as SimpleWindow;
            this._logWindow.addEventListener(SimpleWindowEvent.ON_RESIZE,this.onResizeLogWindow);
            _loc2_ = new SimpleContainer(_loc1_,SimpleContainer.CLASS_LOG);
            _loc3_ = new TextAreaElement(10,10,TextFormatAlign.LEFT);
            _loc3_.mouseEnabled = Main.mouseEventsEnabled;
            this._logTextArea = new TextArea();
            this._logTextArea = _loc3_.textArea;
            _loc2_.addElement(_loc3_);
            _loc2_.addPredefinedPosition(new Point(15,30));
            _loc2_.setPredefinedPosition();
            this._logWindow.addContainer(_loc2_);
         }
      }
      
      override public function onRegister() : void
      {
         facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("log_boot_message")));
      }
      
      protected function onResizeLogWindow(param1:Event) : void
      {
         var _loc2_:SimpleWindow = param1.currentTarget as SimpleWindow;
         this._logTextArea.width = _loc2_.getWindow().width - 30;
         this._logTextArea.height = _loc2_.getWindow().height - 50;
      }
      
      public function logMessage(param1:String) : void
      {
         var _loc2_:LogMessageVO = new LogMessageVO(param1);
         this._messageBuffer.push(_loc2_);
         if(this._messageBuffer.length > 25)
         {
            this._messageBuffer.shift();
            this.refreshTextField();
         }
         else
         {
            this.addToTextField(param1,true);
         }
      }
      
      private function refreshTextField() : void
      {
         var _loc3_:LogMessageVO = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._messageBuffer.length)
         {
            _loc3_ = this._messageBuffer[_loc2_];
            if(this._useHTMLLog)
            {
               _loc1_ += _loc3_.getMessage();
            }
            else
            {
               _loc1_ = _loc1_ + _loc3_.getMessage() + "\n";
            }
            _loc2_++;
         }
         this.addToTextField(_loc1_);
      }
      
      private function addToTextField(param1:String, param2:Boolean = false) : void
      {
         if(this._useHTMLLog)
         {
            if(param2)
            {
               this._logTextArea.htmlText += param1;
            }
            else
            {
               this._logTextArea.htmlText = param1;
            }
         }
         else if(param2)
         {
            this._logTextArea.text = this._logTextArea.text + "\n" + param1;
         }
         else
         {
            this._logTextArea.text = param1;
         }
         this._logTextArea.verticalScrollPosition = this._logTextArea.maxVerticalScrollPosition;
      }
   }
}

