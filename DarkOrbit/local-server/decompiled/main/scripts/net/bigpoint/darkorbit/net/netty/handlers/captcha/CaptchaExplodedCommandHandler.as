package net.bigpoint.darkorbit.net.netty.handlers.captcha
{
   import net.bigpoint.darkorbit.com.module.CaptchaExplodeCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.BoxCaptchaTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CaptchaExplodedCommandHandler extends BaseHandler
   {
      
      public function CaptchaExplodedCommandHandler()
      {
         super();
      }
      
      public static function run(param1:CaptchaExplodeCommand) : void
      {
         var _loc2_:Ship = map.hero;
         if(_loc2_)
         {
            if(_loc2_.getFirstTrait(BoxCaptchaTrait) != null)
            {
               _loc2_.getFirstTrait(BoxCaptchaTrait).deactivateTrait();
               _loc2_.removeTraitByType(BoxCaptchaTrait);
            }
         }
      }
   }
}

