package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCBooleanRangeModule extends CCAbstractRangeModule
   {
      
      private static var _instance:CCBooleanRangeModule;
      
      public function CCBooleanRangeModule()
      {
         super();
      }
      
      public static function get instance() : CCBooleanRangeModule
      {
         return _instance || (_instance = new CCBooleanRangeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -30544;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30544);
         super.write(param1);
      }
   }
}

