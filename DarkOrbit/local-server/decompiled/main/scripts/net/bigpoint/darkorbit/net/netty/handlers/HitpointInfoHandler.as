package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.HitpointInfoCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class HitpointInfoHandler extends BaseHandler
   {
      
      public function HitpointInfoHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:HitpointInfoCommand = param1 as HitpointInfoCommand;
         var _loc3_:int = _loc2_.hitpoints;
         var _loc4_:int = _loc2_.hitpointsMax;
         var _loc5_:int = _loc2_.nanoHull;
         var _loc6_:int = _loc2_.nanoHullMax;
         _main.getConnectionManager().getAttributeAssembly().assembleHitPointsInfo(_loc3_,_loc4_,_loc5_,_loc6_);
         BeaconHandler.updateWarnings();
      }
   }
}

