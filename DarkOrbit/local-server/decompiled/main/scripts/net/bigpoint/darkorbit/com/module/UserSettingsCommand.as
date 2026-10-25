package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserSettingsCommand implements IModule
   {
      
      private static var _instance:UserSettingsCommand;
      
      public var displaySettingsModule:DisplaySettingsModule;
      
      public var windowSettingsModule:WindowSettingsModule;
      
      public var gameplaySettingsModule:GameplaySettingsModule;
      
      public var questSettingsModule:QuestSettingsModule;
      
      public var audioSettingsModule:AudioSettingsModule;
      
      public var qualitySettingsModule:QualitySettingsModule;
      
      public function UserSettingsCommand(param1:QualitySettingsModule = null, param2:DisplaySettingsModule = null, param3:AudioSettingsModule = null, param4:WindowSettingsModule = null, param5:GameplaySettingsModule = null, param6:QuestSettingsModule = null)
      {
         super();
         if(param2 == null)
         {
            this.displaySettingsModule = new DisplaySettingsModule();
         }
         else
         {
            this.displaySettingsModule = param2;
         }
         if(param4 == null)
         {
            this.windowSettingsModule = new WindowSettingsModule();
         }
         else
         {
            this.windowSettingsModule = param4;
         }
         if(param5 == null)
         {
            this.gameplaySettingsModule = new GameplaySettingsModule();
         }
         else
         {
            this.gameplaySettingsModule = param5;
         }
         if(param6 == null)
         {
            this.questSettingsModule = new QuestSettingsModule();
         }
         else
         {
            this.questSettingsModule = param6;
         }
         if(param3 == null)
         {
            this.audioSettingsModule = new AudioSettingsModule();
         }
         else
         {
            this.audioSettingsModule = param3;
         }
         if(param1 == null)
         {
            this.qualitySettingsModule = new QualitySettingsModule();
         }
         else
         {
            this.qualitySettingsModule = param1;
         }
      }
      
      public static function get instance() : UserSettingsCommand
      {
         return _instance || (_instance = new UserSettingsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27265;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.displaySettingsModule = DisplaySettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.displaySettingsModule)
         {
            this.displaySettingsModule.read(param1);
         }
         this.windowSettingsModule = WindowSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.windowSettingsModule)
         {
            this.windowSettingsModule.read(param1);
         }
         this.gameplaySettingsModule = GameplaySettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gameplaySettingsModule)
         {
            this.gameplaySettingsModule.read(param1);
         }
         this.questSettingsModule = QuestSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.questSettingsModule)
         {
            this.questSettingsModule.read(param1);
         }
         this.audioSettingsModule = AudioSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.audioSettingsModule)
         {
            this.audioSettingsModule.read(param1);
         }
         this.qualitySettingsModule = QualitySettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.qualitySettingsModule)
         {
            this.qualitySettingsModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27265);
         if(null != this.displaySettingsModule)
         {
            this.displaySettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.windowSettingsModule)
         {
            this.windowSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.gameplaySettingsModule)
         {
            this.gameplaySettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.questSettingsModule)
         {
            this.questSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.audioSettingsModule)
         {
            this.audioSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.qualitySettingsModule)
         {
            this.qualitySettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

