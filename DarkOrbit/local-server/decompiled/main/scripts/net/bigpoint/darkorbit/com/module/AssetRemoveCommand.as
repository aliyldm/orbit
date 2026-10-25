package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssetRemoveCommand implements IModule
   {
      
      private static var _instance:AssetRemoveCommand;
      
      public var assetType:AssetTypeModule;
      
      public var uid:int = 0;
      
      public function AssetRemoveCommand(param1:AssetTypeModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.assetType = new AssetTypeModule();
         }
         else
         {
            this.assetType = param1;
         }
         this.uid = param2;
      }
      
      public static function get instance() : AssetRemoveCommand
      {
         return _instance || (_instance = new AssetRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3245;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.assetType = AssetTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.assetType)
         {
            this.assetType.read(param1);
         }
         this.uid = param1.readInt();
         this.uid = this.uid >>> 16 % 32 | this.uid << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3245);
         if(null != this.assetType)
         {
            this.assetType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.uid << 16 % 32 | this.uid >>> 32 - 16 % 32);
      }
   }
}

