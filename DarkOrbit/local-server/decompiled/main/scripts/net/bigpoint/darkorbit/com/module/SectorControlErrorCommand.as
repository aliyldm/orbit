package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlErrorCommand implements IModule
   {
      
      private static var _instance:SectorControlErrorCommand;
      
      public static const ERRORTYPE_LEVEL_TOO_LOW:int = 0;
      
      public static const ERRORTYPE_NO_TICKETS_LEFT:int = 1;
      
      public static const ERRORTYPE_QUEUE_FULL:int = 2;
      
      public static const ERRORTYPE__MAX:int = 3;
      
      public var errorType:int = 0;
      
      public function SectorControlErrorCommand(param1:int = 0)
      {
         super();
         this.errorType = param1;
      }
      
      public static function get instance() : SectorControlErrorCommand
      {
         return _instance || (_instance = new SectorControlErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7123;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7123);
         param1.writeShort(this.errorType);
      }
   }
}

