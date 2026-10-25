package net.bigpoint.darkorbit.net.netty.handlers.captcha
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.CaptchaTriggerCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.BoxCaptchaTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CaptchaTriggerCommandHandler extends BaseHandler
   {
      
      public function CaptchaTriggerCommandHandler()
      {
         super();
      }
      
      public static function run(param1:CaptchaTriggerCommand) : void
      {
         var _loc2_:String = null;
         switch(param1.type)
         {
            case CaptchaTriggerCommand.ECAPTCHATYPE_SOME_BLACK:
               _loc2_ = BPLocale.getItem("captcha_choose_some_black").replace("%AMOUNT%",param1.captchaParam).replace("%TIME%",param1.captchaTimer);
               break;
            case CaptchaTriggerCommand.ECAPTCHATYPE_ALL_BLACK:
               _loc2_ = BPLocale.getItem("captcha_choose_all_black");
               break;
            case CaptchaTriggerCommand.ECAPTCHATYPE_SOME_RED:
               _loc2_ = BPLocale.getItem("captcha_choose_some_red").replace("%AMOUNT%",param1.captchaParam).replace("%TIME%",param1.captchaTimer);
               break;
            case CaptchaTriggerCommand.ECAPTCHATYPE_ALL_RED:
               _loc2_ = BPLocale.getItem("captcha_choose_all_red");
         }
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc2_));
         var _loc3_:Ship = map.hero;
         if(_loc3_)
         {
            _loc3_.addTrait(new BoxCaptchaTrait(param1.posX,param1.posY,param1.Radius,param1.blackBox,param1.redBox));
         }
      }
   }
}

