package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptchaBoxModule implements IModule
   {
      
      private static var _instance:CaptchaBoxModule;
      
      public static const EBOXTYPE_BLACK:int = 0;
      
      public static const EBOXTYPE_RED:int = 1;
      
      public static const EBOXTYPE__MAX:int = 2;
      
      public var index:int = 0;
      
      public var boxType:int = 0;
      
      public function CaptchaBoxModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.index = param1;
         this.boxType = param2;
      }
      
      public static function get instance() : CaptchaBoxModule
      {
         return _instance || (_instance = new CaptchaBoxModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5030;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.index = param1.readInt();
         this.index = this.index << 6 % 32 | this.index >>> 32 - 6 % 32;
         this.boxType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5030);
         param1.writeInt(this.index >>> 6 % 32 | this.index << 32 - 6 % 32);
         param1.writeShort(this.boxType);
      }
   }
}

