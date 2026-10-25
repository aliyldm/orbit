package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventOreCommand implements IModule
   {
      
      private static var _instance:MapEventOreCommand;
      
      public static const EVENTTYPE_COLLECTION_IN_PROGRESS:int = 0;
      
      public static const EVENTTYPE_COLLECTION_FINISHED:int = 1;
      
      public static const EVENTTYPE_COLLECTION_FAILED_CARGO_FULL:int = 2;
      
      public static const EVENTTYPE_COLLECTION_FAILED_ALREADY_COLLECTED:int = 3;
      
      public static const EVENTTYPE__MAX:int = 4;
      
      public var eventType:int = 0;
      
      public var oreType:OreTypeModule;
      
      public var hash:String = "";
      
      public function MapEventOreCommand(param1:int = 0, param2:OreTypeModule = null, param3:String = "")
      {
         super();
         this.eventType = param1;
         if(param2 == null)
         {
            this.oreType = new OreTypeModule();
         }
         else
         {
            this.oreType = param2;
         }
         this.hash = param3;
      }
      
      public static function get instance() : MapEventOreCommand
      {
         return _instance || (_instance = new MapEventOreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 143;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventType = param1.readShort();
         this.oreType = OreTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oreType)
         {
            this.oreType.read(param1);
         }
         this.hash = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(143);
         param1.writeShort(this.eventType);
         if(null != this.oreType)
         {
            this.oreType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.hash);
      }
   }
}

