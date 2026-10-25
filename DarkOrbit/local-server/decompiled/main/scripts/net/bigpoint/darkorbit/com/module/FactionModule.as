package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FactionModule extends PlayerAttributeModule
   {
      
      private static var _instance:FactionModule;
      
      public static const FACTION_NONE:int = 0;
      
      public static const FACTION_MMO:int = 1;
      
      public static const FACTION_EIC:int = 2;
      
      public static const FACTION_VRU:int = 3;
      
      public static const FACTION__MAX:int = 4;
      
      public var faction:int = 0;
      
      public function FactionModule(param1:int = 0)
      {
         super();
         this.faction = param1;
      }
      
      public static function get instance() : FactionModule
      {
         return _instance || (_instance = new FactionModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 9999;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.faction = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9999);
         super.write(param1);
         param1.writeShort(this.faction);
      }
   }
}

