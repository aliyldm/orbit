package net.bigpoint.darkorbit.net.netty.handlers.logmessage
{
   import net.bigpoint.darkorbit.com.module.LMCollectResourcesCommand;
   import net.bigpoint.darkorbit.com.module.LogMessengerPriorityModule;
   import net.bigpoint.darkorbit.com.module.OreCountModule;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LMCollectResourcesHandler extends BaseHandler
   {
      
      public function LMCollectResourcesHandler()
      {
         super();
      }
      
      public static function run(param1:LMCollectResourcesCommand) : void
      {
         var _loc2_:uint = uint(param1.priorityMode.priorityModeValue);
         var _loc3_:Vector.<OreCountModule> = param1.contentList;
         _main.getConnectionManager().getBoxCollectAssembly().assembleOre(_loc2_,_loc3_);
      }
      
      override public function handleFeedbackCommand(param1:Vector.<String>) : void
      {
         var _loc4_:OreCountModule = null;
         var _loc5_:OreTypeModule = null;
         var _loc6_:Number = NaN;
         var _loc2_:LMCollectResourcesCommand = new LMCollectResourcesCommand();
         param1 = param1.reverse();
         var _loc3_:uint = uint(param1.pop());
         _loc2_.priorityMode = new LogMessengerPriorityModule(_loc3_);
         var _loc7_:* = int(param1.length - 1);
         while(_loc7_ >= 0)
         {
            _loc5_ = new OreTypeModule(_loc7_);
            _loc6_ = Number(param1[_loc7_]);
            _loc4_ = new OreCountModule(_loc5_,_loc6_);
            _loc2_.contentList.push(_loc4_);
            _loc7_--;
         }
         run(_loc2_);
      }
   }
}

