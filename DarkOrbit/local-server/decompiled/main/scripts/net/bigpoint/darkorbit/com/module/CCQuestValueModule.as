package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCQuestValueModule extends CCValueModule
   {
      
      private static var _instance:CCQuestValueModule;
      
      public var value:int = 0;
      
      public function CCQuestValueModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.value = param2;
      }
      
      public static function get instance() : CCQuestValueModule
      {
         return _instance || (_instance = new CCQuestValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -25506;
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
         param1.writeShort(-25506);
         super.write(param1);
         param1.writeInt(this.value >>> 5 % 32 | this.value << 32 - 5 % 32);
      }
   }
}

