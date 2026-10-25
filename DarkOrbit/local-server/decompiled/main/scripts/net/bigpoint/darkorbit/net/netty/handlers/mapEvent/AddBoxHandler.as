package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AddBoxCommand;
   import net.bigpoint.darkorbit.map.model.env.collectable.Box;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AddBoxHandler extends BaseHandler
   {
      
      public function AddBoxHandler()
      {
         super();
      }
      
      public static function run(param1:AddBoxCommand) : void
      {
         map.addEntity(new Box(param1.boxType,param1.hash,param1.x,param1.y,false));
      }
   }
}

