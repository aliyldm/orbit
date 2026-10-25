package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipRenamePetRequest implements IModule
   {
      
      private static var _instance:HangarShipRenamePetRequest;
      
      public var name:String = "";
      
      public function HangarShipRenamePetRequest(param1:String = "")
      {
         super();
         this.name = param1;
      }
      
      public static function get instance() : HangarShipRenamePetRequest
      {
         return _instance || (_instance = new HangarShipRenamePetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7600;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7600);
         param1.writeUTF(this.name);
      }
   }
}

