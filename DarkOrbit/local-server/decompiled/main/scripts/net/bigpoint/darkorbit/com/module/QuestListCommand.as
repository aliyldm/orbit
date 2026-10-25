package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestListCommand implements IModule
   {
      
      private static var _instance:QuestListCommand;
      
      public var list:Vector.<QuestSlimInfoModule>;
      
      public var onlyStarter:Boolean = false;
      
      public var maxQuests:int = 0;
      
      public var maxEventQuests:int = 0;
      
      public function QuestListCommand(param1:Vector.<QuestSlimInfoModule> = null, param2:Boolean = false, param3:int = 0, param4:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.list = new Vector.<QuestSlimInfoModule>();
         }
         else
         {
            this.list = param1;
         }
         this.onlyStarter = param2;
         this.maxQuests = param3;
         this.maxEventQuests = param4;
      }
      
      public static function get instance() : QuestListCommand
      {
         return _instance || (_instance = new QuestListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2075;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestSlimInfoModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestSlimInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
         this.onlyStarter = param1.readBoolean();
         this.maxQuests = param1.readInt();
         this.maxQuests = this.maxQuests >>> 11 % 32 | this.maxQuests << 32 - 11 % 32;
         this.maxEventQuests = param1.readInt();
         this.maxEventQuests = this.maxEventQuests >>> 15 % 32 | this.maxEventQuests << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestSlimInfoModule = null;
         param1.writeShort(2075);
         param1.writeShort(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.onlyStarter);
         param1.writeInt(this.maxQuests << 11 % 32 | this.maxQuests >>> 32 - 11 % 32);
         param1.writeInt(this.maxEventQuests << 15 % 32 | this.maxEventQuests >>> 32 - 15 % 32);
      }
   }
}

