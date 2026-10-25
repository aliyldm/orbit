package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMCollectExperiencePointsCommand implements IModule
   {
      
      private static var _instance:LMCollectExperiencePointsCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var collectedAmount:int = 0;
      
      public var summedAmount:int = 0;
      
      public var currentLevel:int = 0;
      
      public function LMCollectExperiencePointsCommand(param1:LogMessengerPriorityModule = null, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         this.collectedAmount = param2;
         this.summedAmount = param3;
         this.currentLevel = param4;
      }
      
      public static function get instance() : LMCollectExperiencePointsCommand
      {
         return _instance || (_instance = new LMCollectExperiencePointsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 208;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.collectedAmount = param1.readInt();
         this.collectedAmount = this.collectedAmount >>> 1 % 32 | this.collectedAmount << 32 - 1 % 32;
         this.summedAmount = param1.readInt();
         this.summedAmount = this.summedAmount << 3 % 32 | this.summedAmount >>> 32 - 3 % 32;
         this.currentLevel = param1.readInt();
         this.currentLevel = this.currentLevel << 12 % 32 | this.currentLevel >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(208);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.collectedAmount << 1 % 32 | this.collectedAmount >>> 32 - 1 % 32);
         param1.writeInt(this.summedAmount >>> 3 % 32 | this.summedAmount << 32 - 3 % 32);
         param1.writeInt(this.currentLevel >>> 12 % 32 | this.currentLevel << 32 - 12 % 32);
      }
   }
}

