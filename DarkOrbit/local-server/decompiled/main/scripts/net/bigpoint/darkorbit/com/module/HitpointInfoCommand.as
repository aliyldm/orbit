package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HitpointInfoCommand implements IModule
   {
      
      private static var _instance:HitpointInfoCommand;
      
      public var hitpoints:Number = 0;
      
      public var hitpointsMax:Number = 0;
      
      public var nanoHull:int = 0;
      
      public var nanoHullMax:int = 0;
      
      public function HitpointInfoCommand(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.hitpoints = param1;
         this.hitpointsMax = param2;
         this.nanoHull = param3;
         this.nanoHullMax = param4;
      }
      
      public static function get instance() : HitpointInfoCommand
      {
         return _instance || (_instance = new HitpointInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1300;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hitpoints = param1.readDouble();
         this.hitpointsMax = param1.readDouble();
         this.nanoHull = param1.readInt();
         this.nanoHull = this.nanoHull << 13 % 32 | this.nanoHull >>> 32 - 13 % 32;
         this.nanoHullMax = param1.readInt();
         this.nanoHullMax = this.nanoHullMax >>> 6 % 32 | this.nanoHullMax << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1300);
         param1.writeDouble(this.hitpoints);
         param1.writeDouble(this.hitpointsMax);
         param1.writeInt(this.nanoHull >>> 13 % 32 | this.nanoHull << 32 - 13 % 32);
         param1.writeInt(this.nanoHullMax << 6 % 32 | this.nanoHullMax >>> 32 - 6 % 32);
      }
   }
}

