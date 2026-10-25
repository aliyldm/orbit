package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassCaptainLimitCommand implements IModule
   {
      
      private static var _instance:SeasonPassCaptainLimitCommand;
      
      public function SeasonPassCaptainLimitCommand()
      {
         super();
      }
      
      public static function get instance() : SeasonPassCaptainLimitCommand
      {
         return _instance || (_instance = new SeasonPassCaptainLimitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4955;
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
         param1.writeShort(-4955);
      }
   }
}

