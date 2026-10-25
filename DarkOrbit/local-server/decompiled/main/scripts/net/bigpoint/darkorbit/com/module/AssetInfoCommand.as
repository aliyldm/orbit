package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssetInfoCommand implements IModule
   {
      
      private static var _instance:AssetInfoCommand;
      
      public var assetId:int = 0;
      
      public var type:AssetTypeModule;
      
      public var designId:int = 0;
      
      public var expansionStage:int = 0;
      
      public var hitpoints:Number = 0;
      
      public var maxHitpoints:Number = 0;
      
      public var shielded:Boolean = false;
      
      public var shieldEnergy:int = 0;
      
      public var maxShieldEnergy:int = 0;
      
      public function AssetInfoCommand(param1:int = 0, param2:AssetTypeModule = null, param3:int = 0, param4:int = 0, param5:Number = 0, param6:Number = 0, param7:Boolean = false, param8:int = 0, param9:int = 0)
      {
         super();
         this.assetId = param1;
         if(param2 == null)
         {
            this.type = new AssetTypeModule();
         }
         else
         {
            this.type = param2;
         }
         this.designId = param3;
         this.expansionStage = param4;
         this.hitpoints = param5;
         this.maxHitpoints = param6;
         this.shielded = param7;
         this.shieldEnergy = param8;
         this.maxShieldEnergy = param9;
      }
      
      public static function get instance() : AssetInfoCommand
      {
         return _instance || (_instance = new AssetInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 80;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 37;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.assetId = param1.readInt();
         this.assetId = this.assetId << 4 % 32 | this.assetId >>> 32 - 4 % 32;
         this.type = AssetTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
         this.designId = param1.readInt();
         this.designId = this.designId << 9 % 32 | this.designId >>> 32 - 9 % 32;
         this.expansionStage = param1.readInt();
         this.expansionStage = this.expansionStage >>> 2 % 32 | this.expansionStage << 32 - 2 % 32;
         this.hitpoints = param1.readDouble();
         this.maxHitpoints = param1.readDouble();
         this.shielded = param1.readBoolean();
         this.shieldEnergy = param1.readInt();
         this.shieldEnergy = this.shieldEnergy << 11 % 32 | this.shieldEnergy >>> 32 - 11 % 32;
         this.maxShieldEnergy = param1.readInt();
         this.maxShieldEnergy = this.maxShieldEnergy << 12 % 32 | this.maxShieldEnergy >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(80);
         param1.writeInt(this.assetId >>> 4 % 32 | this.assetId << 32 - 4 % 32);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.designId >>> 9 % 32 | this.designId << 32 - 9 % 32);
         param1.writeInt(this.expansionStage << 2 % 32 | this.expansionStage >>> 32 - 2 % 32);
         param1.writeDouble(this.hitpoints);
         param1.writeDouble(this.maxHitpoints);
         param1.writeBoolean(this.shielded);
         param1.writeInt(this.shieldEnergy >>> 11 % 32 | this.shieldEnergy << 32 - 11 % 32);
         param1.writeInt(this.maxShieldEnergy >>> 12 % 32 | this.maxShieldEnergy << 32 - 12 % 32);
      }
   }
}

