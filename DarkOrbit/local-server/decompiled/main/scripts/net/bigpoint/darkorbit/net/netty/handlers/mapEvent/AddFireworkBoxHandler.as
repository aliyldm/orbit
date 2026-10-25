package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AddFireworkBoxCommand;
   import net.bigpoint.darkorbit.map.model.env.collectable.FireworkBox;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AddFireworkBoxHandler extends BaseHandler
   {
      
      public function AddFireworkBoxHandler()
      {
         super();
      }
      
      public static function run(param1:AddFireworkBoxCommand) : void
      {
         map.addEntity(new FireworkBox(param1.typeId,param1.hash,param1.x,param1.y,param1.colourCode,param1.eventModifier));
      }
   }
}

