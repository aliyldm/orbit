package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipSelectionCommand implements IModule
   {
      
      private static var _instance:ShipSelectionCommand;
      
      public var userId:int = 0;
      
      public var shipType:int = 0;
      
      public var shield:int = 0;
      
      public var shieldMax:int = 0;
      
      public var hitpoints:Number = 0;
      
      public var hitpointsMax:Number = 0;
      
      public var nanoHull:int = 0;
      
      public var maxNanoHull:int = 0;
      
      public var shieldSkill:Boolean = false;
      
      public function ShipSelectionCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Number = 0, param6:Number = 0, param7:int = 0, param8:int = 0, param9:Boolean = false)
      {
         super();
         this.userId = param1;
         this.shipType = param2;
         this.shield = param3;
         this.shieldMax = param4;
         this.hitpoints = param5;
         this.hitpointsMax = param6;
         this.nanoHull = param7;
         this.maxNanoHull = param8;
         this.shieldSkill = param9;
      }
      
      public static function get instance() : ShipSelectionCommand
      {
         return _instance || (_instance = new ShipSelectionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 50;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 41;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId << 8 % 32 | this.userId >>> 32 - 8 % 32;
         this.shipType = param1.readInt();
         this.shipType = this.shipType << 5 % 32 | this.shipType >>> 32 - 5 % 32;
         this.shield = param1.readInt();
         this.shield = this.shield << 7 % 32 | this.shield >>> 32 - 7 % 32;
         this.shieldMax = param1.readInt();
         this.shieldMax = this.shieldMax << 15 % 32 | this.shieldMax >>> 32 - 15 % 32;
         this.hitpoints = param1.readDouble();
         this.hitpointsMax = param1.readDouble();
         this.nanoHull = param1.readInt();
         this.nanoHull = this.nanoHull << 1 % 32 | this.nanoHull >>> 32 - 1 % 32;
         this.maxNanoHull = param1.readInt();
         this.maxNanoHull = this.maxNanoHull << 3 % 32 | this.maxNanoHull >>> 32 - 3 % 32;
         this.shieldSkill = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(50);
         param1.writeInt(this.userId >>> 8 % 32 | this.userId << 32 - 8 % 32);
         param1.writeInt(this.shipType >>> 5 % 32 | this.shipType << 32 - 5 % 32);
         param1.writeInt(this.shield >>> 7 % 32 | this.shield << 32 - 7 % 32);
         param1.writeInt(this.shieldMax >>> 15 % 32 | this.shieldMax << 32 - 15 % 32);
         param1.writeDouble(this.hitpoints);
         param1.writeDouble(this.hitpointsMax);
         param1.writeInt(this.nanoHull >>> 1 % 32 | this.nanoHull << 32 - 1 % 32);
         param1.writeInt(this.maxNanoHull >>> 3 % 32 | this.maxNanoHull << 32 - 3 % 32);
         param1.writeBoolean(this.shieldSkill);
      }
   }
}

