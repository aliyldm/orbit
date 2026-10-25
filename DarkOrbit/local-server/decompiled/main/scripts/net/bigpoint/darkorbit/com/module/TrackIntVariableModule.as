package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrackIntVariableModule extends TrackVariableModule
   {
      
      private static var _instance:TrackIntVariableModule;
      
      public var value:int = 0;
      
      public function TrackIntVariableModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : TrackIntVariableModule
      {
         return _instance || (_instance = new TrackIntVariableModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -7935;
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
         this.value = this.value << 5 % 32 | this.value >>> 32 - 5 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7935);
         super.write(param1);
         param1.writeInt(this.value >>> 5 % 32 | this.value << 32 - 5 % 32);
      }
   }
}

