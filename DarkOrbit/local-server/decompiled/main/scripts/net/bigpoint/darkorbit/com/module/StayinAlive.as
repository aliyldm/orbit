package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StayinAlive implements IModule
   {
      
      private static var _instance:StayinAlive;
      
      public function StayinAlive()
      {
         super();
      }
      
      public static function get instance() : StayinAlive
      {
         return _instance || (_instance = new StayinAlive());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8427;
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
         param1.writeShort(8427);
      }
   }
}

