package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArenaMatchEndRequest implements IModule
   {
      
      private static var _instance:ArenaMatchEndRequest;
      
      public function ArenaMatchEndRequest()
      {
         super();
      }
      
      public static function get instance() : ArenaMatchEndRequest
      {
         return _instance || (_instance = new ArenaMatchEndRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16461;
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
         param1.writeShort(-16461);
      }
   }
}

