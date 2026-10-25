package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RefreshSelectedUICategoryCommand implements IModule
   {
      
      private static var _instance:RefreshSelectedUICategoryCommand;
      
      public function RefreshSelectedUICategoryCommand()
      {
         super();
      }
      
      public static function get instance() : RefreshSelectedUICategoryCommand
      {
         return _instance || (_instance = new RefreshSelectedUICategoryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1859;
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
         param1.writeShort(-1859);
      }
   }
}

