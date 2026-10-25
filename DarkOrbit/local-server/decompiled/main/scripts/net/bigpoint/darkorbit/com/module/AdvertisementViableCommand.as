package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AdvertisementViableCommand implements IModule
   {
      
      private static var _instance:AdvertisementViableCommand;
      
      public function AdvertisementViableCommand()
      {
         super();
      }
      
      public static function get instance() : AdvertisementViableCommand
      {
         return _instance || (_instance = new AdvertisementViableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 67;
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
         param1.writeShort(67);
      }
   }
}

