package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpToServerCommand implements IModule
   {
      
      private static var _instance:JumpToServerCommand;
      
      public function JumpToServerCommand()
      {
         super();
      }
      
      public static function get instance() : JumpToServerCommand
      {
         return _instance || (_instance = new JumpToServerCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20;
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
         param1.writeShort(20);
      }
   }
}

