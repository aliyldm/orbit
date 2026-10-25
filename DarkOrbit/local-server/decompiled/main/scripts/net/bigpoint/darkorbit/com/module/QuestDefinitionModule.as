package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestDefinitionModule implements IModule
   {
      
      private static var _instance:QuestDefinitionModule;
      
      public var id:int = 0;
      
      public var types:Vector.<QuestTypeModule>;
      
      public var rootCase:QuestCaseModule;
      
      public var rewards:Vector.<LootModule>;
      
      public var icons:Vector.<QuestIconModule>;
      
      public var textKeyFoundation:String = "";
      
      public var portraitId:String = "";
      
      public var star:int = 0;
      
      public function QuestDefinitionModule(param1:int = 0, param2:Vector.<QuestTypeModule> = null, param3:QuestCaseModule = null, param4:Vector.<LootModule> = null, param5:Vector.<QuestIconModule> = null, param6:String = "", param7:String = "", param8:int = 0)
      {
         super();
         this.id = param1;
         if(param2 == null)
         {
            this.types = new Vector.<QuestTypeModule>();
         }
         else
         {
            this.types = param2;
         }
         if(param3 == null)
         {
            this.rootCase = new QuestCaseModule();
         }
         else
         {
            this.rootCase = param3;
         }
         if(param4 == null)
         {
            this.rewards = new Vector.<LootModule>();
         }
         else
         {
            this.rewards = param4;
         }
         if(param5 == null)
         {
            this.icons = new Vector.<QuestIconModule>();
         }
         else
         {
            this.icons = param5;
         }
         this.textKeyFoundation = param6;
         this.portraitId = param7;
         this.star = param8;
      }
      
      public static function get instance() : QuestDefinitionModule
      {
         return _instance || (_instance = new QuestDefinitionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2099;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestTypeModule = null;
         var _loc5_:LootModule = null;
         var _loc6_:QuestIconModule = null;
         this.id = param1.readInt();
         this.id = this.id << 15 % 32 | this.id >>> 32 - 15 % 32;
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
         this.rootCase = QuestCaseModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rootCase)
         {
            this.rootCase.read(param1);
         }
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.rewards.push(_loc5_);
            _loc2_++;
         }
         while(this.icons.length > 0)
         {
            this.icons.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = QuestIconModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.icons.push(_loc6_);
            _loc2_++;
         }
         this.textKeyFoundation = param1.readUTF();
         this.portraitId = param1.readUTF();
         this.star = param1.readInt();
         this.star = this.star << 1 % 32 | this.star >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestTypeModule = null;
         var _loc3_:LootModule = null;
         var _loc4_:QuestIconModule = null;
         param1.writeShort(2099);
         param1.writeInt(this.id >>> 15 % 32 | this.id << 32 - 15 % 32);
         param1.writeByte(this.types.length);
         for each(_loc2_ in this.types)
         {
            _loc2_.write(param1);
         }
         if(null != this.rootCase)
         {
            this.rootCase.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.rewards.length);
         for each(_loc3_ in this.rewards)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.icons.length);
         for each(_loc4_ in this.icons)
         {
            _loc4_.write(param1);
         }
         param1.writeUTF(this.textKeyFoundation);
         param1.writeUTF(this.portraitId);
         param1.writeInt(this.star >>> 1 % 32 | this.star << 32 - 1 % 32);
      }
   }
}

