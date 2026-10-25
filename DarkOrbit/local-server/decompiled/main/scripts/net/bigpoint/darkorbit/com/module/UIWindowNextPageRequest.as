package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowNextPageRequest implements IModule
   {
      
      private static var _instance:UIWindowNextPageRequest;
      
      public var windowId:int = 0;
      
      public function UIWindowNextPageRequest(param1:int = 0)
      {
         super();
         this.windowId = param1;
      }
      
      public static function get instance() : UIWindowNextPageRequest
      {
         return _instance || (_instance = new UIWindowNextPageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 119;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowId = param1.readInt();
         this.windowId = this.windowId << 7 % 32 | this.windowId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(119);
         param1.writeInt(this.windowId >>> 7 % 32 | this.windowId << 32 - 7 % 32);
      }
   }
}

