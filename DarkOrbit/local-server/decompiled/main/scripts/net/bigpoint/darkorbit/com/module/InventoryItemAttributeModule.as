package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InventoryItemAttributeModule implements IModule
   {
      
      private static var _instance:InventoryItemAttributeModule;
      
      public static const INVENTORYITEMATTRIBUTEKEY_HP:int = 0;
      
      public static const INVENTORYITEMATTRIBUTEKEY_LEVEL:int = 1;
      
      public static const INVENTORYITEMATTRIBUTEKEY_AUTO_BUY_ITEM:int = 2;
      
      public static const INVENTORYITEMATTRIBUTEKEY__MAX:int = 3;
      
      public var key:int = 0;
      
      public var value:String = "";
      
      public function InventoryItemAttributeModule(param1:int = 0, param2:String = "")
      {
         super();
         this.key = param1;
         this.value = param2;
      }
      
      public static function get instance() : InventoryItemAttributeModule
      {
         return _instance || (_instance = new InventoryItemAttributeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -504;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.key = param1.readShort();
         this.value = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-504);
         param1.writeShort(this.key);
         param1.writeUTF(this.value);
      }
   }
}

