package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowUpdateRequest implements IModule
   {
      
      private static var _instance:UIWindowUpdateRequest;
      
      public var posX:int = 0;
      
      public var width:int = 0;
      
      public var posY:int = 0;
      
      public var itemId:String = "";
      
      public var height:int = 0;
      
      public var maximized:Boolean = false;
      
      public function UIWindowUpdateRequest(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Boolean = false)
      {
         super();
         this.posX = param2;
         this.width = param4;
         this.posY = param3;
         this.itemId = param1;
         this.height = param5;
         this.maximized = param6;
      }
      
      public static function get instance() : UIWindowUpdateRequest
      {
         return _instance || (_instance = new UIWindowUpdateRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18219;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 19;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.posX = param1.readInt();
         this.posX = this.posX >>> 1 % 32 | this.posX << 32 - 1 % 32;
         this.width = param1.readInt();
         this.width = this.width >>> 10 % 32 | this.width << 32 - 10 % 32;
         this.posY = param1.readInt();
         this.posY = this.posY >>> 9 % 32 | this.posY << 32 - 9 % 32;
         this.itemId = param1.readUTF();
         this.height = param1.readInt();
         this.height = this.height >>> 2 % 32 | this.height << 32 - 2 % 32;
         this.maximized = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18219);
         param1.writeInt(this.posX << 1 % 32 | this.posX >>> 32 - 1 % 32);
         param1.writeInt(this.width << 10 % 32 | this.width >>> 32 - 10 % 32);
         param1.writeInt(this.posY << 9 % 32 | this.posY >>> 32 - 9 % 32);
         param1.writeUTF(this.itemId);
         param1.writeInt(this.height << 2 % 32 | this.height >>> 32 - 2 % 32);
         param1.writeBoolean(this.maximized);
      }
   }
}

