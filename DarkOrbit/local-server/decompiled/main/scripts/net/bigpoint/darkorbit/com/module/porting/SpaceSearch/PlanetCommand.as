package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlanetCommand implements IModule
   {
      
      private static var _instance:PlanetCommand;
      
      public var planetId:int = 0;
      
      public var planetPct:int = 0;
      
      public var increase:int = 0;
      
      public function PlanetCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.planetId = param1;
         this.planetPct = param2;
         this.increase = param3;
      }
      
      public static function get instance() : PlanetCommand
      {
         return _instance || (_instance = new PlanetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15614;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.planetId = param1.readInt();
         this.planetId = this.planetId << 1 % 32 | this.planetId >>> 32 - 1 % 32;
         this.planetPct = param1.readInt();
         this.planetPct = this.planetPct >>> 7 % 32 | this.planetPct << 32 - 7 % 32;
         this.increase = param1.readInt();
         this.increase = this.increase >>> 9 % 32 | this.increase << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15614);
         param1.writeInt(this.planetId >>> 1 % 32 | this.planetId << 32 - 1 % 32);
         param1.writeInt(this.planetPct << 7 % 32 | this.planetPct >>> 32 - 7 % 32);
         param1.writeInt(this.increase << 9 % 32 | this.increase >>> 32 - 9 % 32);
      }
   }
}

