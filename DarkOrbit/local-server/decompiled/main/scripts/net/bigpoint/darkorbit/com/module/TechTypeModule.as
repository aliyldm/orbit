package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechTypeModule implements IModule
   {
      
      private static var _instance:TechTypeModule;
      
      public static const TECHTYPE_ENERGY_LEECH_ARRAY:int = 0;
      
      public static const TECHTYPE_ENERGY_CHAIN_IMPULSE:int = 1;
      
      public static const TECHTYPE_ROCKET_PROBABILITY_MAXIMIZER:int = 2;
      
      public static const TECHTYPE_SHIELD_BACKUP:int = 3;
      
      public static const TECHTYPE_SPEED_LEECH:int = 4;
      
      public static const TECHTYPE_BATTLE_REPBOT:int = 5;
      
      public static const TECHTYPE_CLINGING_IMPULSE_DRONE:int = 6;
      
      public static const TECHTYPE_ANTI_MINE_TRANSMITTER:int = 7;
      
      public static const TECHTYPE__MAX:int = 8;
      
      public var typeValue:int = 0;
      
      public function TechTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : TechTypeModule
      {
         return _instance || (_instance = new TechTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 68;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(68);
         param1.writeShort(this.typeValue);
      }
   }
}

