package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapRemovePOICommand implements IModule
   {
      
      private static var _instance:MapRemovePOICommand;
      
      public var poiId:String = "";
      
      public function MapRemovePOICommand(param1:String = "")
      {
         super();
         this.poiId = param1;
      }
      
      public static function get instance() : MapRemovePOICommand
      {
         return _instance || (_instance = new MapRemovePOICommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6676;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.poiId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6676);
         param1.writeUTF(this.poiId);
      }
   }
}

