package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCDateValueModule extends CCValueModule
   {
      
      private static var _instance:CCDateValueModule;
      
      public var value:Number = 0;
      
      public function CCDateValueModule(param1:String = "", param2:Number = 0)
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : CCDateValueModule
      {
         return _instance || (_instance = new CCDateValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -18315;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.value = param1.readDouble();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18315);
         super.write(param1);
         param1.writeDouble(this.value);
      }
   }
}

