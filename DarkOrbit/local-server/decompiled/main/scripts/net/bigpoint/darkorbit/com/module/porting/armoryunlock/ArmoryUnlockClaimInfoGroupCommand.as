package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ArmoryUnlockClaimInfoGroupCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockClaimInfoGroupCommand;
      
      public var claimInfoCommandList:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var group:int = 0;
      
      public function ArmoryUnlockClaimInfoGroupCommand(param1:int = 0, param2:Vector.<ArmoryUnlockClaimInfoCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.claimInfoCommandList = new Vector.<ArmoryUnlockClaimInfoCommand>();
         }
         else
         {
            this.claimInfoCommandList = param2;
         }
         this.group = param1;
      }
      
      public static function get instance() : ArmoryUnlockClaimInfoGroupCommand
      {
         return _instance || (_instance = new ArmoryUnlockClaimInfoGroupCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2213;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ArmoryUnlockClaimInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.claimInfoCommandList.length > 0)
         {
            this.claimInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ArmoryUnlockClaimInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.claimInfoCommandList.push(_loc4_);
            _loc2_++;
         }
         this.group = param1.readInt();
         this.group = this.group >>> 11 % 32 | this.group << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ArmoryUnlockClaimInfoCommand = null;
         param1.writeShort(2213);
         param1.writeByte(this.claimInfoCommandList.length);
         for each(_loc2_ in this.claimInfoCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.group << 11 % 32 | this.group >>> 32 - 11 % 32);
      }
   }
}

