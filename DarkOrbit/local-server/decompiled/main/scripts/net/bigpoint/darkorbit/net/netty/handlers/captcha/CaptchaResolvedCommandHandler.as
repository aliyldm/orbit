package net.bigpoint.darkorbit.net.netty.handlers.captcha
{
   import net.bigpoint.darkorbit.com.module.CaptchaResolvedCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.BoxCaptchaTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CaptchaResolvedCommandHandler extends BaseHandler
   {
      
      public function CaptchaResolvedCommandHandler()
      {
         super();
      }
      
      public static function run(param1:CaptchaResolvedCommand) : void
      {
         var _loc2_:Ship = map.hero;
         if(_loc2_)
         {
            _loc2_.getFirstTrait(BoxCaptchaTrait).deactivateTrait();
            _loc2_.removeTraitByType(BoxCaptchaTrait);
         }
      }
   }
}

