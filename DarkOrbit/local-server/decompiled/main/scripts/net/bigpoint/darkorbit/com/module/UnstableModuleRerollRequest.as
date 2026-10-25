package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModuleRerollRequest implements IModule
   {
      
      private static var _instance:UnstableModuleRerollRequest;
      
      public var itemId:int = 0;
      
      public var rerollCount:int = 0;
      
      public var rerollCost:int = 0;
      
      public function UnstableModuleRerollRequest(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.itemId = param1;
         this.rerollCount = param3;
         this.rerollCost = param2;
      }
      
      public static function get instance() : UnstableModuleRerollRequest
      {
         return _instance || (_instance = new UnstableModuleRerollRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18820;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readInt();
         this.itemId = this.itemId << 9 % 32 | this.itemId >>> 32 - 9 % 32;
         this.rerollCount = param1.readInt();
         this.rerollCount = this.rerollCount << 10 % 32 | this.rerollCount >>> 32 - 10 % 32;
         this.rerollCost = param1.readInt();
         this.rerollCost = this.rerollCost >>> 15 % 32 | this.rerollCost << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18820);
         param1.writeInt(this.itemId >>> 9 % 32 | this.itemId << 32 - 9 % 32);
         param1.writeInt(this.rerollCount >>> 10 % 32 | this.rerollCount << 32 - 10 % 32);
         param1.writeInt(this.rerollCost << 15 % 32 | this.rerollCost >>> 32 - 15 % 32);
      }
   }
}

