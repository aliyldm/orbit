package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.events.*;
   
   public class ArmoryUnlockLootShowListCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockLootShowListCommand;
      
      public var showLootCommandList:Vector.<ArmoryUnlockLootShowCommand>;
      
      public var group:int = 0;
      
      public var claimInfoCommandList:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var shipLootId:String = "";
      
      public var probabilityModuleList:Vector.<LootProbabilityModule>;
      
      public var resourceLootId:String = "";
      
      public var resourceAmount:int = 0;
      
      public function ArmoryUnlockLootShowListCommand(param1:int = 0, param2:Vector.<ArmoryUnlockClaimInfoCommand> = null, param3:String = "", param4:int = 0, param5:String = "", param6:Vector.<ArmoryUnlockLootShowCommand> = null, param7:Vector.<LootProbabilityModule> = null)
      {
         super();
         if(param6 == null)
         {
            this.showLootCommandList = new Vector.<ArmoryUnlockLootShowCommand>();
         }
         else
         {
            this.showLootCommandList = param6;
         }
         this.group = param1;
         if(param2 == null)
         {
            this.claimInfoCommandList = new Vector.<ArmoryUnlockClaimInfoCommand>();
         }
         else
         {
            this.claimInfoCommandList = param2;
         }
         this.shipLootId = param3;
         if(param7 == null)
         {
            this.probabilityModuleList = new Vector.<LootProbabilityModule>();
         }
         else
         {
            this.probabilityModuleList = param7;
         }
         this.resourceLootId = param5;
         this.resourceAmount = param4;
      }
      
      public static function get instance() : ArmoryUnlockLootShowListCommand
      {
         return _instance || (_instance = new ArmoryUnlockLootShowListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21051;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ArmoryUnlockLootShowCommand = null;
         var _loc5_:ArmoryUnlockClaimInfoCommand = null;
         var _loc6_:LootProbabilityModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.showLootCommandList.length > 0)
         {
            this.showLootCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ArmoryUnlockLootShowCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.showLootCommandList.push(_loc4_);
            _loc2_++;
         }
         this.group = param1.readInt();
         this.group = this.group >>> 12 % 32 | this.group << 32 - 12 % 32;
         while(this.claimInfoCommandList.length > 0)
         {
            this.claimInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ArmoryUnlockClaimInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.claimInfoCommandList.push(_loc5_);
            _loc2_++;
         }
         this.shipLootId = param1.readUTF();
         while(this.probabilityModuleList.length > 0)
         {
            this.probabilityModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = LootProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.probabilityModuleList.push(_loc6_);
            _loc2_++;
         }
         this.resourceLootId = param1.readUTF();
         this.resourceAmount = param1.readInt();
         this.resourceAmount = this.resourceAmount >>> 3 % 32 | this.resourceAmount << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ArmoryUnlockLootShowCommand = null;
         var _loc3_:ArmoryUnlockClaimInfoCommand = null;
         var _loc4_:LootProbabilityModule = null;
         param1.writeShort(21051);
         param1.writeByte(this.showLootCommandList.length);
         for each(_loc2_ in this.showLootCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.group << 12 % 32 | this.group >>> 32 - 12 % 32);
         param1.writeByte(this.claimInfoCommandList.length);
         for each(_loc3_ in this.claimInfoCommandList)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.shipLootId);
         param1.writeByte(this.probabilityModuleList.length);
         for each(_loc4_ in this.probabilityModuleList)
         {
            _loc4_.write(param1);
         }
         param1.writeUTF(this.resourceLootId);
         param1.writeInt(this.resourceAmount << 3 % 32 | this.resourceAmount >>> 32 - 3 % 32);
      }
   }
}

