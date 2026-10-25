package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LabUpdateItemRequest implements IModule
   {
      
      private static var _instance:LabUpdateItemRequest;
      
      public var itemToUpdate:LabItemModule;
      
      public var updateWith:OreCountModule;
      
      public function LabUpdateItemRequest(param1:LabItemModule = null, param2:OreCountModule = null)
      {
         super();
         if(param1 == null)
         {
            this.itemToUpdate = new LabItemModule();
         }
         else
         {
            this.itemToUpdate = param1;
         }
         if(param2 == null)
         {
            this.updateWith = new OreCountModule();
         }
         else
         {
            this.updateWith = param2;
         }
      }
      
      public static function get instance() : LabUpdateItemRequest
      {
         return _instance || (_instance = new LabUpdateItemRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 133;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemToUpdate = LabItemModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.itemToUpdate)
         {
            this.itemToUpdate.read(param1);
         }
         this.updateWith = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.updateWith)
         {
            this.updateWith.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(133);
         if(null != this.itemToUpdate)
         {
            this.itemToUpdate.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.updateWith)
         {
            this.updateWith.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

