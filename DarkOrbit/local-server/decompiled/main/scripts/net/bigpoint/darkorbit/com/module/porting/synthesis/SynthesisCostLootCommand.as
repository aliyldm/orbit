package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SynthesisCostLootCommand implements IModule
   {
      
      private static var _instance:SynthesisCostLootCommand;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public var star:int = 0;
      
      public var certain:Boolean = false;
      
      public function SynthesisCostLootCommand(param1:String = "", param2:int = 0, param3:Boolean = false, param4:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
         this.star = param4;
         this.certain = param3;
      }
      
      public static function get instance() : SynthesisCostLootCommand
      {
         return _instance || (_instance = new SynthesisCostLootCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6570;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 11;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 7 % 32 | this.amount << 32 - 7 % 32;
         this.star = param1.readInt();
         this.star = this.star >>> 10 % 32 | this.star << 32 - 10 % 32;
         this.certain = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6570);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount << 7 % 32 | this.amount >>> 32 - 7 % 32);
         param1.writeInt(this.star << 10 % 32 | this.star >>> 32 - 10 % 32);
         param1.writeBoolean(this.certain);
      }
   }
}

