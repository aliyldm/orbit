package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TimerStateModule implements IModule
   {
      
      private static var _instance:TimerStateModule;
      
      public static const TIMERSTATE_READY:int = 0;
      
      public static const TIMERSTATE_ACTIVE:int = 1;
      
      public static const TIMERSTATE_COOLING_DOWN:int = 2;
      
      public static const TIMERSTATE__MAX:int = 3;
      
      public var timerStateValue:int = 0;
      
      public function TimerStateModule(param1:int = 0)
      {
         super();
         this.timerStateValue = param1;
      }
      
      public static function get instance() : TimerStateModule
      {
         return _instance || (_instance = new TimerStateModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1880;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timerStateValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1880);
         param1.writeShort(this.timerStateValue);
      }
   }
}

