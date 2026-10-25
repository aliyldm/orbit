package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShowSimpleMessageCommand extends AbstractMessageCommand
   {
      
      public function ShowSimpleMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MessageCommandParams = param1.getBody() as MessageCommandParams;
         if(_loc2_)
         {
            this.showSimpleMessage(_loc2_.message,_loc2_.id);
            return;
         }
         throw new Error("Send this notification with a proper MessageCommandParams instance.");
      }
      
      public function showSimpleMessage(param1:String, param2:String) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:TextField = null;
         _loc3_ = new Sprite();
         _loc3_.mouseEnabled = Main.mouseEventsEnabled;
         _loc3_.mouseChildren = Main.mouseEventsEnabled;
         if(param2 == null)
         {
            _loc3_.name = param1;
         }
         else
         {
            _loc3_.name = param2;
         }
         _loc4_ = new TextField();
         _loc4_.defaultTextFormat = Styles.systemSplashFmt;
         _loc4_.embedFonts = Styles.systemSplashEmbed;
         _loc4_.width = ScreenManager.getScreenWidth() * 0.6;
         _loc4_.multiline = true;
         _loc4_.wordWrap = true;
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.textColor = 16777215;
         _loc4_.antiAliasType = "advanced";
         _loc4_.selectable = false;
         _loc4_.text = param1;
         _loc3_.x = -ScreenManager.getScreenWidth() * 0.5;
         _loc3_.y = ScreenManager.getScreenHeight() * 0.4;
         _loc3_.addChild(_loc4_);
         if(instantView)
         {
            instantView.addChild(_loc3_);
         }
      }
   }
}

