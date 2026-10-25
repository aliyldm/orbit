package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchActiveEventCommand implements IModule
   {
      
      private static var _instance:DispatchActiveEventCommand;
      
      public static const EVENTTYPE_NONE:int = 0;
      
      public static const EVENTTYPE_DISPATCH_DAY:int = 1;
      
      public static const EVENTTYPE_GALAXY_GATE_DAY:int = 2;
      
      public static const EVENTTYPE__MAX:int = 3;
      
      public var activeEvent:int = 0;
      
      public function DispatchActiveEventCommand(param1:int = 0)
      {
         super();
         this.activeEvent = param1;
      }
      
      public static function get instance() : DispatchActiveEventCommand
      {
         return _instance || (_instance = new DispatchActiveEventCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7114;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activeEvent = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7114);
         param1.writeShort(this.activeEvent);
      }
   }
}

