package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UICamLockToHeroCommand implements IModule
   {
      
      private static var _instance:UICamLockToHeroCommand;
      
      public function UICamLockToHeroCommand()
      {
         super();
      }
      
      public static function get instance() : UICamLockToHeroCommand
      {
         return _instance || (_instance = new UICamLockToHeroCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 112;
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
         param1.writeShort(112);
      }
   }
}

