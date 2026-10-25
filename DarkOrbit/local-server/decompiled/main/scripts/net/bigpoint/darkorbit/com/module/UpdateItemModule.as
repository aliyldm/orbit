package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpdateItemModule implements IModule
   {
      
      private static var _instance:UpdateItemModule;
      
      public var itemToUpdate:LabItemModule;
      
      public var oreCountToUpdateWith:OreCountModule;
      
      public function UpdateItemModule(param1:LabItemModule = null, param2:OreCountModule = null)
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
            this.oreCountToUpdateWith = new OreCountModule();
         }
         else
         {
            this.oreCountToUpdateWith = param2;
         }
      }
      
      public static function get instance() : UpdateItemModule
      {
         return _instance || (_instance = new UpdateItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 136;
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
         this.oreCountToUpdateWith = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oreCountToUpdateWith)
         {
            this.oreCountToUpdateWith.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(136);
         if(null != this.itemToUpdate)
         {
            this.itemToUpdate.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.oreCountToUpdateWith)
         {
            this.oreCountToUpdateWith.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

