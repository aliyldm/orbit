package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderBonusGGRewardModule implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderBonusGGRewardModule;
      
      public var claimed:Boolean = false;
      
      public var countdown:int = 0;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function GalaxyGateBuilderBonusGGRewardModule(param1:String = "", param2:int = 0, param3:Boolean = false, param4:int = 0)
      {
         super();
         this.claimed = param3;
         this.countdown = param4;
         this.lootId = param1;
         this.amount = param2;
      }
      
      public static function get instance() : GalaxyGateBuilderBonusGGRewardModule
      {
         return _instance || (_instance = new GalaxyGateBuilderBonusGGRewardModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 572;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 11;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.claimed = param1.readBoolean();
         this.countdown = param1.readInt();
         this.countdown = this.countdown >>> 8 % 32 | this.countdown << 32 - 8 % 32;
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 8 % 32 | this.amount >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(572);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.countdown << 8 % 32 | this.countdown >>> 32 - 8 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 8 % 32 | this.amount << 32 - 8 % 32);
      }
   }
}

