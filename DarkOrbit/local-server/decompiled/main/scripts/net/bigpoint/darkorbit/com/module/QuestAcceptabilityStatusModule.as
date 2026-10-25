package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestAcceptabilityStatusModule implements IModule
   {
      
      private static var _instance:QuestAcceptabilityStatusModule;
      
      public static const ACCEPTABILITYTYPE_NOT_ACCEPTABLE:int = 0;
      
      public static const ACCEPTABILITYTYPE_NOT_STARTED:int = 1;
      
      public static const ACCEPTABILITYTYPE_RUNNING:int = 2;
      
      public static const ACCEPTABILITYTYPE_COMPLETED:int = 3;
      
      public static const ACCEPTABILITYTYPE_DISABLED:int = 4;
      
      public static const ACCEPTABILITYTYPE__MAX:int = 5;
      
      public var type:int = 0;
      
      public function QuestAcceptabilityStatusModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : QuestAcceptabilityStatusModule
      {
         return _instance || (_instance = new QuestAcceptabilityStatusModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10101;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10101);
         param1.writeShort(this.type);
      }
   }
}

