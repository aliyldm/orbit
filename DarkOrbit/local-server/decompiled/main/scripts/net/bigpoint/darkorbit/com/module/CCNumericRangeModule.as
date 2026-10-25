package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCNumericRangeModule extends CCAbstractRangeModule
   {
      
      private static var _instance:CCNumericRangeModule;
      
      public var max:int = 0;
      
      public var min:int = 0;
      
      public function CCNumericRangeModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.max = param2;
         this.min = param1;
      }
      
      public static function get instance() : CCNumericRangeModule
      {
         return _instance || (_instance = new CCNumericRangeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -22404;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.max = param1.readInt();
         this.max = this.max >>> 10 % 32 | this.max << 32 - 10 % 32;
         this.min = param1.readInt();
         this.min = this.min >>> 9 % 32 | this.min << 32 - 9 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22404);
         super.write(param1);
         param1.writeInt(this.max << 10 % 32 | this.max >>> 32 - 10 % 32);
         param1.writeInt(this.min << 9 % 32 | this.min >>> 32 - 9 % 32);
      }
   }
}

