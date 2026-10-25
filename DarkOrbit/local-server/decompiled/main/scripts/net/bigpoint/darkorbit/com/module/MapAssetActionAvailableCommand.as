package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapAssetActionAvailableCommand implements IModule
   {
      
      private static var _instance:MapAssetActionAvailableCommand;
      
      public static const AVAILABILITYSTATE_ON:int = 0;
      
      public static const AVAILABILITYSTATE_OFF:int = 1;
      
      public static const AVAILABILITYSTATE__MAX:int = 2;
      
      public var mapAssetId:int = 0;
      
      public var state:int = 0;
      
      public var activatable:Boolean = false;
      
      public var toolTip:MessageKeyListWildcardCommand;
      
      public var additionalInformation:AssetInformationModule;
      
      public function MapAssetActionAvailableCommand(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:MessageKeyListWildcardCommand = null, param5:AssetInformationModule = null)
      {
         super();
         this.mapAssetId = param1;
         this.state = param2;
         this.activatable = param3;
         if(param4 == null)
         {
            this.toolTip = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.toolTip = param4;
         }
         if(param5 == null)
         {
            this.additionalInformation = new AssetInformationModule();
         }
         else
         {
            this.additionalInformation = param5;
         }
      }
      
      public static function get instance() : MapAssetActionAvailableCommand
      {
         return _instance || (_instance = new MapAssetActionAvailableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6530;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId << 12 % 32 | this.mapAssetId >>> 32 - 12 % 32;
         this.state = param1.readShort();
         this.activatable = param1.readBoolean();
         this.toolTip = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTip)
         {
            this.toolTip.read(param1);
         }
         this.additionalInformation = AssetInformationModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.additionalInformation)
         {
            this.additionalInformation.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6530);
         param1.writeInt(this.mapAssetId >>> 12 % 32 | this.mapAssetId << 32 - 12 % 32);
         param1.writeShort(this.state);
         param1.writeBoolean(this.activatable);
         if(null != this.toolTip)
         {
            this.toolTip.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.additionalInformation)
         {
            this.additionalInformation.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

