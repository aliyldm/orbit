package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AddMineCommand;
   import net.bigpoint.darkorbit.map.model.env.mine.MineCommon;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AddMineHandler extends BaseHandler
   {
      
      public function AddMineHandler()
      {
         super();
      }
      
      public static function run(param1:AddMineCommand) : void
      {
         map.addEntity(new MineCommon(param1.x,param1.y,param1.typeId,param1.hash,param1.maxSkill1 ? 1 : 0,param1.maxSkill5b ? 1 : 0));
      }
   }
}

