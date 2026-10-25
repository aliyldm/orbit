package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetRequest implements IModule
   {
      
      private static var _instance:PetRequest;
      
      public static const PETREQUESTTYPE_LAUNCH:int = 0;
      
      public static const PETREQUESTTYPE_DEACTIVATE:int = 1;
      
      public static const PETREQUESTTYPE_TOGGLE_ACTIVATION:int = 2;
      
      public static const PETREQUESTTYPE_HOTKEY_GUARD_MODE:int = 3;
      
      public static const PETREQUESTTYPE_REPAIR_DESTROYED_PET:int = 4;
      
      public static const PETREQUESTTYPE_HOTKEY_REPAIR_SHIP:int = 5;
      
      public static const PETREQUESTTYPE_HOTKEY_BUY_FUEL:int = 6;
      
      public static const PETREQUESTTYPE__MAX:int = 7;
      
      public var petRequestType:int = 0;
      
      public function PetRequest(param1:int = 0)
      {
         super();
         this.petRequestType = param1;
      }
      
      public static function get instance() : PetRequest
      {
         return _instance || (_instance = new PetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 153;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petRequestType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(153);
         param1.writeShort(this.petRequestType);
      }
   }
}

