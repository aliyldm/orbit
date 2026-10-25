package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InventoryItemUpdatedCommand implements IModule
   {
      
      private static var _instance:InventoryItemUpdatedCommand;
      
      public var item:InventoryItemModule;
      
      public function InventoryItemUpdatedCommand(param1:InventoryItemModule = null)
      {
         super();
         if(param1 == null)
         {
            this.item = new InventoryItemModule();
         }
         else
         {
            this.item = param1;
         }
      }
      
      public static function get instance() : InventoryItemUpdatedCommand
      {
         return _instance || (_instance = new InventoryItemUpdatedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23384;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.item = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.item)
         {
            this.item.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23384);
         if(null != this.item)
         {
            this.item.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

