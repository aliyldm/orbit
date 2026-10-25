package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassSetFilterRequest implements IModule
   {
      
      private static var _instance:BattlePassSetFilterRequest;
      
      public var battlePassWindowSettingsModule:BattlePassWindowSettingsModule;
      
      public function BattlePassSetFilterRequest(param1:BattlePassWindowSettingsModule = null)
      {
         super();
         if(param1 == null)
         {
            this.battlePassWindowSettingsModule = new BattlePassWindowSettingsModule();
         }
         else
         {
            this.battlePassWindowSettingsModule = param1;
         }
      }
      
      public static function get instance() : BattlePassSetFilterRequest
      {
         return _instance || (_instance = new BattlePassSetFilterRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17140;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battlePassWindowSettingsModule = BattlePassWindowSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.battlePassWindowSettingsModule)
         {
            this.battlePassWindowSettingsModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17140);
         if(null != this.battlePassWindowSettingsModule)
         {
            this.battlePassWindowSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

