package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipDroneView implements IModule
   {
      
      private static var _instance:HangarShipDroneView;
      
      public var position:int = 0;
      
      public var damage:Number = 0;
      
      public var droneId:int = 0;
      
      public var points:int = 0;
      
      public var level:int = 0;
      
      public var lootId:String = "";
      
      public var nextLevel:int = 0;
      
      public var droneTypeId:int = 0;
      
      public function HangarShipDroneView(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:Number = 0, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.position = param8;
         this.damage = param5;
         this.droneId = param2;
         this.points = param6;
         this.level = param4;
         this.lootId = param1;
         this.nextLevel = param7;
         this.droneTypeId = param3;
      }
      
      public static function get instance() : HangarShipDroneView
      {
         return _instance || (_instance = new HangarShipDroneView());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4465;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 30;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.position = param1.readInt();
         this.position = this.position >>> 4 % 32 | this.position << 32 - 4 % 32;
         this.damage = param1.readFloat();
         this.droneId = param1.readInt();
         this.droneId = this.droneId >>> 16 % 32 | this.droneId << 32 - 16 % 32;
         this.points = param1.readInt();
         this.points = this.points << 11 % 32 | this.points >>> 32 - 11 % 32;
         this.level = param1.readInt();
         this.level = this.level >>> 5 % 32 | this.level << 32 - 5 % 32;
         this.lootId = param1.readUTF();
         this.nextLevel = param1.readInt();
         this.nextLevel = this.nextLevel << 5 % 32 | this.nextLevel >>> 32 - 5 % 32;
         this.droneTypeId = param1.readInt();
         this.droneTypeId = this.droneTypeId << 12 % 32 | this.droneTypeId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4465);
         param1.writeInt(this.position << 4 % 32 | this.position >>> 32 - 4 % 32);
         param1.writeFloat(this.damage);
         param1.writeInt(this.droneId << 16 % 32 | this.droneId >>> 32 - 16 % 32);
         param1.writeInt(this.points >>> 11 % 32 | this.points << 32 - 11 % 32);
         param1.writeInt(this.level << 5 % 32 | this.level >>> 32 - 5 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.nextLevel >>> 5 % 32 | this.nextLevel << 32 - 5 % 32);
         param1.writeInt(this.droneTypeId >>> 12 % 32 | this.droneTypeId << 32 - 12 % 32);
      }
   }
}

