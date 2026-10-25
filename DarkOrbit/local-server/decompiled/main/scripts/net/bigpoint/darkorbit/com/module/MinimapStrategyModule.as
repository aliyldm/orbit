package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MinimapStrategyModule implements IModule
   {
      
      private static var _instance:MinimapStrategyModule;
      
      public static const MINIMAPSTRATEGY_DEFAULT:int = 0;
      
      public static const MINIMAPSTRATEGY_RED_AND_BLUE:int = 1;
      
      public static const MINIMAPSTRATEGY_COMPANY_COLORS:int = 2;
      
      public static const MINIMAPSTRATEGY_PLAYER_NPC_AND_INVADERS:int = 3;
      
      public static const MINIMAPSTRATEGY__MAX:int = 4;
      
      public var minimapStrategy:int = 0;
      
      public function MinimapStrategyModule(param1:int = 0)
      {
         super();
         this.minimapStrategy = param1;
      }
      
      public static function get instance() : MinimapStrategyModule
      {
         return _instance || (_instance = new MinimapStrategyModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16690;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.minimapStrategy = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16690);
         param1.writeShort(this.minimapStrategy);
      }
   }
}

