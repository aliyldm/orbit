package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCStringValueModule extends CCValueModule
   {
      
      private static var _instance:CCStringValueModule;
      
      public var value:String = "";
      
      public function CCStringValueModule(param1:String = "", param2:String = "")
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : CCStringValueModule
      {
         return _instance || (_instance = new CCStringValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 12053;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.value = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12053);
         super.write(param1);
         param1.writeUTF(this.value);
      }
   }
}

