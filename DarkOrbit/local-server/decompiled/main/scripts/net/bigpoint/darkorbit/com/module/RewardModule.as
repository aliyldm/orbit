package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RewardModule extends RewardContentModule
   {
      
      private static var _instance:RewardModule;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function RewardModule(param1:String = "", param2:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
      }
      
      public static function get instance() : RewardModule
      {
         return _instance || (_instance = new RewardModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 1725;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 13 % 32 | this.amount << 32 - 13 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1725);
         super.write(param1);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount << 13 % 32 | this.amount >>> 32 - 13 % 32);
      }
   }
}

