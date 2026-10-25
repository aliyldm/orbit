package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClearMarkersCommand implements IModule
   {
      
      private static var _instance:ClearMarkersCommand;
      
      public function ClearMarkersCommand()
      {
         super();
      }
      
      public static function get instance() : ClearMarkersCommand
      {
         return _instance || (_instance = new ClearMarkersCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 871;
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
         param1.writeShort(871);
      }
   }
}

