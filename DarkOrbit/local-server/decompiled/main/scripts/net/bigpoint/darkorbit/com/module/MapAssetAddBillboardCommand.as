package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapAssetAddBillboardCommand implements IModule
   {
      
      private static var _instance:MapAssetAddBillboardCommand;
      
      public var hash:String = "";
      
      public var type:AssetTypeModule;
      
      public var partnerType:PartnerTypeModule;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var uid:int = 0;
      
      public function MapAssetAddBillboardCommand(param1:String = "", param2:AssetTypeModule = null, param3:PartnerTypeModule = null, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.hash = param1;
         if(param2 == null)
         {
            this.type = new AssetTypeModule();
         }
         else
         {
            this.type = param2;
         }
         if(param3 == null)
         {
            this.partnerType = new PartnerTypeModule();
         }
         else
         {
            this.partnerType = param3;
         }
         this.x = param4;
         this.y = param5;
         this.uid = param6;
      }
      
      public static function get instance() : MapAssetAddBillboardCommand
      {
         return _instance || (_instance = new MapAssetAddBillboardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3260;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hash = param1.readUTF();
         this.type = AssetTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
         this.partnerType = PartnerTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.partnerType)
         {
            this.partnerType.read(param1);
         }
         this.x = param1.readInt();
         this.x = this.x << 1 % 32 | this.x >>> 32 - 1 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 2 % 32 | this.y << 32 - 2 % 32;
         this.uid = param1.readInt();
         this.uid = this.uid >>> 9 % 32 | this.uid << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3260);
         param1.writeUTF(this.hash);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.partnerType)
         {
            this.partnerType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.x >>> 1 % 32 | this.x << 32 - 1 % 32);
         param1.writeInt(this.y << 2 % 32 | this.y >>> 32 - 2 % 32);
         param1.writeInt(this.uid << 9 % 32 | this.uid >>> 32 - 9 % 32);
      }
   }
}

