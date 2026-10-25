package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapAssetIconAddHighlightCommand implements IModule
   {
      
      private static var _instance:MapAssetIconAddHighlightCommand;
      
      public var soundModule:SoundTriggerModule;
      
      public var mapAssetId:int = 0;
      
      public function MapAssetIconAddHighlightCommand(param1:int = 0, param2:SoundTriggerModule = null)
      {
         super();
         if(param2 == null)
         {
            this.soundModule = new SoundTriggerModule();
         }
         else
         {
            this.soundModule = param2;
         }
         this.mapAssetId = param1;
      }
      
      public static function get instance() : MapAssetIconAddHighlightCommand
      {
         return _instance || (_instance = new MapAssetIconAddHighlightCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5026;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.soundModule = SoundTriggerModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.soundModule)
         {
            this.soundModule.read(param1);
         }
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId << 2 % 32 | this.mapAssetId >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5026);
         if(null != this.soundModule)
         {
            this.soundModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.mapAssetId >>> 2 % 32 | this.mapAssetId << 32 - 2 % 32);
      }
   }
}

