package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InventoryItemModifyCommand implements IModule
   {
      
      private static var _instance:InventoryItemModifyCommand;
      
      public var quantity:Number = 0;
      
      public var itemId:Number = 0;
      
      public var hangarId:Number = 0;
      
      public function InventoryItemModifyCommand(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.quantity = param1;
         this.itemId = param3;
         this.hangarId = param2;
      }
      
      public static function get instance() : InventoryItemModifyCommand
      {
         return _instance || (_instance = new InventoryItemModifyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19117;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.quantity = param1.readDouble();
         this.itemId = param1.readDouble();
         this.hangarId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19117);
         param1.writeDouble(this.quantity);
         param1.writeDouble(this.itemId);
         param1.writeDouble(this.hangarId);
      }
   }
}

