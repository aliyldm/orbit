package net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventReturnOfHeroStatusCommand implements IModule
   {
      
      private static var _instance:EventReturnOfHeroStatusCommand;
      
      public function EventReturnOfHeroStatusCommand()
      {
         super();
      }
      
      public static function get instance() : EventReturnOfHeroStatusCommand
      {
         return _instance || (_instance = new EventReturnOfHeroStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26066;
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
         param1.writeShort(26066);
      }
   }
}

