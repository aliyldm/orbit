package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrinityTrialsUIRequest implements IModule
   {
      
      private static var _instance:TrinityTrialsUIRequest;
      
      public static const OPTIONALTYPE_INIT:int = 0;
      
      public static const OPTIONALTYPE_PASS:int = 1;
      
      public static const OPTIONALTYPE_DROP_LEVEL:int = 2;
      
      public static const OPTIONALTYPE__MAX:int = 3;
      
      public var optionalType:int = 0;
      
      public function TrinityTrialsUIRequest(param1:int = 0)
      {
         super();
         this.optionalType = param1;
      }
      
      public static function get instance() : TrinityTrialsUIRequest
      {
         return _instance || (_instance = new TrinityTrialsUIRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21996;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.optionalType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21996);
         param1.writeShort(this.optionalType);
      }
   }
}

