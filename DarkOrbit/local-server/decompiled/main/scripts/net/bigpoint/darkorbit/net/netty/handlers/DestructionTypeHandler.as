package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.DestructionTypeModule;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class DestructionTypeHandler extends BaseHandler
   {
      
      public function DestructionTypeHandler()
      {
         super();
      }
      
      public static function run(param1:DestructionTypeModule) : void
      {
         var _loc2_:Killscreen = Killscreen.getInstance();
         _loc2_.setDestructionType(param1.cause);
      }
   }
}

