package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CollectBoxRequest implements IModule
   {
      
      private static var _instance:CollectBoxRequest;
      
      public var itemHash:String = "";
      
      public var boxX:int = 0;
      
      public var boxY:int = 0;
      
      public var posX:int = 0;
      
      public var posY:int = 0;
      
      public function CollectBoxRequest(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.itemHash = param1;
         this.boxX = param2;
         this.boxY = param3;
         this.posX = param4;
         this.posY = param5;
      }
      
      public static function get instance() : CollectBoxRequest
      {
         return _instance || (_instance = new CollectBoxRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemHash = param1.readUTF();
         this.boxX = param1.readInt();
         this.boxX = this.boxX << 1 % 32 | this.boxX >>> 32 - 1 % 32;
         this.boxY = param1.readInt();
         this.boxY = this.boxY << 6 % 32 | this.boxY >>> 32 - 6 % 32;
         this.posX = param1.readInt();
         this.posX = this.posX << 10 % 32 | this.posX >>> 32 - 10 % 32;
         this.posY = param1.readInt();
         this.posY = this.posY >>> 7 % 32 | this.posY << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26);
         param1.writeUTF(this.itemHash);
         param1.writeInt(this.boxX >>> 1 % 32 | this.boxX << 32 - 1 % 32);
         param1.writeInt(this.boxY >>> 6 % 32 | this.boxY << 32 - 6 % 32);
         param1.writeInt(this.posX >>> 10 % 32 | this.posX << 32 - 10 % 32);
         param1.writeInt(this.posY << 7 % 32 | this.posY >>> 32 - 7 % 32);
      }
   }
}

