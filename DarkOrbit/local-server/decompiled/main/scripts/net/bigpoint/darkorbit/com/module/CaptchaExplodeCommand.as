package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptchaExplodeCommand implements IModule
   {
      
      private static var _instance:CaptchaExplodeCommand;
      
      public function CaptchaExplodeCommand()
      {
         super();
      }
      
      public static function get instance() : CaptchaExplodeCommand
      {
         return _instance || (_instance = new CaptchaExplodeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18458;
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
         param1.writeShort(18458);
      }
   }
}

