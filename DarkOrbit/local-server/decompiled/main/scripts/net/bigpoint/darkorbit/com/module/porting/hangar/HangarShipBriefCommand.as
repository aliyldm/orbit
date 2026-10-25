package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipBriefCommand implements IModule
   {
      
      private static var _instance:HangarShipBriefCommand;
      
      public var isActive:Boolean = false;
      
      public var lootId:String = "";
      
      public var shipId:Number = 0;
      
      public var isFavorite:Boolean = false;
      
      public function HangarShipBriefCommand(param1:Number = 0, param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.isActive = param3;
         this.lootId = param2;
         this.shipId = param1;
         this.isFavorite = param4;
      }
      
      public static function get instance() : HangarShipBriefCommand
      {
         return _instance || (_instance = new HangarShipBriefCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9323;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isActive = param1.readBoolean();
         this.lootId = param1.readUTF();
         this.shipId = param1.readDouble();
         this.isFavorite = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9323);
         param1.writeBoolean(this.isActive);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.shipId);
         param1.writeBoolean(this.isFavorite);
      }
   }
}

