package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EpicNumberedFightMessageTypeModule extends EpicFightMessageModule
   {
      
      private static var _instance:EpicNumberedFightMessageTypeModule;
      
      public static const EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_NUMBER:int = 0;
      
      public static const EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_COUNTDOWN:int = 1;
      
      public static const EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_ENDS_IN_SECONDS:int = 2;
      
      public static const EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_ENDS_IN_MINUTES:int = 3;
      
      public static const EPICNUMBEREDFIGHTMESSAGETYPE__MAX:int = 4;
      
      public var number:int = 0;
      
      public var type:int = 0;
      
      public function EpicNumberedFightMessageTypeModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.number = param2;
         this.type = param1;
      }
      
      public static function get instance() : EpicNumberedFightMessageTypeModule
      {
         return _instance || (_instance = new EpicNumberedFightMessageTypeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -26215;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.number = param1.readInt();
         this.number = this.number << 11 % 32 | this.number >>> 32 - 11 % 32;
         this.type = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-26215);
         super.write(param1);
         param1.writeInt(this.number >>> 11 % 32 | this.number << 32 - 11 % 32);
         param1.writeShort(this.type);
      }
   }
}

