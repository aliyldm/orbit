package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModuleRestabiliseRequest implements IModule
   {
      
      private static var _instance:UnstableModuleRestabiliseRequest;
      
      public var isSalvage:Boolean = false;
      
      public var itemId:int = 0;
      
      public function UnstableModuleRestabiliseRequest(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.isSalvage = param2;
         this.itemId = param1;
      }
      
      public static function get instance() : UnstableModuleRestabiliseRequest
      {
         return _instance || (_instance = new UnstableModuleRestabiliseRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14934;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isSalvage = param1.readBoolean();
         this.itemId = param1.readInt();
         this.itemId = this.itemId << 16 % 32 | this.itemId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14934);
         param1.writeBoolean(this.isSalvage);
         param1.writeInt(this.itemId >>> 16 % 32 | this.itemId << 32 - 16 % 32);
      }
   }
}

