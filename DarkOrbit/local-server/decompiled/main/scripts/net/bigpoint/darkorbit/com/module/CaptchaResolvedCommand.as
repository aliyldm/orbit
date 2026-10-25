package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptchaResolvedCommand implements IModule
   {
      
      private static var _instance:CaptchaResolvedCommand;
      
      public function CaptchaResolvedCommand()
      {
         super();
      }
      
      public static function get instance() : CaptchaResolvedCommand
      {
         return _instance || (_instance = new CaptchaResolvedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11117;
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
         param1.writeShort(11117);
      }
   }
}

