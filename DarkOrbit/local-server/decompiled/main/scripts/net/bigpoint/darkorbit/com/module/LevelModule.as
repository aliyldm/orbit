package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class LevelModule extends PlayerAttributeModule
   {
      
      private static var _instance:LevelModule;
      
      public var level:int = 0;
      
      public function LevelModule(param1:int = 0)
      {
         super();
         this.level = param1;
      }
      
      public static function get instance() : LevelModule
      {
         return _instance || (_instance = new LevelModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -5208;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.level = param1.readInt();
         this.level = this.level >>> 4 % 32 | this.level << 32 - 4 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5208);
         super.write(param1);
         param1.writeInt(this.level << 4 % 32 | this.level >>> 32 - 4 % 32);
      }
   }
}

