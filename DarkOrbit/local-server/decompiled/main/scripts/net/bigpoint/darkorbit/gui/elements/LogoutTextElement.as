package net.bigpoint.darkorbit.gui.elements
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   
   public class LogoutTextElement extends SimpleElement implements IFrameObserver
   {
      
      private var guiManager:GuiManager;
      
      private var textField:TextField = new TextField();
      
      private var countdown:int;
      
      private var msgTop:String;
      
      private var msgBottom:String;
      
      private var _tpf:Number = 0;
      
      private var timerOn:Boolean = false;
      
      public function LogoutTextElement(param1:GuiManager)
      {
         super(SimpleElement.TYPE_LOGOUT_TEXT);
         this.guiManager = param1;
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:Array = BPLocale.getItem("msg_logout_seconds").split("%SEC%");
         this.msgTop = _loc1_[0];
         this.msgBottom = _loc1_[1];
         var _loc2_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainBigFontHeight,16777215);
         _loc2_.align = TextFormatAlign.CENTER;
         this.textField.defaultTextFormat = _loc2_;
         this.textField.embedFonts = Styles.plainBigEmbed;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.autoSize = TextFieldAutoSize.CENTER;
         this.textField.wordWrap = true;
         this.textField.multiline = true;
         this.textField.width = 200;
         this.updateText();
         this.addChild(this.textField);
      }
      
      public function startCountdown() : void
      {
         if(Hero.premium.value || Hero.admin)
         {
            this.countdown = 5;
         }
         else
         {
            this.countdown = 20;
         }
         if(!ScreenManager.containsObserver(this))
         {
            ScreenManager.addObserver(this);
         }
         this.timerOn = true;
         this.updateText();
      }
      
      public function stopCountdown() : void
      {
         this.timerOn = false;
      }
      
      private function updateText() : void
      {
         this.textField.text = this.msgTop + "\n\n" + this.countdown + "\n\n" + this.msgBottom;
      }
      
      public function updateTimer(param1:Number) : void
      {
         if(this.timerOn)
         {
            this._tpf += param1;
            if(this._tpf > 999)
            {
               if(this.countdown > 0)
               {
                  --this.countdown;
                  this.updateText();
               }
               this._tpf = 0;
            }
         }
      }
      
      public function cleanup() : void
      {
         ScreenManager.removeObserver(this);
      }
   }
}

