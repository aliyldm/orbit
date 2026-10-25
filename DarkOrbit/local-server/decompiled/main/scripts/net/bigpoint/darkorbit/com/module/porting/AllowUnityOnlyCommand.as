package net.bigpoint.darkorbit.com.module.porting
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AllowUnityOnlyCommand implements IModule
   {
      
      private static var _instance:AllowUnityOnlyCommand;
      
      public function AllowUnityOnlyCommand()
      {
         super();
      }
      
      public static function get instance() : AllowUnityOnlyCommand
      {
         return _instance || (_instance = new AllowUnityOnlyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6768;
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
         param1.writeShort(6768);
      }
   }
}

