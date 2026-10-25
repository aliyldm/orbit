package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class POIReadyCommand implements IModule
   {
      
      private static var _instance:POIReadyCommand;
      
      public function POIReadyCommand()
      {
         super();
      }
      
      public static function get instance() : POIReadyCommand
      {
         return _instance || (_instance = new POIReadyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6677;
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
         param1.writeShort(6677);
      }
   }
}

