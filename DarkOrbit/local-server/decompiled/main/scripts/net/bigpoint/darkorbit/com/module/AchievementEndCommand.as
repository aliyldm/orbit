package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementEndCommand implements IModule
   {
      
      private static var _instance:AchievementEndCommand;
      
      public function AchievementEndCommand()
      {
         super();
      }
      
      public static function get instance() : AchievementEndCommand
      {
         return _instance || (_instance = new AchievementEndCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 108;
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
         param1.writeShort(108);
      }
   }
}

