package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCIntValueModule extends CCValueModule
   {
      
      private static var _instance:CCIntValueModule;
      
      public var value:int = 0;
      
      public function CCIntValueModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : CCIntValueModule
      {
         return _instance || (_instance = new CCIntValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -16031;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.value = param1.readInt();
         this.value = this.value << 10 % 32 | this.value >>> 32 - 10 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16031);
         super.write(param1);
         param1.writeInt(this.value >>> 10 % 32 | this.value << 32 - 10 % 32);
      }
   }
}

