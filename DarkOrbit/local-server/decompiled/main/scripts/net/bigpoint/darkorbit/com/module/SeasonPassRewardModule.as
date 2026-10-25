package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRewardModule implements IModule
   {
      
      private static var _instance:SeasonPassRewardModule;
      
      public var amount:int = 0;
      
      public var goldPass:Boolean = false;
      
      public var claimed:Boolean = false;
      
      public var level:int = 0;
      
      public var extGoldPass:Boolean = false;
      
      public var lootId:String = "";
      
      public function SeasonPassRewardModule(param1:String = "", param2:int = 0, param3:int = 0, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.amount = param2;
         this.goldPass = param4;
         this.claimed = param5;
         this.level = param3;
         this.extGoldPass = param6;
         this.lootId = param1;
      }
      
      public static function get instance() : SeasonPassRewardModule
      {
         return _instance || (_instance = new SeasonPassRewardModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20329;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.amount = param1.readInt();
         this.amount = this.amount << 16 % 32 | this.amount >>> 32 - 16 % 32;
         this.goldPass = param1.readBoolean();
         this.claimed = param1.readBoolean();
         this.level = param1.readInt();
         this.level = this.level << 4 % 32 | this.level >>> 32 - 4 % 32;
         this.extGoldPass = param1.readBoolean();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20329);
         param1.writeInt(this.amount >>> 16 % 32 | this.amount << 32 - 16 % 32);
         param1.writeBoolean(this.goldPass);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.level >>> 4 % 32 | this.level << 32 - 4 % 32);
         param1.writeBoolean(this.extGoldPass);
         param1.writeUTF(this.lootId);
      }
   }
}

