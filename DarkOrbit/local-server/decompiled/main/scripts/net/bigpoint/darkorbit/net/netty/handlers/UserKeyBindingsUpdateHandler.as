package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.greensock.TweenMax;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsUpdate;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.KeyMappingUpdateParser;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class UserKeyBindingsUpdateHandler extends BaseHandler
   {
      
      public function UserKeyBindingsUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:UserKeyBindingsUpdate = param1 as UserKeyBindingsUpdate;
         if(Boolean(_main) && Boolean(_main.screenManager))
         {
            KeyboardMapper.getInstance().cleanup();
            KeyboardMapper.getInstance().addKeys(new KeyMappingUpdateParser(_loc2_));
         }
         else
         {
            TweenMax.delayedCall(0.5,run,[param1]);
         }
      }
   }
}

