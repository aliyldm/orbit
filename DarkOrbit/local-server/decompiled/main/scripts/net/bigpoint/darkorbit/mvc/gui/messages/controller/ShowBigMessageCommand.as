package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.components.custom.ResultLabel;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.utils.BitmapUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShowBigMessageCommand extends AbstractMessageCommand
   {
      
      public function ShowBigMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MessageCommandParams = param1.getBody() as MessageCommandParams;
         if(_loc2_)
         {
            this.showBigMessage(_loc2_.message,_loc2_.id,_loc2_.fadeInDelay,_loc2_.fadeOutDelay);
            return;
         }
         throw new Error("Send this notification with a proper MessageCommandParams instance.");
      }
      
      public function showBigMessage(param1:String, param2:String, param3:int = 2, param4:int = 2) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc7_:Bitmap = null;
         if(param2 == null || instantView.getChildByName(param2) != null)
         {
            return;
         }
         _loc5_ = this.createTextField(param1);
         var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,true,0);
         _loc6_.draw(_loc5_);
         _loc7_ = new Bitmap(_loc6_);
         _loc7_.name = param2;
         _loc7_.alpha = 0;
         _loc7_.x = -_loc7_.width * 0.5;
         _loc7_.y = 220;
         var _loc8_:int = _loc7_.x;
         _loc7_.x -= 25;
         instantView.addChild(_loc7_);
         TweenMax.to(_loc7_,1,{
            "delay":param3,
            "x":_loc8_,
            "alpha":1,
            "glowFilter":{
               "color":1118481,
               "alpha":0.74,
               "blurX":9,
               "blurY":9,
               "strength":5,
               "quality":3
            },
            "onComplete":this.handleTweenCompleted,
            "onCompleteParams":[_loc7_,param4]
         });
      }
      
      private function handleTweenCompleted(param1:Bitmap, param2:int) : void
      {
         TweenMax.to(param1,1,{
            "delay":param2,
            "alpha":0,
            "onComplete":this.handleCleanUp,
            "onCompleteParams":[param1]
         });
      }
      
      private function handleCleanUp(param1:Bitmap) : void
      {
         param1.bitmapData.dispose();
         MovieClipUtils.removeDisplayObject(param1);
      }
      
      private function createGlowingTextField(param1:String) : DisplayObject
      {
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = Styles.systemSplashFmt.font;
         _loc2_.size = 48;
         _loc2_.align = TextFormatAlign.CENTER;
         var _loc3_:ResultLabel = new ResultLabel();
         _loc3_.width = 600;
         _loc3_.height = 50;
         var _loc4_:BitmapData = ResourceManager.getBitmapData("clientSelection","gradient");
         _loc4_ = BitmapUtils.scaleBitmapData(_loc4_,1,50 / _loc4_.height);
         _loc3_.gradient = _loc4_;
         _loc3_.textFormat = _loc2_;
         _loc3_.embededFonts = true;
         _loc3_.text = param1;
         return _loc3_;
      }
      
      private function createTextField(param1:String) : DisplayObject
      {
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = Styles.systemSplashFmt.font;
         _loc2_.size = 48;
         _loc2_.align = TextFormatAlign.CENTER;
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = _loc2_;
         _loc3_.width = ScreenManager.getScreenWidth() * 0.8;
         _loc3_.embedFonts = Styles.systemSplashEmbed;
         _loc3_.wordWrap = true;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.multiline = true;
         _loc3_.textColor = 16777215;
         _loc3_.antiAliasType = "advanced";
         _loc3_.selectable = false;
         _loc3_.text = param1;
         return _loc3_;
      }
   }
}

