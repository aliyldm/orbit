package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ArmoryUnlockInfoCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockInfoCommand;
      
      public var normal:ArmoryUnlockLootShowListCommand;
      
      public var selectedClaimInfoGroupCommand:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var claimInfoGroupCommands:Vector.<ArmoryUnlockClaimInfoGroupCommand>;
      
      public var specials:Vector.<ArmoryUnlockLootShowListCommand>;
      
      public var canReset:Boolean = false;
      
      public var eventRemainSeconds:int = 0;
      
      public var selectedGroup:int = 0;
      
      public function ArmoryUnlockInfoCommand(param1:ArmoryUnlockLootShowListCommand = null, param2:Vector.<ArmoryUnlockLootShowListCommand> = null, param3:Vector.<ArmoryUnlockClaimInfoGroupCommand> = null, param4:Vector.<ArmoryUnlockClaimInfoCommand> = null, param5:int = 0, param6:int = 0, param7:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.normal = new ArmoryUnlockLootShowListCommand();
         }
         else
         {
            this.normal = param1;
         }
         if(param4 == null)
         {
            this.selectedClaimInfoGroupCommand = new Vector.<ArmoryUnlockClaimInfoCommand>();
         }
         else
         {
            this.selectedClaimInfoGroupCommand = param4;
         }
         if(param3 == null)
         {
            this.claimInfoGroupCommands = new Vector.<ArmoryUnlockClaimInfoGroupCommand>();
         }
         else
         {
            this.claimInfoGroupCommands = param3;
         }
         if(param2 == null)
         {
            this.specials = new Vector.<ArmoryUnlockLootShowListCommand>();
         }
         else
         {
            this.specials = param2;
         }
         this.canReset = param7;
         this.eventRemainSeconds = param5;
         this.selectedGroup = param6;
      }
      
      public static function get instance() : ArmoryUnlockInfoCommand
      {
         return _instance || (_instance = new ArmoryUnlockInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18999;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 21;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ArmoryUnlockClaimInfoCommand = null;
         var _loc5_:ArmoryUnlockClaimInfoGroupCommand = null;
         var _loc6_:ArmoryUnlockLootShowListCommand = null;
         this.normal = ArmoryUnlockLootShowListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.normal)
         {
            this.normal.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.selectedClaimInfoGroupCommand.length > 0)
         {
            this.selectedClaimInfoGroupCommand.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ArmoryUnlockClaimInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.selectedClaimInfoGroupCommand.push(_loc4_);
            _loc2_++;
         }
         while(this.claimInfoGroupCommands.length > 0)
         {
            this.claimInfoGroupCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ArmoryUnlockClaimInfoGroupCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.claimInfoGroupCommands.push(_loc5_);
            _loc2_++;
         }
         while(this.specials.length > 0)
         {
            this.specials.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = ArmoryUnlockLootShowListCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.specials.push(_loc6_);
            _loc2_++;
         }
         this.canReset = param1.readBoolean();
         this.eventRemainSeconds = param1.readInt();
         this.eventRemainSeconds = this.eventRemainSeconds << 5 % 32 | this.eventRemainSeconds >>> 32 - 5 % 32;
         this.selectedGroup = param1.readInt();
         this.selectedGroup = this.selectedGroup << 16 % 32 | this.selectedGroup >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ArmoryUnlockClaimInfoCommand = null;
         var _loc3_:ArmoryUnlockClaimInfoGroupCommand = null;
         var _loc4_:ArmoryUnlockLootShowListCommand = null;
         param1.writeShort(18999);
         if(null != this.normal)
         {
            this.normal.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.selectedClaimInfoGroupCommand.length);
         for each(_loc2_ in this.selectedClaimInfoGroupCommand)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.claimInfoGroupCommands.length);
         for each(_loc3_ in this.claimInfoGroupCommands)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.specials.length);
         for each(_loc4_ in this.specials)
         {
            _loc4_.write(param1);
         }
         param1.writeBoolean(this.canReset);
         param1.writeInt(this.eventRemainSeconds >>> 5 % 32 | this.eventRemainSeconds << 32 - 5 % 32);
         param1.writeInt(this.selectedGroup >>> 16 % 32 | this.selectedGroup << 32 - 16 % 32);
      }
   }
}

