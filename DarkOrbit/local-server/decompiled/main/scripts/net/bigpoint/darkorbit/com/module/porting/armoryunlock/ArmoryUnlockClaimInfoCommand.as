package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockClaimInfoCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockClaimInfoCommand;
      
      public var claimed:Boolean = false;
      
      public var special:Boolean = false;
      
      public var index:int = 0;
      
      public var canClaim:Boolean = false;
      
      public var currentProgress:int = 0;
      
      public var desc:String = "";
      
      public var lootId:String = "";
      
      public var progressQuantity:int = 0;
      
      public var lootAmount:int = 0;
      
      public function ArmoryUnlockClaimInfoCommand(param1:String = "", param2:int = 0, param3:String = "", param4:int = 0, param5:int = 0, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:int = 0)
      {
         super();
         this.claimed = param7;
         this.special = param8;
         this.index = param9;
         this.canClaim = param6;
         this.currentProgress = param5;
         this.desc = param3;
         this.lootId = param1;
         this.progressQuantity = param4;
         this.lootAmount = param2;
      }
      
      public static function get instance() : ArmoryUnlockClaimInfoCommand
      {
         return _instance || (_instance = new ArmoryUnlockClaimInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3135;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.claimed = param1.readBoolean();
         this.special = param1.readBoolean();
         this.index = param1.readInt();
         this.index = this.index >>> 10 % 32 | this.index << 32 - 10 % 32;
         this.canClaim = param1.readBoolean();
         this.currentProgress = param1.readInt();
         this.currentProgress = this.currentProgress >>> 12 % 32 | this.currentProgress << 32 - 12 % 32;
         this.desc = param1.readUTF();
         this.lootId = param1.readUTF();
         this.progressQuantity = param1.readInt();
         this.progressQuantity = this.progressQuantity >>> 9 % 32 | this.progressQuantity << 32 - 9 % 32;
         this.lootAmount = param1.readInt();
         this.lootAmount = this.lootAmount >>> 3 % 32 | this.lootAmount << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3135);
         param1.writeBoolean(this.claimed);
         param1.writeBoolean(this.special);
         param1.writeInt(this.index << 10 % 32 | this.index >>> 32 - 10 % 32);
         param1.writeBoolean(this.canClaim);
         param1.writeInt(this.currentProgress << 12 % 32 | this.currentProgress >>> 32 - 12 % 32);
         param1.writeUTF(this.desc);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.progressQuantity << 9 % 32 | this.progressQuantity >>> 32 - 9 % 32);
         param1.writeInt(this.lootAmount << 3 % 32 | this.lootAmount >>> 32 - 3 % 32);
      }
   }
}

