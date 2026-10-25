package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class BoosterEquipmentDetailModule extends BoosterDetailModule
   {
      
      private static var _instance:BoosterEquipmentDetailModule;
      
      public var amount:int = 0;
      
      public function BoosterEquipmentDetailModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.amount = param2;
      }
      
      public static function get instance() : BoosterEquipmentDetailModule
      {
         return _instance || (_instance = new BoosterEquipmentDetailModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 23969;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.amount = param1.readInt();
         this.amount = this.amount >>> 5 % 32 | this.amount << 32 - 5 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23969);
         super.write(param1);
         param1.writeInt(this.amount << 5 % 32 | this.amount >>> 32 - 5 % 32);
      }
   }
}

