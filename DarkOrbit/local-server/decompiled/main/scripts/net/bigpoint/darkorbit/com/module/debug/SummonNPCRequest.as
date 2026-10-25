package net.bigpoint.darkorbit.com.module.debug
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SummonNPCRequest implements IModule
   {
      
      private static var _instance:SummonNPCRequest;
      
      public var amount:int = 0;
      
      public var npcTypeString:String = "";
      
      public function SummonNPCRequest(param1:String = "", param2:int = 0)
      {
         super();
         this.amount = param2;
         this.npcTypeString = param1;
      }
      
      public static function get instance() : SummonNPCRequest
      {
         return _instance || (_instance = new SummonNPCRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9826;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.amount = param1.readInt();
         this.amount = this.amount << 9 % 32 | this.amount >>> 32 - 9 % 32;
         this.npcTypeString = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9826);
         param1.writeInt(this.amount >>> 9 % 32 | this.amount << 32 - 9 % 32);
         param1.writeUTF(this.npcTypeString);
      }
   }
}

