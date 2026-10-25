package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpaceStationCommand implements IModule
   {
      
      private static var _instance:SpaceStationCommand;
      
      public var posY:int = 0;
      
      public var peaceRadius:int = 0;
      
      public var id:int = 0;
      
      public var type:int = 0;
      
      public var posX:int = 0;
      
      public function SpaceStationCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.posY = param5;
         this.peaceRadius = param3;
         this.id = param1;
         this.type = param2;
         this.posX = param4;
      }
      
      public static function get instance() : SpaceStationCommand
      {
         return _instance || (_instance = new SpaceStationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31556;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.posY = param1.readInt();
         this.posY = this.posY << 15 % 32 | this.posY >>> 32 - 15 % 32;
         this.peaceRadius = param1.readInt();
         this.peaceRadius = this.peaceRadius >>> 12 % 32 | this.peaceRadius << 32 - 12 % 32;
         this.id = param1.readInt();
         this.id = this.id << 15 % 32 | this.id >>> 32 - 15 % 32;
         this.type = param1.readInt();
         this.type = this.type << 13 % 32 | this.type >>> 32 - 13 % 32;
         this.posX = param1.readInt();
         this.posX = this.posX << 12 % 32 | this.posX >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31556);
         param1.writeInt(this.posY >>> 15 % 32 | this.posY << 32 - 15 % 32);
         param1.writeInt(this.peaceRadius << 12 % 32 | this.peaceRadius >>> 32 - 12 % 32);
         param1.writeInt(this.id >>> 15 % 32 | this.id << 32 - 15 % 32);
         param1.writeInt(this.type >>> 13 % 32 | this.type << 32 - 13 % 32);
         param1.writeInt(this.posX >>> 12 % 32 | this.posX << 32 - 12 % 32);
      }
   }
}

