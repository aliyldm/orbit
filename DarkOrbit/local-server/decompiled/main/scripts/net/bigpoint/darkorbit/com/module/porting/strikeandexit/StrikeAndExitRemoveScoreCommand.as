package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StrikeAndExitRemoveScoreCommand implements IModule
   {
      
      private static var _instance:StrikeAndExitRemoveScoreCommand;
      
      public function StrikeAndExitRemoveScoreCommand()
      {
         super();
      }
      
      public static function get instance() : StrikeAndExitRemoveScoreCommand
      {
         return _instance || (_instance = new StrikeAndExitRemoveScoreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24105;
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
         param1.writeShort(-24105);
      }
   }
}

