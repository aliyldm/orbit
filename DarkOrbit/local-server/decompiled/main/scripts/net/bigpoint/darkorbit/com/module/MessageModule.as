package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageModule implements IModule
   {
      
      private static var _instance:MessageModule;
      
      public function MessageModule()
      {
         super();
      }
      
      public static function get instance() : MessageModule
      {
         return _instance || (_instance = new MessageModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15973;
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
         param1.writeShort(-15973);
      }
   }
}

