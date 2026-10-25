package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EventActivationIntegerAttributeModule extends EventActivationAttributeModule
   {
      
      private static var _instance:EventActivationIntegerAttributeModule;
      
      public var value:int = 0;
      
      public function EventActivationIntegerAttributeModule(param1:int = 0)
      {
         super();
         this.value = param1;
      }
      
      public static function get instance() : EventActivationIntegerAttributeModule
      {
         return _instance || (_instance = new EventActivationIntegerAttributeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 14104;
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
         this.value = this.value >>> 2 % 32 | this.value << 32 - 2 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14104);
         super.write(param1);
         param1.writeInt(this.value << 2 % 32 | this.value >>> 32 - 2 % 32);
      }
   }
}

