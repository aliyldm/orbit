package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EpicFightMessageModule implements IModule
   {
      
      private static var _instance:EpicFightMessageModule;
      
      public function EpicFightMessageModule()
      {
         super();
      }
      
      public static function get instance() : EpicFightMessageModule
      {
         return _instance || (_instance = new EpicFightMessageModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21485;
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
         param1.writeShort(21485);
      }
   }
}

