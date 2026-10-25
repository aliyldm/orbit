package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestSlimInfoModule implements IModule
   {
      
      private static var _instance:QuestSlimInfoModule;
      
      public var questId:int = 0;
      
      public var rootCaseId:int = 0;
      
      public var minLevel:int = 0;
      
      public var priority:int = 0;
      
      public var types:Vector.<QuestTypeModule>;
      
      public var icon:QuestIconModule;
      
      public var acceptabilityStatus:QuestAcceptabilityStatusModule;
      
      public var missingAcceptRequirements:Vector.<QuestRequirementModule>;
      
      public var textKeyFoundation:String = "";
      
      public var portraitId:String = "";
      
      public var star:int = 0;
      
      public function QuestSlimInfoModule(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Vector.<QuestTypeModule> = null, param6:QuestIconModule = null, param7:QuestAcceptabilityStatusModule = null, param8:Vector.<QuestRequirementModule> = null, param9:String = "", param10:String = "", param11:int = 0)
      {
         super();
         this.questId = param1;
         this.rootCaseId = param2;
         this.minLevel = param3;
         this.priority = param4;
         if(param5 == null)
         {
            this.types = new Vector.<QuestTypeModule>();
         }
         else
         {
            this.types = param5;
         }
         if(param6 == null)
         {
            this.icon = new QuestIconModule();
         }
         else
         {
            this.icon = param6;
         }
         if(param7 == null)
         {
            this.acceptabilityStatus = new QuestAcceptabilityStatusModule();
         }
         else
         {
            this.acceptabilityStatus = param7;
         }
         if(param8 == null)
         {
            this.missingAcceptRequirements = new Vector.<QuestRequirementModule>();
         }
         else
         {
            this.missingAcceptRequirements = param8;
         }
         this.textKeyFoundation = param9;
         this.portraitId = param10;
         this.star = param11;
      }
      
      public static function get instance() : QuestSlimInfoModule
      {
         return _instance || (_instance = new QuestSlimInfoModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2078;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestTypeModule = null;
         var _loc5_:QuestRequirementModule = null;
         this.questId = param1.readInt();
         this.questId = this.questId << 3 % 32 | this.questId >>> 32 - 3 % 32;
         this.rootCaseId = param1.readInt();
         this.rootCaseId = this.rootCaseId >>> 4 % 32 | this.rootCaseId << 32 - 4 % 32;
         this.minLevel = param1.readInt();
         this.minLevel = this.minLevel >>> 2 % 32 | this.minLevel << 32 - 2 % 32;
         this.priority = param1.readInt();
         this.priority = this.priority >>> 7 % 32 | this.priority << 32 - 7 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.types.length > 0)
         {
            this.types.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.types.push(_loc4_);
            _loc2_++;
         }
         this.icon = QuestIconModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.icon)
         {
            this.icon.read(param1);
         }
         this.acceptabilityStatus = QuestAcceptabilityStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.read(param1);
         }
         while(this.missingAcceptRequirements.length > 0)
         {
            this.missingAcceptRequirements.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = QuestRequirementModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.missingAcceptRequirements.push(_loc5_);
            _loc2_++;
         }
         this.textKeyFoundation = param1.readUTF();
         this.portraitId = param1.readUTF();
         this.star = param1.readInt();
         this.star = this.star << 11 % 32 | this.star >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestTypeModule = null;
         var _loc3_:QuestRequirementModule = null;
         param1.writeShort(2078);
         param1.writeInt(this.questId >>> 3 % 32 | this.questId << 32 - 3 % 32);
         param1.writeInt(this.rootCaseId << 4 % 32 | this.rootCaseId >>> 32 - 4 % 32);
         param1.writeInt(this.minLevel << 2 % 32 | this.minLevel >>> 32 - 2 % 32);
         param1.writeInt(this.priority << 7 % 32 | this.priority >>> 32 - 7 % 32);
         param1.writeByte(this.types.length);
         for each(_loc2_ in this.types)
         {
            _loc2_.write(param1);
         }
         if(null != this.icon)
         {
            this.icon.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.acceptabilityStatus)
         {
            this.acceptabilityStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.missingAcceptRequirements.length);
         for each(_loc3_ in this.missingAcceptRequirements)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.textKeyFoundation);
         param1.writeUTF(this.portraitId);
         param1.writeInt(this.star >>> 11 % 32 | this.star << 32 - 11 % 32);
      }
   }
}

