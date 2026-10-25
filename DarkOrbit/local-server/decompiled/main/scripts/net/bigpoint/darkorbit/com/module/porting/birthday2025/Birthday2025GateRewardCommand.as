package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.events.*;
   
   public class Birthday2025GateRewardCommand implements IModule
   {
      
      private static var _instance:Birthday2025GateRewardCommand;
      
      public var level:int = 0;
      
      public var lootProbabilityModuleList:Vector.<LootProbabilityModule>;
      
      public var costAmount:int = 0;
      
      public var costLootId:String = "";
      
      public var lootShowCommandList:Vector.<EventLootShowCommand>;
      
      public function Birthday2025GateRewardCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:Vector.<EventLootShowCommand> = null, param5:Vector.<LootProbabilityModule> = null)
      {
         super();
         this.level = param1;
         if(param5 == null)
         {
            this.lootProbabilityModuleList = new Vector.<LootProbabilityModule>();
         }
         else
         {
            this.lootProbabilityModuleList = param5;
         }
         this.costAmount = param2;
         this.costLootId = param3;
         if(param4 == null)
         {
            this.lootShowCommandList = new Vector.<EventLootShowCommand>();
         }
         else
         {
            this.lootShowCommandList = param4;
         }
      }
      
      public static function get instance() : Birthday2025GateRewardCommand
      {
         return _instance || (_instance = new Birthday2025GateRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31883;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootProbabilityModule = null;
         var _loc5_:EventLootShowCommand = null;
         this.level = param1.readInt();
         this.level = this.level << 8 % 32 | this.level >>> 32 - 8 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lootProbabilityModuleList.length > 0)
         {
            this.lootProbabilityModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.lootProbabilityModuleList.push(_loc4_);
            _loc2_++;
         }
         this.costAmount = param1.readInt();
         this.costAmount = this.costAmount << 4 % 32 | this.costAmount >>> 32 - 4 % 32;
         this.costLootId = param1.readUTF();
         while(this.lootShowCommandList.length > 0)
         {
            this.lootShowCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = EventLootShowCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.lootShowCommandList.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootProbabilityModule = null;
         var _loc3_:EventLootShowCommand = null;
         param1.writeShort(31883);
         param1.writeInt(this.level >>> 8 % 32 | this.level << 32 - 8 % 32);
         param1.writeByte(this.lootProbabilityModuleList.length);
         for each(_loc2_ in this.lootProbabilityModuleList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.costAmount >>> 4 % 32 | this.costAmount << 32 - 4 % 32);
         param1.writeUTF(this.costLootId);
         param1.writeByte(this.lootShowCommandList.length);
         for each(_loc3_ in this.lootShowCommandList)
         {
            _loc3_.write(param1);
         }
      }
   }
}

