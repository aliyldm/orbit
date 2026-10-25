package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AddOreCommand;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AddOreHandler extends BaseHandler
   {
      
      public function AddOreHandler()
      {
         super();
      }
      
      public static function run(param1:AddOreCommand) : void
      {
         map.addEntity(new Ore(param1.oreType.typeValue,param1.hash,param1.x,param1.y));
      }
   }
}

