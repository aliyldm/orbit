package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventANewHopeStatusCommand implements IModule
   {
      
      private static var _instance:EventANewHopeStatusCommand;
      
      public function EventANewHopeStatusCommand()
      {
         super();
      }
      
      public static function get instance() : EventANewHopeStatusCommand
      {
         return _instance || (_instance = new EventANewHopeStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8508;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8508);
      }
   }
}

