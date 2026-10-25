package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassMissionModule implements IModule
   {
      
      private static var _instance:SeasonPassMissionModule;
      
      public var missionStatus:SeasonPassMissionStatusModule;
      
      public var questDefinitionModule:QuestDefinitionModule;
      
      public function SeasonPassMissionModule(param1:SeasonPassMissionStatusModule = null, param2:QuestDefinitionModule = null)
      {
         super();
         if(param1 == null)
         {
            this.missionStatus = new SeasonPassMissionStatusModule();
         }
         else
         {
            this.missionStatus = param1;
         }
         if(param2 == null)
         {
            this.questDefinitionModule = new QuestDefinitionModule();
         }
         else
         {
            this.questDefinitionModule = param2;
         }
      }
      
      public static function get instance() : SeasonPassMissionModule
      {
         return _instance || (_instance = new SeasonPassMissionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22282;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.missionStatus = SeasonPassMissionStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.missionStatus)
         {
            this.missionStatus.read(param1);
         }
         this.questDefinitionModule = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.questDefinitionModule)
         {
            this.questDefinitionModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22282);
         if(null != this.missionStatus)
         {
            this.missionStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.questDefinitionModule)
         {
            this.questDefinitionModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

