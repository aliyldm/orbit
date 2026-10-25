package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteDisableEquipCommand implements IModule
   {
      
      private static var _instance:RogueLiteDisableEquipCommand;
      
      public function RogueLiteDisableEquipCommand()
      {
         super();
      }
      
      public static function get instance() : RogueLiteDisableEquipCommand
      {
         return _instance || (_instance = new RogueLiteDisableEquipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13418;
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
         param1.writeShort(13418);
      }
   }
}

