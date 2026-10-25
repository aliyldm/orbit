package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCBooleanValueModule extends CCValueModule
   {
      
      private static var _instance:CCBooleanValueModule;
      
      public var value:Boolean = false;
      
      public function CCBooleanValueModule(param1:String = "", param2:Boolean = false)
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : CCBooleanValueModule
      {
         return _instance || (_instance = new CCBooleanValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -11103;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.value = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11103);
         super.write(param1);
         param1.writeBoolean(this.value);
      }
   }
}

