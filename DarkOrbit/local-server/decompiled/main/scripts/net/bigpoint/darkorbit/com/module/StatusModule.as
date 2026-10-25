package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StatusModule implements IModule
   {
      
      private static var _instance:StatusModule;
      
      public static const TECHSTATUS_CRAFTING:int = 0;
      
      public static const TECHSTATUS_READY:int = 1;
      
      public static const TECHSTATUS_ACTIVE:int = 2;
      
      public static const TECHSTATUS_COOLING_DOWN:int = 3;
      
      public static const TECHSTATUS_INACTIVE:int = 4;
      
      public static const TECHSTATUS__MAX:int = 5;
      
      public function StatusModule()
      {
         super();
      }
      
      public static function get instance() : StatusModule
      {
         return _instance || (_instance = new StatusModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 70;
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
         param1.writeShort(70);
      }
   }
}

